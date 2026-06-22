import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../../domain/entities/email_inbox_entity.dart';
import '../../domain/exceptions/email_exception.dart';
import '../providers/email_providers.dart';

class EmailInboxPage extends ConsumerStatefulWidget {
  const EmailInboxPage({super.key});

  @override
  ConsumerState<EmailInboxPage> createState() => _EmailInboxPageState();
}

class _EmailInboxPageState extends ConsumerState<EmailInboxPage>
    with WidgetsBindingObserver {
  bool _isConnecting = false;
  bool _refreshAfterAuthorization = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _refreshAfterAuthorization) {
      _refreshAfterAuthorization = false;
      ref.invalidate(emailInboxProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inbox = ref.watch(emailInboxProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email istituzionale'),
        actions: [
          IconButton(
            tooltip: 'Aggiorna',
            onPressed: () => ref.invalidate(emailInboxProvider),
            icon: const Icon(LucideIcons.refreshCw),
          ),
        ],
      ),
      body: inbox.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => error is EmailAccountNotConnectedException
            ? _ConnectEmailView(
                isConnecting: _isConnecting,
                onConnect: _connectEmail,
              )
            : _EmailErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(emailInboxProvider),
              ),
        data: (data) => _InboxContent(
          inbox: data,
          onRefresh: () async {
            ref.invalidate(emailInboxProvider);
            await ref.read(emailInboxProvider.future);
          },
        ),
      ),
    );
  }

  Future<void> _connectEmail() async {
    if (_isConnecting) return;
    setState(() => _isConnecting = true);
    try {
      final url = await ref
          .read(getEmailAuthorizationUrlUseCaseProvider)
          .call();
      _refreshAfterAuthorization = true;
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!opened) {
        _refreshAfterAuthorization = false;
        throw const EmailException('Impossibile aprire il collegamento email.');
      }
      ref
          .read(toastServiceProvider.notifier)
          .info('Completa l’accesso Microsoft e torna nell’app.');
    } on EmailException catch (error) {
      _refreshAfterAuthorization = false;
      ref.read(toastServiceProvider.notifier).error(error.message);
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }
}

class _InboxContent extends StatelessWidget {
  const _InboxContent({required this.inbox, required this.onRefresh});

  final EmailInboxEntity inbox;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (inbox.messages.isEmpty) {
      return const _EmptyInbox();
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        key: const Key('email-inbox-list'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: inbox.messages.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return _EmailSummaryCard(message: inbox.messages[index]);
        },
      ),
    );
  }
}

class _EmailSummaryCard extends StatelessWidget {
  const _EmailSummaryCard({required this.message});

  final EmailSummaryEntity message;

  @override
  Widget build(BuildContext context) {
    final sender = message.senderName.trim().isNotEmpty
        ? message.senderName
        : message.senderAddress;
    return CustomCardWidget(
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      padding: CardPadding.md,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: message.isRead
                  ? AppColors.colorNeutral300
                  : AppColors.colorPrimaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sender,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.colorNeutral900,
                          fontSize: 12,
                          fontWeight: message.isRead
                              ? FontWeight.w600
                              : FontWeight.w900,
                        ),
                      ),
                    ),
                    if (message.receivedAt != null)
                      Text(
                        _formatDate(message.receivedAt!),
                        style: const TextStyle(
                          color: AppColors.colorNeutral400,
                          fontSize: 10.5,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.colorNeutral900,
                    fontSize: 14,
                    fontWeight: message.isRead
                        ? FontWeight.w700
                        : FontWeight.w900,
                  ),
                ),
                if (message.preview.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    message.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.colorNeutral500,
                      fontSize: 11.5,
                      height: 1.35,
                    ),
                  ),
                ],
                if (message.hasAttachments) ...[
                  const SizedBox(height: 7),
                  const Row(
                    children: [
                      Icon(
                        LucideIcons.paperclip,
                        size: 13,
                        color: AppColors.colorNeutral500,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Allegati',
                        style: TextStyle(
                          color: AppColors.colorNeutral500,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}';
  }
}

class _ConnectEmailView extends StatelessWidget {
  const _ConnectEmailView({
    required this.isConnecting,
    required this.onConnect,
  });

  final bool isConnecting;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.mailCheck,
              size: 44,
              color: AppColors.colorPrimaryDark,
            ),
            const SizedBox(height: 16),
            Text(
              'Collega la tua email',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Accedi con Microsoft per consultare la posta istituzionale.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButtonWidget(
              key: const Key('connect-email-button'),
              label: 'Collega email',
              icon: LucideIcons.externalLink,
              loading: isConnecting,
              onPressed: onConnect,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailErrorView extends StatelessWidget {
  const _EmailErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.cloudOff,
              size: 36,
              color: AppColors.colorNeutral400,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.inbox, size: 38, color: AppColors.colorNeutral400),
            SizedBox(height: 12),
            Text('La casella di posta è vuota.'),
          ],
        ),
      ),
    );
  }
}
