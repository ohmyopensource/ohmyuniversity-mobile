import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/timetable_document_entity.dart';
import 'timetable_search_modal.dart';

class TimetableSearchSheet extends StatelessWidget {
  const TimetableSearchSheet({
    super.key,
    required this.documents,
    required this.initialSemester,
    required this.onView,
    required this.onDownload,
  });

  final List<TimetableDocumentEntity> documents;
  final int initialSemester;
  final ValueChanged<TimetableDocumentEntity> onView;
  final ValueChanged<TimetableDocumentEntity> onDownload;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 0, 14, bottomInset + 12),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: CustomCardWidget(
              variant: CardVariant.neutral,
              padding: CardPadding.none,
              shadow: CardShadow.lg,
              radius: CardRadius.lg,
              bordered: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppColors.radiusFull,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TimetableSearchModal(
                        documents: documents,
                        initialSemester: initialSemester,
                        onView: onView,
                        onDownload: onDownload,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
