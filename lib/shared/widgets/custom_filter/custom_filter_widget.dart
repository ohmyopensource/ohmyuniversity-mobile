// @file custom_filter_widget.dart
// @description Configurable filter UI: search input, select filters,
// chip-based filters, and action controls (search + reset).
// Emits a unified FilterState on search and reset actions.

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

// ─── Domain types ─────────────────────────────────────────────────────────────

/// A single option for select or chip filters.
class FilterSelectOption {
  const FilterSelectOption({required this.label, required this.value});

  final String label;
  final Object value; // String or int
}

/// Configuration for a select-based filter.
class FilterSelectConfig {
  const FilterSelectConfig({
    required this.key,
    required this.label,
    this.placeholder,
    required this.options,
  });

  final String key;
  final String label;
  final String? placeholder;
  final List<FilterSelectOption> options;
}

/// Configuration for a chip-based filter group.
class FilterChipConfig {
  const FilterChipConfig({
    required this.key,
    required this.label,
    required this.options,
    this.multiple = false,
  });

  final String key;
  final String label;
  final List<FilterSelectOption> options;

  /// When false only one chip per group can be active at a time.
  final bool multiple;
}

/// Snapshot of the current filter state emitted to the parent.
class FilterState {
  const FilterState({
    required this.search,
    required this.selects,
    required this.chips,
  });

  final String search;
  final Map<String, Object?> selects; // key → value | null
  final Map<String, List<Object>> chips; // key → selected values

  @override
  String toString() =>
      'FilterState(search: $search, selects: $selects, chips: $chips)';
}

/// Component size variant.
enum FilterSize { sm, md, lg }

/// Color variant — drives accent colours on interactive elements.
enum FilterVariant { primary, secondary, tertiary, success, info }

// ─── Widget ───────────────────────────────────────────────────────────────────

/// Configurable filter widget combining search, select and chip filters.
///
/// Usage:
/// ```dart
/// CustomFilterWidget(
///   selects: const [
///     FilterSelectConfig(key: 'year', label: 'Anno', options: [...]),
///   ],
///   chips: const [
///     FilterChipConfig(key: 'status', label: 'Stato', options: [...]),
///   ],
///   onFilterChange: (state) { /* apply filters */ },
/// )
/// ```
class CustomFilterWidget extends StatefulWidget {
  const CustomFilterWidget({
    super.key,
    this.searchPlaceholder = 'Search...',
    this.selects = const [],
    this.chips = const [],
    this.showActiveCount = true,
    this.searchLabel = 'Search',
    this.resetLabel = 'Reset',
    this.variant = FilterVariant.primary,
    this.size = FilterSize.md,
    this.darkTheme = false,
    this.initialState,
    this.onFilterChange,
    this.onFilterReset,
  });

  final String searchPlaceholder;
  final List<FilterSelectConfig> selects;
  final List<FilterChipConfig> chips;
  final bool showActiveCount;
  final String searchLabel;
  final String resetLabel;
  final FilterVariant variant;
  final FilterSize size;
  final bool darkTheme;
  final FilterState? initialState;

  /// Emitted when search is executed.
  final ValueChanged<FilterState>? onFilterChange;

  /// Emitted when filters are reset.
  final ValueChanged<FilterState>? onFilterReset;

  @override
  State<CustomFilterWidget> createState() => _CustomFilterWidgetState();
}

class _CustomFilterWidgetState extends State<CustomFilterWidget> {
  late final TextEditingController _searchCtrl;
  late Map<String, Object?> _selectValues;
  late Map<String, List<Object>> _chipValues;

  // ── Lifecycle ──────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _searchCtrl = TextEditingController(
      text: widget.initialState?.search ?? '',
    );

    _selectValues = {
      for (final s in widget.selects)
        s.key: widget.initialState?.selects[s.key],
    };

    _chipValues = {
      for (final c in widget.chips)
        c.key: List<Object>.from(widget.initialState?.chips[c.key] ?? const []),
    };
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Computed ───────────────────────────────────────────────────────────

  int get _activeFilterCount {
    int count = 0;
    for (final v in _selectValues.values) {
      if (v != null && v != '') count++;
    }
    for (final arr in _chipValues.values) {
      if (arr.isNotEmpty) count++;
    }
    return count;
  }

  bool get _hasAnyFilter =>
      _searchCtrl.text.trim().isNotEmpty || _activeFilterCount > 0;

  FilterState _buildState() => FilterState(
    search: _searchCtrl.text.trim(),
    selects: Map.unmodifiable(_selectValues),
    chips: Map.unmodifiable({
      for (final e in _chipValues.entries) e.key: List.unmodifiable(e.value),
    }),
  );

  // ── Actions ────────────────────────────────────────────────────────────

  void _onSearch() => widget.onFilterChange?.call(_buildState());

  void _onReset() {
    setState(() {
      _searchCtrl.clear();
      for (final k in _selectValues.keys) {
        _selectValues[k] = null;
      }
      for (final k in _chipValues.keys) {
        _chipValues[k] = [];
      }
    });
    final empty = _buildState();
    widget.onFilterReset?.call(empty);
    widget.onFilterChange?.call(empty);
  }

  void _toggleChip(String groupKey, Object value, bool multiple) {
    setState(() {
      final current = _chipValues[groupKey] ?? [];
      if (multiple) {
        if (current.contains(value)) {
          _chipValues[groupKey] = current.where((v) => v != value).toList();
        } else {
          _chipValues[groupKey] = [...current, value];
        }
      } else {
        _chipValues[groupKey] = current.contains(value) ? [] : [value];
      }
    });
  }

  // ── Theme tokens ───────────────────────────────────────────────────────

  ({
    Color accentLight,
    Color accentDark,
    Color accentText,
    Color accentShadow,
    Color focusColor,
  })
  get _variantColors => switch (widget.variant) {
    FilterVariant.primary => (
      accentLight: AppColors.colorPrimaryLight,
      accentDark: AppColors.colorPrimaryDark,
      accentText: AppColors.colorPrimaryText,
      accentShadow: AppColors.colorPrimaryShadow,
      focusColor: AppColors.colorPrimaryFocus,
    ),
    FilterVariant.secondary => (
      accentLight: AppColors.colorSecondaryLight,
      accentDark: AppColors.colorSecondaryDark,
      accentText: AppColors.colorSecondaryText,
      accentShadow: AppColors.colorSecondaryShadow,
      focusColor: AppColors.colorSecondaryFocus,
    ),
    FilterVariant.tertiary => (
      accentLight: AppColors.colorTertiaryLight,
      accentDark: AppColors.colorTertiaryDark,
      accentText: AppColors.colorTertiaryText,
      accentShadow: AppColors.colorTertiaryShadow,
      focusColor: AppColors.colorTertiaryFocus,
    ),
    FilterVariant.success => (
      accentLight: AppColors.colorSuccessLight,
      accentDark: AppColors.colorSuccessDark,
      accentText: AppColors.colorSuccessText,
      accentShadow: AppColors.colorSuccessShadow,
      focusColor: AppColors.colorSuccessFocus,
    ),
    FilterVariant.info => (
      accentLight: AppColors.colorInfoLight,
      accentDark: AppColors.colorInfoDark,
      accentText: AppColors.colorInfoText,
      accentShadow: AppColors.colorInfoShadow,
      focusColor: AppColors.colorInfoFocus,
    ),
  };

  Color get _inputBg =>
      widget.darkTheme ? AppColors.colorNeutral600 : AppColors.colorNeutral100;

  Color get _inputBorder =>
      widget.darkTheme ? AppColors.colorNeutral500 : AppColors.colorNeutral300;

  Color get _inputText =>
      widget.darkTheme ? AppColors.colorNeutral200 : AppColors.colorNeutral600;

  Color get _placeholderColor => AppColors.colorNeutral400;

  Color get _labelColor =>
      widget.darkTheme ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

  Color get _chipIdleText =>
      widget.darkTheme ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

  Color get _chipIdleBorder =>
      widget.darkTheme ? AppColors.colorNeutral500 : AppColors.colorNeutral300;

  Color get _chipHoverBg =>
      widget.darkTheme ? AppColors.colorNeutral600 : AppColors.colorNeutral200;

  Color get _resetBtnText =>
      widget.darkTheme ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

  Color get _resetBtnBorder =>
      widget.darkTheme ? AppColors.colorNeutral500 : AppColors.colorNeutral300;

  // ── Size tokens ────────────────────────────────────────────────────────

  double get _fontSize => switch (widget.size) {
    FilterSize.sm => 12.8,
    FilterSize.md => 14.0,
    FilterSize.lg => 16.0,
  };

  double get _searchIconSize => switch (widget.size) {
    FilterSize.sm => 14.0,
    FilterSize.md => 16.0,
    FilterSize.lg => 18.0,
  };

  double get _clearIconSize => switch (widget.size) {
    FilterSize.sm => 12.0,
    FilterSize.md => 14.0,
    FilterSize.lg => 16.0,
  };

  double get _btnIconSize => switch (widget.size) {
    FilterSize.sm => 13.0,
    FilterSize.md => 15.0,
    FilterSize.lg => 17.0,
  };

  EdgeInsets get _inputPadding => switch (widget.size) {
    FilterSize.sm => const EdgeInsets.fromLTRB(36, 8, 32, 8),
    FilterSize.md => const EdgeInsets.fromLTRB(38, 10, 34, 10),
    FilterSize.lg => const EdgeInsets.fromLTRB(42, 12, 38, 12),
  };

  EdgeInsets get _btnPadding => switch (widget.size) {
    FilterSize.sm => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    FilterSize.md => const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    FilterSize.lg => const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  };

  // ── Search input ───────────────────────────────────────────────────────

  Widget _buildSearchInput() {
    final vc = _variantColors;
    return Expanded(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Input field
          TextField(
            controller: _searchCtrl,
            onSubmitted: (_) => _onSearch(),
            onChanged: (_) => setState(() {}),
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
              color: _inputText,
            ),
            decoration: InputDecoration(
              hintText: widget.searchPlaceholder,
              hintStyle: TextStyle(
                color: _placeholderColor,
                fontWeight: FontWeight.w400,
                fontSize: _fontSize,
              ),
              contentPadding: _inputPadding,
              filled: true,
              fillColor: _inputBg,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _inputBorder, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: vc.accentDark, width: 1.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _inputBorder, width: 1.5),
              ),
              isDense: true,
            ),
          ),

          // Search icon (left)
          Positioned(
            left: 10,
            child: Icon(
              LucideIcons.search,
              size: _searchIconSize,
              color: _placeholderColor,
            ),
          ),

          // Clear button (right)
          if (_searchCtrl.text.isNotEmpty)
            Positioned(
              right: 6,
              child: GestureDetector(
                onTap: () => setState(() => _searchCtrl.clear()),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.x,
                    size: _clearIconSize,
                    color: _placeholderColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Search button ──────────────────────────────────────────────────────

  Widget _buildSearchButton() {
    final vc = _variantColors;
    return _GradientButton(
      onTap: _onSearch,
      padding: _btnPadding,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [vc.accentLight, vc.accentDark],
      ),
      borderColor: vc.accentDark,
      shadow: BoxShadow(
        color: vc.accentShadow,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.search, size: _btnIconSize, color: vc.accentText),
          const SizedBox(width: 6),
          Text(
            widget.searchLabel,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: vc.accentText,
            ),
          ),
        ],
      ),
    );
  }

  // ── Reset button ───────────────────────────────────────────────────────

  Widget _buildResetButton() {
    return _OutlineButton(
      onTap: _onReset,
      padding: _btnPadding,
      borderColor: _resetBtnBorder,
      hoverColor: _chipHoverBg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.rotateCcw, size: _btnIconSize, color: _resetBtnText),
          const SizedBox(width: 6),
          Text(
            widget.resetLabel,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: _resetBtnText,
            ),
          ),
        ],
      ),
    );
  }

  // ── Active filters badge ───────────────────────────────────────────────

  Widget _buildActiveBadge() {
    final vc = _variantColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [vc.accentLight, vc.accentDark],
        ),
        border: Border.all(color: vc.accentDark, width: 1.5),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.funnel, size: 10, color: vc.accentText),
          const SizedBox(width: 4),
          Text(
            '$_activeFilterCount',
            style: TextStyle(
              fontSize: _fontSize * 0.7,
              fontWeight: FontWeight.w700,
              color: vc.accentText,
            ),
          ),
        ],
      ),
    );
  }

  // ── Select filters ─────────────────────────────────────────────────────

  Widget _buildSelects() {
    if (widget.selects.isEmpty) return const SizedBox.shrink();
    final vc = _variantColors;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.selects.map((sel) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label
              Text(
                sel.label.toUpperCase(),
                style: TextStyle(
                  fontSize: _fontSize * 0.72,
                  fontWeight: FontWeight.w700,
                  color: _labelColor,
                  letterSpacing: 0.05 * _fontSize,
                ),
              ),
              const SizedBox(height: 4),
              // Dropdown
              Container(
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _inputBorder, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Object?>(
                    value: _selectValues[sel.key],
                    isExpanded: true,
                    icon: Icon(
                      LucideIcons.chevronDown,
                      size: 14,
                      color: _placeholderColor,
                    ),
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.w500,
                      color: _inputText,
                    ),
                    dropdownColor: widget.darkTheme
                        ? AppColors.colorNeutral600
                        : Colors.white,
                    focusColor: vc.focusColor.withValues(alpha: 0.12),
                    items: [
                      DropdownMenuItem<Object?>(
                        value: null,
                        child: Text(
                          sel.placeholder ?? 'All',
                          style: TextStyle(color: _placeholderColor),
                        ),
                      ),
                      ...sel.options.map(
                        (opt) => DropdownMenuItem<Object?>(
                          value: opt.value,
                          child: Text(opt.label),
                        ),
                      ),
                    ],
                    onChanged: (val) =>
                        setState(() => _selectValues[sel.key] = val),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Chip filters ───────────────────────────────────────────────────────

  Widget _buildChips() {
    if (widget.chips.isEmpty) return const SizedBox.shrink();
    final vc = _variantColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.chips.map((group) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group label
              Text(
                group.label.toUpperCase(),
                style: TextStyle(
                  fontSize: _fontSize * 0.72,
                  fontWeight: FontWeight.w700,
                  color: _labelColor,
                  letterSpacing: 0.05 * _fontSize,
                ),
              ),
              const SizedBox(height: 6),
              // Chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: group.options.map((opt) {
                  final active = (_chipValues[group.key] ?? []).contains(
                    opt.value,
                  );
                  return _FilterChip(
                    label: opt.label,
                    active: active,
                    fontSize: _fontSize,
                    activeGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [vc.accentLight, vc.accentDark],
                    ),
                    activeBorderColor: vc.accentDark,
                    activeTextColor: vc.accentText,
                    activeShadow: BoxShadow(
                      color: vc.accentShadow,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                    idleTextColor: _chipIdleText,
                    idleBorderColor: _chipIdleBorder,
                    hoverColor: _chipHoverBg,
                    onTap: () =>
                        _toggleChip(group.key, opt.value, group.multiple),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Main row ────────────────────────────────────────────────────
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Search input takes remaining width
            IntrinsicWidth(
              stepWidth: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 220),
                child: Row(children: [_buildSearchInput()]),
              ),
            ),
            _buildSearchButton(),
            if (_hasAnyFilter) _buildResetButton(),
            if (widget.showActiveCount && _activeFilterCount > 0)
              _buildActiveBadge(),
          ],
        ),

        // ── Selects ─────────────────────────────────────────────────────
        if (widget.selects.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildSelects(),
        ],

        // ── Chips ───────────────────────────────────────────────────────
        if (widget.chips.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildChips(),
        ],
      ],
    );
  }
}

// ─── Internal sub-widgets ─────────────────────────────────────────────────────

/// Gradient-filled button used for the primary search action.
class _GradientButton extends StatefulWidget {
  const _GradientButton({
    required this.onTap,
    required this.padding,
    required this.gradient,
    required this.borderColor,
    required this.shadow,
    required this.child,
  });

  final VoidCallback onTap;
  final EdgeInsets padding;
  final LinearGradient gradient;
  final Color borderColor;
  final BoxShadow shadow;
  final Widget child;

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: widget.padding,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.shadow.color,
                blurRadius: _hovered
                    ? widget.shadow.blurRadius * 1.75
                    : widget.shadow.blurRadius,
                offset: _hovered ? const Offset(0, 4) : widget.shadow.offset,
              ),
            ],
          ),
          transform: _hovered
              ? (Matrix4.identity()..translateByDouble(0.0, -1.0, 0.0, 1.0))
              : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Outline button used for the reset action.
class _OutlineButton extends StatefulWidget {
  const _OutlineButton({
    required this.onTap,
    required this.padding,
    required this.borderColor,
    required this.hoverColor,
    required this.child,
  });

  final VoidCallback onTap;
  final EdgeInsets padding;
  final Color borderColor;
  final Color hoverColor;
  final Widget child;

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _hovered ? widget.hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.borderColor, width: 1.5),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Individual chip button with active/idle state.
class _FilterChip extends StatefulWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.fontSize,
    required this.activeGradient,
    required this.activeBorderColor,
    required this.activeTextColor,
    required this.activeShadow,
    required this.idleTextColor,
    required this.idleBorderColor,
    required this.hoverColor,
    required this.onTap,
  });

  final String label;
  final bool active;
  final double fontSize;
  final LinearGradient activeGradient;
  final Color activeBorderColor;
  final Color activeTextColor;
  final BoxShadow activeShadow;
  final Color idleTextColor;
  final Color idleBorderColor;
  final Color hoverColor;
  final VoidCallback onTap;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: widget.fontSize * 0.3,
          ),
          decoration: BoxDecoration(
            gradient: widget.active ? widget.activeGradient : null,
            color: widget.active
                ? null
                : (_hovered ? widget.hoverColor : Colors.transparent),
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: widget.active
                  ? widget.activeBorderColor
                  : (_hovered
                        ? widget.idleBorderColor.withValues(alpha: 0.8)
                        : widget.idleBorderColor),
              width: 1.5,
            ),
            boxShadow: widget.active
                ? [
                    BoxShadow(
                      color: widget.activeShadow.color,
                      blurRadius: widget.activeShadow.blurRadius,
                      offset: widget.activeShadow.offset,
                    ),
                  ]
                : null,
          ),
          transform: _hovered
              ? (Matrix4.identity()..translateByDouble(0.0, -1.0, 0.0, 1.0))
              : Matrix4.identity(),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: widget.fontSize * 0.82,
              fontWeight: FontWeight.w600,
              color: widget.active
                  ? widget.activeTextColor
                  : widget.idleTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
