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
import '../widgets/identity_provider_button.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';

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
    final theme = Theme.of(context);
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 42, 28, 28),
                        child: Text(
                          'La tua carriera universitaria,\ntutta in un posto',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            height: 1.08,
                          ),
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
                                    Text(
                                      'Ricordami',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () =>
                                          _showIdentityProviderMessage(
                                              'recupero password'),
                                      child: const Text(
                                          'Password dimenticata?'),
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
                              FilledButton(
                                onPressed: _isLoading ? null : _submit,
                                child: _isLoading
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(
                                    isLogin ? 'Accedi' : 'Registrati'),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'O continua con',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: IdentityProviderButton(
                                      label: 'SPID',
                                      onPressed: () =>
                                          _showIdentityProviderMessage(
                                              'SPID'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: IdentityProviderButton(
                                      label: 'CIE',
                                      onPressed: () =>
                                          _showIdentityProviderMessage(
                                              'CIE'),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const SizedBox(height: 28),
                              GestureDetector(
                                onTap: () => context
                                    .goNamed(AppRoutes.orientamentoName),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppColors.textPrimary
                                          .withValues(alpha: 0.72),
                                    ),
                                    children: const [
                                      TextSpan(
                                          text: 'Sei un futuro studente? '),
                                      TextSpan(
                                        text: 'Clicca qui!',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w900,
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