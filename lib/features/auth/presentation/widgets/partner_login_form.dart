import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';
import '../../../../shared/widgets/custom_toast/custom_toast_service.dart';

class PartnerLoginForm extends ConsumerStatefulWidget {
  const PartnerLoginForm({super.key});

  @override
  ConsumerState<PartnerLoginForm> createState() => _PartnerLoginFormState();
}

class _PartnerLoginFormState extends ConsumerState<PartnerLoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _canSubmit =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _notifyLoginUnavailable() {
    if (!_canSubmit) return;
    FocusManager.instance.primaryFocus?.unfocus();
    ref
        .read(toastServiceProvider.notifier)
        .warning('Il login organizzazioni non è ancora attivo.');
  }

  void _notifyRequestUnavailable() {
    ref
        .read(toastServiceProvider.notifier)
        .info('La richiesta di accesso non è ancora disponibile nell\'app.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputWidget(
          key: const Key('partner-email'),
          controller: _emailController,
          type: InputType.email,
          label: 'Email organizzazione',
          placeholder: 'info@azienda.it',
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _notifyLoginUnavailable(),
        ),
        const SizedBox(height: 16),
        CustomInputWidget(
          key: const Key('partner-password'),
          controller: _passwordController,
          type: InputType.password,
          label: 'Password',
          placeholder: '••••••••',
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _notifyLoginUnavailable(),
        ),
        const SizedBox(height: 16),
        CustomButtonWidget(
          key: const Key('partner-submit'),
          label: 'Accedi',
          variant: ButtonVariant.primary,
          size: ButtonSize.md,
          fullWidth: true,
          disabled: !_canSubmit,
          onPressed: _notifyLoginUnavailable,
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const CustomTextWidget(
              text: 'Non hai ancora un account? ',
              variant: TextVariant.caption,
              color: TextColor.subtle,
            ),
            Semantics(
              link: true,
              label: 'Richiedi accesso organizzazione',
              child: InkWell(
                key: const Key('partner-request-link'),
                onTap: _notifyRequestUnavailable,
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CustomTextWidget(
                    text: 'Richiedi l\'accesso per la tua organizzazione',
                    variant: TextVariant.caption,
                    color: TextColor.primary,
                    underline: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
