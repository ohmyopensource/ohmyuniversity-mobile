import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/providers/network_providers.dart';
import '../../data/datasources/email_remote_datasource.dart';
import '../../data/repositories/email_repository_impl.dart';
import '../../domain/entities/email_inbox_entity.dart';
import '../../domain/repositories/email_repository.dart';
import '../../domain/usecases/get_email_authorization_url_usecase.dart';
import '../../domain/usecases/get_email_inbox_usecase.dart';

const _useMockEmail = bool.fromEnvironment('USE_MOCK_EMAIL');

final emailRemoteDataSourceProvider = Provider<EmailRemoteDataSource>((ref) {
  return EmailRemoteDataSource(ref.watch(apiDioProvider));
});

final emailRepositoryProvider = Provider<EmailRepository>((ref) {
  if (_useMockEmail) return const EmailMockRepository();
  return EmailRepositoryImpl(ref.watch(emailRemoteDataSourceProvider));
});

final getEmailAuthorizationUrlUseCaseProvider =
    Provider<GetEmailAuthorizationUrlUseCase>((ref) {
      return GetEmailAuthorizationUrlUseCase(
        ref.watch(emailRepositoryProvider),
      );
    });

final getEmailInboxUseCaseProvider = Provider<GetEmailInboxUseCase>((ref) {
  return GetEmailInboxUseCase(ref.watch(emailRepositoryProvider));
});

final emailInboxProvider = FutureProvider<EmailInboxEntity>((ref) {
  return ref.watch(getEmailInboxUseCaseProvider).call();
});
