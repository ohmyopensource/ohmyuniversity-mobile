import '../../domain/entities/academic_course_type.dart';
import 'academic_exam_course_model.dart';

class TranscriptResponseModel {
  const TranscriptResponseModel(this.courses);

  final List<AcademicExamCourseModel> courses;

  factory TranscriptResponseModel.fromJson(Map<String, dynamic> json) {
    final rows = json['righe'] as List<dynamic>? ?? const [];
    return TranscriptResponseModel(
      rows
          .whereType<Map<String, dynamic>>()
          .map(_courseFromJson)
          .toList(growable: false),
    );
  }

  static AcademicExamCourseModel _courseFromJson(Map<String, dynamic> json) {
    final grade = (json['voto'] as num?)?.toInt();
    final honors = json['lode'] as bool? ?? false;
    final typeDescription = json['tipoInsDes'] as String? ?? '';

    return AcademicExamCourseModel(
      id: '${json['adsceId'] ?? json['adCod'] ?? ''}',
      year: (json['annoCorso'] as num?)?.toInt() ?? 0,
      semester: 0,
      name: json['adDes'] as String? ?? '',
      code: json['adCod'] as String? ?? '',
      credits: ((json['peso'] as num?)?.toDouble() ?? 0).round(),
      passed:
          json['superata'] as bool? ??
          (json['stato'] as String? ?? '').toUpperCase() == 'S',
      grade: grade == null
          ? null
          : honors
          ? '${grade}L'
          : '$grade',
      completedAt: _parseDate(json['dataEsame'] as String?),
      courseType: typeDescription.toLowerCase().contains('scelta')
          ? AcademicCourseType.elective
          : AcademicCourseType.mandatory,
      scientificSector: json['adCod'] as String? ?? '',
    );
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

class StudyPlanResponseModel {
  const StudyPlanResponseModel(this.courses);

  final List<AcademicExamCourseModel> courses;

  factory StudyPlanResponseModel.fromJson(Map<String, dynamic> json) {
    final rows = json['righe'] as List<dynamic>? ?? const [];
    return StudyPlanResponseModel(
      rows
          .whereType<Map<String, dynamic>>()
          .map(_courseFromJson)
          .toList(growable: false),
    );
  }

  List<AcademicExamCourseModel> mergeTranscript(
    List<AcademicExamCourseModel> transcriptCourses,
  ) {
    final transcriptById = {
      for (final course in transcriptCourses) course.id: course,
    };
    final transcriptByCode = {
      for (final course in transcriptCourses)
        if (course.code.isNotEmpty) course.code: course,
    };
    final mergedIds = <String>{};
    final merged = <AcademicExamCourseModel>[];

    for (final planned in courses) {
      final transcript =
          transcriptById[planned.id] ?? transcriptByCode[planned.code];
      mergedIds.add(transcript?.id ?? planned.id);
      merged.add(
        AcademicExamCourseModel(
          id: planned.id,
          year: planned.year,
          semester: planned.semester,
          name: planned.name,
          code: planned.code,
          credits: planned.credits,
          passed: planned.passed || (transcript?.passed ?? false),
          grade: transcript?.grade,
          completedAt: transcript?.completedAt,
          courseType: planned.courseType,
          scientificSector: planned.scientificSector,
        ),
      );
    }

    merged.addAll(
      transcriptCourses.where((course) => !mergedIds.contains(course.id)),
    );
    return merged;
  }

  static AcademicExamCourseModel _courseFromJson(Map<String, dynamic> json) {
    final mandatory = json['obbligatorio'] as bool?;
    final typeDescription = json['tipoInsDes'] as String? ?? '';
    final isElective =
        mandatory == false || typeDescription.toLowerCase().contains('scelta');

    return AcademicExamCourseModel(
      id: '${json['adsceId'] ?? json['adCod'] ?? ''}',
      year: (json['annoCorso'] as num?)?.toInt() ?? 0,
      semester: 0,
      name: json['adDes'] as String? ?? '',
      code: json['adCod'] as String? ?? '',
      credits: ((json['cfu'] as num?)?.toDouble() ?? 0).round(),
      passed:
          json['superata'] as bool? ??
          (json['stato'] as String? ?? '').toUpperCase() == 'S',
      courseType: isElective
          ? AcademicCourseType.elective
          : AcademicCourseType.mandatory,
      scientificSector: json['adCod'] as String? ?? '',
    );
  }
}

class CareerMetricsModel {
  const CareerMetricsModel({
    required this.arithmeticAverage,
    required this.weightedAverage,
    required this.graduationBase,
    required this.acquiredCredits,
    required this.totalCredits,
  });

  final double? arithmeticAverage;
  final double? weightedAverage;
  final double? graduationBase;
  final int? acquiredCredits;
  final int? totalCredits;

  factory CareerMetricsModel.fromJson(Map<String, dynamic> json) {
    return CareerMetricsModel(
      arithmeticAverage: (json['mediaAritmetica'] as num?)?.toDouble(),
      weightedAverage: (json['mediaPesata'] as num?)?.toDouble(),
      graduationBase: (json['baseMax110'] as num?)?.toDouble(),
      acquiredCredits: (json['cfu'] as num?)?.round(),
      totalCredits: (json['cfuTotali'] as num?)?.round(),
    );
  }
}

class CareerApiDataModel {
  const CareerApiDataModel({
    required this.transcript,
    required this.metrics,
    required this.studyPlan,
  });

  final TranscriptResponseModel transcript;
  final CareerMetricsModel metrics;
  final StudyPlanResponseModel studyPlan;
}
