import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../../domain/usecases/login_usecase.dart';

const _mockUniversities = [
  'UNIMOL - Universita degli Studi del Molise',
  'UNISA - Universita degli Studi di Salerno',
  'UNIBO - Universita di Bologna',
  'UNIMI - Universita degli Studi di Milano',
  'UNIROMA1 - Sapienza',
  'UNINA - Universita degli Studi di Napoli Federico II',
];

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  String? _selectedUniversity;
  bool _isLoading = false;

  Future<void> _proceed() async {
    final university = _selectedUniversity;
    if (university == null) return;

    setState(() => _isLoading = true);

    await ref
        .read(loginUseCaseProvider)
        .call(LoginParams(university: university));

    if (!mounted) return;

    ref.read(isAuthenticatedProvider.notifier).setAuthenticated(true);

    setState(() => _isLoading = false);
    context.goNamed(AppRoutes.homeName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _LanguageSelector(),
                ),
              ),
              const Spacer(flex: 2),
              Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer.withValues(alpha: 0.42),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/logo.svg',
                    width: 92,
                    height: 92,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'OhMyUniversity!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Accedi',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(flex: 2),
              _UniversityDropdown(
                selected: _selectedUniversity,
                universities: _mockUniversities,
                onChanged: (value) {
                  setState(() => _selectedUniversity = value);
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: (_selectedUniversity != null && !_isLoading)
                    ? _proceed
                    : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Prosegui'),
              ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GestureDetector(
                  onTap: () => context.goNamed(AppRoutes.orientamentoName),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      children: [
                        const TextSpan(text: 'Non ancora studente?\n'),
                        TextSpan(
                          text: 'Clicca qui',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UniversityDropdown extends StatelessWidget {
  const _UniversityDropdown({
    required this.selected,
    required this.universities,
    required this.onChanged,
  });

  final String? selected;
  final List<String> universities;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isExpanded: true,
          hint: Text(
            'Scegli universita',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_up,
            color: colorScheme.onSurfaceVariant,
          ),
          borderRadius: BorderRadius.circular(12),
          items: universities.map((university) {
            return DropdownMenuItem(
              value: university,
              child: Text(university, style: theme.textTheme.bodyMedium),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatefulWidget {
  @override
  State<_LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<_LanguageSelector> {
  String _selected = 'ITA';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['ITA', 'ENG'].map((language) {
          final isSelected = _selected == language;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = language);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primaryContainer : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
