import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';
import '../widgets/partner_login_form.dart';
import '../widgets/university_login_form.dart';

enum LoginMode { university, partner }

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  LoginMode _mode = LoginMode.university;

  void _setMode(String id) {
    final mode = LoginMode.values.firstWhere((value) => value.name == id);
    if (mode == _mode) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _mode = mode);
  }

  void _showUnavailable(String destination) {
    ref
        .read(toastServiceProvider.notifier)
        .info('$destination non è ancora disponibile nell\'app.');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 448),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _BrandHeader(),
                            const SizedBox(height: 32),
                            CustomTabWidget(
                              key: const Key('login-mode-tabs'),
                              tabs: const [
                                TabItem(id: 'university', label: 'Università'),
                                TabItem(id: 'partner', label: 'Partner'),
                              ],
                              activeTab: _mode.name,
                              tabStyle: TabStyle.pill,
                              variant: TabVariant.primary,
                              size: TabSize.sm,
                              fullWidth: true,
                              onTabChange: _setMode,
                            ),
                            const SizedBox(height: 32),
                            if (_mode == LoginMode.university)
                              const UniversityLoginForm(
                                key: ValueKey('university-login-form'),
                              )
                            else
                              const PartnerLoginForm(
                                key: ValueKey('partner-login-form'),
                              ),
                            const SizedBox(height: 24),
                            _OrientationLink(
                              onTap: () =>
                                  context.goNamed(AppRoutes.orientamentoName),
                            ),
                            const SizedBox(height: 24),
                            _LegalFooter(onTap: _showUnavailable),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(AppAssets.logo),
          ),
        ),
        const SizedBox(height: 16),
        const CustomTextWidget(
          text: 'OhMyUniversity!',
          variant: TextVariant.h4,
          weight: TextWeight.bold,
          align: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const CustomTextWidget(
          text: 'by OhMyOpenSource!',
          variant: TextVariant.bodySm,
          color: TextColor.muted,
          align: TextAlign.center,
        ),
      ],
    );
  }
}

class _LegalFooter extends StatelessWidget {
  const _LegalFooter({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const CustomTextWidget(
          text: 'Accedendo accetti i nostri ',
          variant: TextVariant.caption,
          color: TextColor.subtle,
        ),
        _FooterLink(
          key: const Key('terms-link'),
          label: 'Termini & Condizioni',
          onTap: () => onTap('Termini & Condizioni'),
        ),
        const CustomTextWidget(
          text: ' e la ',
          variant: TextVariant.caption,
          color: TextColor.subtle,
        ),
        _FooterLink(
          key: const Key('privacy-link'),
          label: 'Privacy Policy',
          onTap: () => onTap('Privacy Policy'),
        ),
        const CustomTextWidget(
          text: '.',
          variant: TextVariant.caption,
          color: TextColor.subtle,
        ),
      ],
    );
  }
}

class _OrientationLink extends StatelessWidget {
  const _OrientationLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: 'Apri il percorso di orientamento',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CustomTextWidget(
                text: 'Non ancora iscritto? ',
                variant: TextVariant.bodySm,
                color: TextColor.muted,
              ),
              CustomTextWidget(
                text: 'Clicca qui',
                variant: TextVariant.bodySm,
                weight: TextWeight.semibold,
                color: TextColor.primary,
                underline: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: CustomTextWidget(
            text: label,
            variant: TextVariant.caption,
            color: TextColor.muted,
            underline: true,
          ),
        ),
      ),
    );
  }
}
