import '../../domain/entities/email_inbox_entity.dart';

class EmailInboxModel extends EmailInboxEntity {
  const EmailInboxModel({required super.messages, required super.totalCount});

  factory EmailInboxModel.fromJson(Map<String, dynamic> json) {
    final messages = json['messages'] as List<dynamic>? ?? const [];
    return EmailInboxModel(
      messages: messages
          .whereType<Map<String, dynamic>>()
          .map(EmailSummaryModel.fromJson)
          .toList(growable: false),
      totalCount: (json['totalCount'] as num?)?.toInt() ?? messages.length,
    );
  }
}

class EmailSummaryModel extends EmailSummaryEntity {
  const EmailSummaryModel({
    required super.id,
    required super.subject,
    required super.senderName,
    required super.senderAddress,
    required super.receivedAt,
    required super.isRead,
    required super.hasAttachments,
    required super.preview,
  });

  factory EmailSummaryModel.fromJson(Map<String, dynamic> json) {
    return EmailSummaryModel(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? 'Nessun oggetto',
      senderName: json['fromName'] as String? ?? '',
      senderAddress: json['fromAddress'] as String? ?? '',
      receivedAt: DateTime.tryParse(json['receivedAt'] as String? ?? ''),
      isRead: json['isRead'] as bool? ?? false,
      hasAttachments: json['hasAttachments'] as bool? ?? false,
      preview: json['preview'] as String? ?? '',
    );
  }
}
