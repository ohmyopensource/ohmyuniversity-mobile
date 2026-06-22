class EmailInboxEntity {
  const EmailInboxEntity({required this.messages, required this.totalCount});

  final List<EmailSummaryEntity> messages;
  final int totalCount;
}

class EmailSummaryEntity {
  const EmailSummaryEntity({
    required this.id,
    required this.subject,
    required this.senderName,
    required this.senderAddress,
    required this.receivedAt,
    required this.isRead,
    required this.hasAttachments,
    required this.preview,
  });

  final String id;
  final String subject;
  final String senderName;
  final String senderAddress;
  final DateTime? receivedAt;
  final bool isRead;
  final bool hasAttachments;
  final String preview;
}
