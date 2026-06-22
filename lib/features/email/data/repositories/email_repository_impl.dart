import '../../domain/entities/email_inbox_entity.dart';
import '../../domain/repositories/email_repository.dart';
import '../datasources/email_remote_datasource.dart';

class EmailRepositoryImpl implements EmailRepository {
  const EmailRepositoryImpl(this._dataSource);

  final EmailRemoteDataSource _dataSource;

  @override
  Future<Uri> getAuthorizationUrl() {
    return _dataSource.getAuthorizationUrl();
  }

  @override
  Future<EmailInboxEntity> getInbox() {
    return _dataSource.getInbox();
  }
}

class EmailMockRepository implements EmailRepository {
  const EmailMockRepository();

  @override
  Future<Uri> getAuthorizationUrl() async {
    return Uri.parse('https://example.com/email-auth');
  }

  @override
  Future<EmailInboxEntity> getInbox() async {
    return EmailInboxEntity(
      totalCount: 2,
      messages: [
        EmailSummaryEntity(
          id: 'mock-1',
          subject: 'Comunicazione dalla Segreteria Studenti',
          senderName: 'Segreteria Studenti',
          senderAddress: 'segreteria@unimol.it',
          receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: false,
          hasAttachments: true,
          preview: 'È disponibile una nuova comunicazione per il tuo corso.',
        ),
        EmailSummaryEntity(
          id: 'mock-2',
          subject: 'Aggiornamento attività didattiche',
          senderName: 'Dipartimento',
          senderAddress: 'dipartimento@unimol.it',
          receivedAt: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          hasAttachments: false,
          preview: 'Consulta il calendario aggiornato delle attività.',
        ),
      ],
    );
  }
}
