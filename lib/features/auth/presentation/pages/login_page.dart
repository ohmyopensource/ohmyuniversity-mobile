import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_mode_selector.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthFormMode _mode = AuthFormMode.login;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _changeMode(AuthFormMode mode) {
    if (_mode == mode) return;
    FocusScope.of(context).unfocus();
    setState(() => _mode = mode);
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      if (_mode == AuthFormMode.login) {
        await ref.read(loginUseCaseProvider).call(
          LoginParams(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
      } else {
        await ref.read(registerUseCaseProvider).call(
          RegisterParams(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
      }

      if (!mounted) return;
      ref.read(isAuthenticatedProvider.notifier).setAuthenticated(true);
      context.goNamed(AppRoutes.homeName);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Accesso non riuscito. Riprova.')),
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showIdentityProviderMessage(String provider) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Accesso con $provider disponibile a breve.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _mode == AuthFormMode.login;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints:
                BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // ── Headline ─────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 42, 28, 28),
                        child: CustomTextWidget(
                          text:
                          'La tua carriera universitaria,\ntutta in un posto',
                          variant: TextVariant.h3,
                          color: TextColor.defaultColor,
                          weight: TextWeight.extraBold,
                          align: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          constraints:
                          const BoxConstraints(minHeight: 590),
                          padding:
                          const EdgeInsets.fromLTRB(22, 26, 22, 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF6F8),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(36),
                            ),
                            border: Border(
                              top: BorderSide(
                                color: AppColors.secondary
                                    .withValues(alpha: 0.42),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              AuthModeSelector(
                                mode: _mode,
                                onChanged: _changeMode,
                              ),
                              const SizedBox(height: 22),

                              // ── Tab Accedi ─────────────────────────
                              if (isLogin) ...[
                                CustomInputWidget(
                                  controller: _emailController,
                                  label: 'Email',
                                  placeholder: 'Inserisci la tua email',
                                  type: InputType.email,
                                  iconLeft: LucideIcons.mail,
                                  variant: InputVariant.info,
                                  required: true,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 14),
                                CustomInputWidget(
                                  controller: _passwordController,
                                  label: 'Password',
                                  placeholder: 'Inserisci la tua password',
                                  type: InputType.password,
                                  iconLeft: LucideIcons.lock,
                                  variant: InputVariant.info,
                                  required: true,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) => setState(
                                            () => _rememberMe = value ?? false,
                                      ),
                                    ),
                                    // ── Ricordami ──────────────────
                                    const CustomTextWidget(
                                      text: 'Ricordami',
                                      variant: TextVariant.bodySm,
                                      color: TextColor.defaultColor,
                                      weight: TextWeight.bold,
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () =>
                                          _showIdentityProviderMessage(
                                              'recupero password'),
                                      child: const CustomTextWidget(
                                        text: 'Password dimenticata?',
                                        variant: TextVariant.bodySm,
                                        color: TextColor.primary,
                                        weight: TextWeight.semibold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              // ── Tab Registrati ─────────────────────
                              if (!isLogin) ...[
                                CustomInputWidget(
                                  controller: _firstNameController,
                                  label: 'Nome',
                                  placeholder: 'Inserisci il tuo nome',
                                  iconLeft: LucideIcons.user,
                                  variant: InputVariant.info,
                                  required: true,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 14),
                                CustomInputWidget(
                                  controller: _lastNameController,
                                  label: 'Cognome',
                                  placeholder: 'Inserisci il tuo cognome',
                                  iconLeft: LucideIcons.user,
                                  variant: InputVariant.info,
                                  required: true,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 14),
                                CustomInputWidget(
                                  controller: _emailController,
                                  label: 'Email',
                                  placeholder: 'Inserisci la tua email',
                                  type: InputType.email,
                                  iconLeft: LucideIcons.mail,
                                  variant: InputVariant.info,
                                  required: true,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 14),
                                CustomInputWidget(
                                  controller: _passwordController,
                                  label: 'Password',
                                  placeholder: 'Inserisci la tua password',
                                  type: InputType.password,
                                  iconLeft: LucideIcons.lock,
                                  variant: InputVariant.info,
                                  required: true,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ],

                              const SizedBox(height: 8),

                              // ── Submit button ──────────────────────
                              CustomButtonWidget(
                                label: isLogin ? 'Accedi' : 'Registrati',
                                variant: ButtonVariant.primary,
                                size: ButtonSize.md,
                                fullWidth: true,
                                loading: _isLoading,
                                onPressed: _submit,
                              ),

                              const SizedBox(height: 24),

                              // ── O continua con ─────────────────────
                              const CustomTextWidget(
                                text: 'O continua con',
                                variant: TextVariant.label,
                                color: TextColor.primary,
                                weight: TextWeight.extraBold,
                              ),
                              const SizedBox(height: 10),

                              // ── Identity providers ─────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButtonWidget(
                                      label: 'SPID',
                                      variant: ButtonVariant.outline,
                                      size: ButtonSize.md,
                                      fullWidth: true,
                                      onPressed: () =>
                                          _showIdentityProviderMessage(
                                              'SPID'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: CustomButtonWidget(
                                      label: 'CIE',
                                      variant: ButtonVariant.outline,
                                      size: ButtonSize.md,
                                      fullWidth: true,
                                      onPressed: () =>
                                          _showIdentityProviderMessage(
                                              'CIE'),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),
                              const SizedBox(height: 28),

                              // ── Sei un futuro studente? ────────────
                              GestureDetector(
                                onTap: () => context
                                    .goNamed(AppRoutes.orientamentoName),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    CustomTextWidget(
                                      text: 'Sei un futuro studente? ',
                                      variant: TextVariant.bodySm,
                                      color: TextColor.muted,
                                    ),
                                    CustomTextWidget(
                                      text: 'Clicca qui!',
                                      variant: TextVariant.bodySm,
                                      color: TextColor.primary,
                                      weight: TextWeight.extraBold,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}