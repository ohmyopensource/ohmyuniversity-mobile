import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_avatar/custom_avatar_widget.dart';
import '../../domain/entities/student_badge_entity.dart';
import '../providers/student_badge_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badge = ref.watch(studentBadgeProvider);

    return Scaffold(
      key: const Key('profile-page'),
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text('Profilo'),
      ),
      body: SafeArea(
        top: false,
        child: badge.when(
          data: (data) => data == null
              ? const _ProfileUnavailable()
              : _ProfileContent(badge: data),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ProfileError(
            message: error.toString(),
            onRetry: () => ref.invalidate(studentBadgeProvider),
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.badge});

  final StudentBadgeEntity badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoSrc = ref.watch(studentProfilePhotoProvider).value;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(studentBadgeProvider);
        await ref.read(studentBadgeProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          _ProfileHeader(
            name: badge.fullName,
            subtitle: badge.courseName,
            photoSrc: photoSrc,
          ),
          const SizedBox(height: 18),
          Text(
            'Informazioni accademiche',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _ProfileSection(
            children: [
              _ProfileInfoRow(
                icon: LucideIcons.creditCard,
                label: 'Matricola',
                value: badge.studentNumber,
              ),
              _ProfileInfoRow(
                icon: LucideIcons.university,
                label: 'Ateneo',
                value: badge.universityName,
              ),
              _ProfileInfoRow(
                icon: LucideIcons.bookOpen,
                label: 'Corso di laurea',
                value: badge.courseName,
              ),
              if (badge.facultyName.isNotEmpty)
                _ProfileInfoRow(
                  icon: LucideIcons.graduationCap,
                  label: 'Dipartimento',
                  value: badge.facultyName,
                ),
              if (badge.academicYear.isNotEmpty)
                _ProfileInfoRow(
                  icon: LucideIcons.calendarDays,
                  label: 'Anno accademico',
                  value: badge.academicYear,
                ),
              if (badge.statusCode.isNotEmpty)
                _ProfileInfoRow(
                  icon: LucideIcons.badgeCheck,
                  label: 'Stato carriera',
                  value: badge.statusCode,
                ),
              if (badge.rfid.isNotEmpty)
                _ProfileInfoRow(
                  icon: LucideIcons.scanLine,
                  label: 'RFID badge',
                  value: badge.rfid,
                  showDivider: false,
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Dati personali',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _ProfileSection(
            children: [
              _ProfileInfoRow(
                icon: LucideIcons.user,
                label: 'Nome',
                value: badge.firstName,
              ),
              _ProfileInfoRow(
                icon: LucideIcons.userRound,
                label: 'Cognome',
                value: badge.lastName,
              ),
              if (badge.taxCode.isNotEmpty)
                _ProfileInfoRow(
                  icon: LucideIcons.fingerprint,
                  label: 'Codice fiscale',
                  value: badge.taxCode,
                ),
              if (badge.validFrom != null)
                _ProfileInfoRow(
                  icon: LucideIcons.calendarCheck,
                  label: 'Valido dal',
                  value: _formatDate(badge.validFrom!),
                ),
              if (badge.validUntil != null)
                _ProfileInfoRow(
                  icon: LucideIcons.calendarClock,
                  label: 'Valido fino al',
                  value: _formatDate(badge.validUntil!),
                  showDivider: false,
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.subtitle,
    required this.photoSrc,
  });

  final String name;
  final String subtitle;
  final String? photoSrc;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      children: [
        Row(
          children: [
            _ProfileAvatar(name: name, photoSrc: photoSrc),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty ? 'Studente' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle.isEmpty ? 'Corso non disponibile' : subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.colorSuccessLight.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Profilo universitario',
                      style: TextStyle(
                        color: AppColors.colorSuccessText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.name, required this.photoSrc});

  final String name;
  final String? photoSrc;

  @override
  Widget build(BuildContext context) {
    return CustomAvatarWidget(
      src: photoSrc,
      name: name.isEmpty ? 'Studente' : name,
      size: AvatarSize.xl,
      variant: AvatarVariant.success,
      showRing: true,
      ringColor: AppColors.colorSuccessDark,
      dotStatus: AvatarDotStatus.online,
    );
  }
}

class _ProfileUnavailable extends StatelessWidget {
  const _ProfileUnavailable();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Nessun profilo universitario disponibile per questa carriera.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});

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
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 17),
              label: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.colorNeutral200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.colorPrimaryLight.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: AppColors.colorPrimaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.colorNeutral500,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value.isEmpty ? 'Non disponibile' : value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.colorNeutral200),
      ],
    );
  }
}
