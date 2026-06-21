import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';
import '../../../../shared/widgets/custom_text/custom_text_widget.dart';
import '../../domain/entities/login_university.dart';

class UniversitySearchSelect extends StatefulWidget {
  const UniversitySearchSelect({
    super.key,
    required this.universities,
    required this.selected,
    required this.onSelected,
  });

  final List<LoginUniversity> universities;
  final LoginUniversity? selected;
  final ValueChanged<LoginUniversity> onSelected;

  @override
  State<UniversitySearchSelect> createState() => _UniversitySearchSelectState();
}

class _UniversitySearchSelectState extends State<UniversitySearchSelect> {
  final _controller = TextEditingController();
  final _overlayController = OverlayPortalController();
  final _layerLink = LayerLink();
  final _tapRegionGroup = Object();

  String _query = '';
  bool _isOpen = false;

  List<LoginUniversity> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.universities;

    return widget.universities
        .where(
          (university) =>
              university.name.toLowerCase().contains(query) ||
              university.shortName.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.selected?.shortName ?? '';
  }

  @override
  void didUpdateWidget(covariant UniversitySearchSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isOpen && oldWidget.selected?.id != widget.selected?.id) {
      _controller.text = widget.selected?.shortName ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open() {
    if (_isOpen) return;
    _controller.clear();
    setState(() {
      _query = '';
      _isOpen = true;
    });
    _overlayController.show();
  }

  void _onInput(String value) {
    if (!_isOpen) {
      setState(() => _isOpen = true);
      _overlayController.show();
    }
    setState(() => _query = value);
  }

  void _close() {
    if (!_isOpen) return;
    _controller.text = widget.selected?.shortName ?? '';
    setState(() {
      _query = '';
      _isOpen = false;
    });
    _overlayController.hide();
  }

  void _select(LoginUniversity university) {
    _controller.text = university.shortName;
    setState(() {
      _query = '';
      _isOpen = false;
    });
    _overlayController.hide();
    FocusManager.instance.primaryFocus?.unfocus();
    widget.onSelected(university);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TapRegion(
        groupId: _tapRegionGroup,
        onTapOutside: (_) => _close(),
        child: OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: (context) => CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 6),
            child: TapRegion(
              groupId: _tapRegionGroup,
              child: SizedBox(
                width: constraints.maxWidth,
                child: _SearchResults(
                  universities: _filtered,
                  selected: widget.selected,
                  onSelected: _select,
                ),
              ),
            ),
          ),
          child: CompositedTransformTarget(
            link: _layerLink,
            child: CustomInputWidget(
              key: const Key('university-search-input'),
              controller: _controller,
              type: InputType.search,
              label: 'Ateneo',
              placeholder: 'Cerca il tuo ateneo (es. Bologna, Politecnico...)',
              iconLeft: LucideIcons.search,
              clearable: true,
              onFocus: _open,
              onChanged: _onInput,
              onCleared: _open,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.universities,
    required this.selected,
    required this.onSelected,
  });

  final List<LoginUniversity> universities;
  final LoginUniversity? selected;
  final ValueChanged<LoginUniversity> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: const Color(0x33000000),
      borderRadius: BorderRadius.circular(AppColors.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 256),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.colorNeutral200),
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
        ),
        child: universities.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: CustomTextWidget(
                  key: Key('university-search-empty'),
                  text: 'Nessun ateneo trovato.',
                  variant: TextVariant.bodySm,
                  color: TextColor.subtle,
                  align: TextAlign.center,
                ),
              )
            : ListView.builder(
                key: const Key('university-search-results'),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: universities.length,
                itemBuilder: (context, index) {
                  final university = universities[index];
                  final isSelected = selected?.id == university.id;

                  return InkWell(
                    key: Key('university-option-${university.id}'),
                    onTap: () => onSelected(university),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: university.shortName,
                                    style: const TextStyle(
                                      color: AppColors.colorNeutral900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  ${university.name}',
                                    style: const TextStyle(
                                      color: AppColors.colorNeutral400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 12),
                            const Icon(
                              LucideIcons.check,
                              key: Key('university-selected-check'),
                              size: 16,
                              color: AppColors.colorPrimaryDark,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
