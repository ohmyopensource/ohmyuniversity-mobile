import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

const _kOnboardingKey = 'onboarding_completed';

@riverpod
class OnboardingCompleted extends _$OnboardingCompleted {
  @override
  bool build() => false;

  void setCompleted(bool value) => state = value;
}

@riverpod
Future<bool> onboardingLoader(Ref ref) async {
  const storage = FlutterSecureStorage();
  final value = await storage.read(key: _kOnboardingKey);
  final completed = value == 'true';
  ref.read(onboardingCompletedProvider.notifier).setCompleted(completed);
  return completed;
}

Future<void> completeOnboarding(WidgetRef ref) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: _kOnboardingKey, value: 'true');
  ref.read(onboardingCompletedProvider.notifier).setCompleted(true);
}
