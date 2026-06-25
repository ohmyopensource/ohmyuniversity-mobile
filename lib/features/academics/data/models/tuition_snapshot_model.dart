import '../../domain/entities/tuition_fee_entity.dart';
import '../../domain/entities/tuition_snapshot_entity.dart';

class TuitionSnapshotModel extends TuitionSnapshotEntity {
  const TuitionSnapshotModel({
    required super.status,
    required super.totalDue,
    required super.fees,
  });

  factory TuitionSnapshotModel.fromJson(Map<String, dynamic> json) {
    final charges = json['addebiti'] as List<dynamic>? ?? const [];
    final fees = charges
        .whereType<Map<String, dynamic>>()
        .where((charge) => (charge['annullataFlg'] as num?)?.toInt() != 1)
        .map(_feeFromCharge)
        .toList(growable: true);

    if (fees.isEmpty) {
      fees
        ..addAll(_fallbackFees(json['tasseScadute'], isOverdue: true))
        ..addAll(_fallbackFees(json['tasseDovute'], isOverdue: false));
    }

    return TuitionSnapshotModel(
      status: json['semaforo'] as String? ?? '',
      totalDue: _parseAmount(json['importoDovuto']),
      fees: fees,
    );
  }

  static TuitionFeeEntity _feeFromCharge(Map<String, dynamic> json) {
    final isPaid = (json['pagatoFlg'] as num?)?.toInt() == 1;
    final isOverdue =
        !isPaid &&
        ((json['scadutoFlg'] as num?)?.toInt() == 1 ||
            (json['fattScadutaFlg'] as num?)?.toInt() == 1);
    final title = _firstNonEmpty([
      json['rataDes'],
      json['voceDes'],
      json['tassaDes'],
      json['tassaCod'],
    ]);
    final referenceDate = isPaid
        ? _parseDate(json['dataPagamento'] as String?)
        : _parseDate(
            json['scadFattura'] as String? ??
                json['scadenzaAddebito'] as String?,
          );

    return TuitionFeeEntity(
      id: '${json['fattId'] ?? json['codiceAvviso'] ?? title}',
      title: title.isEmpty ? 'Contributo universitario' : title,
      amount: _parseAmount(
        json['importoVoce'] ?? json['importoFattura'] ?? json['importoPag'],
      ),
      isPaid: isPaid,
      isOverdue: isOverdue,
      receiptAvailable: isPaid && json['fattId'] != null,
      academicYear: _academicYear(json['aaId']),
      referenceDate: referenceDate,
    );
  }

  static Iterable<TuitionFeeEntity> _fallbackFees(
    dynamic rawFees, {
    required bool isOverdue,
  }) sync* {
    final fees = rawFees as List<dynamic>? ?? const [];
    for (final json in fees.whereType<Map<String, dynamic>>()) {
      final title = _firstNonEmpty([
        json['voceDes'],
        json['tassaDes'],
        json['voceCod'],
      ]);
      yield TuitionFeeEntity(
        id: '${json['fattId'] ?? json['voceId'] ?? title}',
        title: title.isEmpty ? 'Contributo universitario' : title,
        amount: _parseAmount(json['importoVoce']),
        isPaid: false,
        isOverdue: isOverdue,
        receiptAvailable: false,
        referenceDate: _parseDate(json['dataScadenza'] as String?),
      );
    }
  }

  static String _firstNonEmpty(List<dynamic> values) {
    return values
        .whereType<String>()
        .map((value) => value.trim())
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
  }

  static String? _academicYear(dynamic value) {
    final year = value is num ? value.toInt() : int.tryParse('$value');
    if (year == null || year <= 0) return null;
    return 'A.A. $year/${year + 1}';
  }

  static double _parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is! String) return 0;
    final cleanValue = value.replaceAll('€', '').replaceAll(' ', '');
    final normalized = cleanValue.contains(',')
        ? cleanValue.replaceAll('.', '').replaceAll(',', '.')
        : cleanValue;
    return double.tryParse(normalized) ?? 0;
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim();
    final isoDate = DateTime.tryParse(normalized);
    if (isoDate != null) return isoDate;

    final match = RegExp(
      r'^(\d{1,2})/(\d{1,2})/(\d{4})',
    ).firstMatch(normalized);
    if (match == null) return null;
    return DateTime(
      int.parse(match.group(3)!),
      int.parse(match.group(2)!),
      int.parse(match.group(1)!),
    );
  }
}
