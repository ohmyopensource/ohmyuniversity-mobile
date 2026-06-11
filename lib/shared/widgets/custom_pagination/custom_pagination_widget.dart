// @file custom_pagination_widget.dart
// @description Pagination component providing page navigation, page size
// control, and intelligent page range rendering with ellipsis support.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

// ─── Types ────────────────────────────────────────────────────────────────────

/// Available pagination component sizes.
enum PaginationSize { xs, sm, md, lg }

/// Color variant — drives accent colours on the active page indicator.
enum PaginationVariant {
  primary,
  secondary,
  tertiary,
  success,
  warning,
  error,
  info,
}

/// Visual emphasis applied to the active page indicator.
///
/// - [filled]  — gradient fill with shadow (default)
/// - [soft]    — flat light background, no shadow
/// - [minimal] — text-only, bold accent colour, no background
enum PaginationEmphasis { filled, soft, minimal }

/// Pagination display style.
///
/// - [numeric] — standard numbered page buttons with ellipsis (default)
/// - [dots]    — compact dot indicators; ignores showPageSizeSelector,
///               showInfo, showJumpToPage and showFirstLast
enum PaginationStyle { numeric, dots }

/// Internal representation of a pagination entry.
sealed class PageItem {
  const PageItem();
}

class PageNumber extends PageItem {
  const PageNumber(this.value);
  final int value;
}

class PageEllipsis extends PageItem {
  const PageEllipsis(this.id);
  final String id; // 'left' | 'right'
}

// ─── Widget ───────────────────────────────────────────────────────────────────

/// Pagination widget for navigating large datasets.
///
/// Usage:
/// ```dart
/// CustomPaginationWidget(
///   totalItems: 243,
///   pageSize: 25,
///   currentPage: 1,
///   onPageChange: (page) { setState(() => _page = page); },
/// )
/// ```
class CustomPaginationWidget extends StatefulWidget {
  const CustomPaginationWidget({
    super.key,
    required this.totalItems,
    this.pageSize = 10,
    this.currentPage = 1,
    this.pageSizeOptions = const [10, 25, 50, 100],
    this.maxVisiblePages = 5,
    this.showPageSizeSelector = true,
    this.showInfo = true,
    this.showFirstLast = true,
    this.showJumpToPage = false,
    this.disabled = false,
    this.variant = PaginationVariant.primary,
    this.size = PaginationSize.md,
    this.emphasis = PaginationEmphasis.filled,
    this.style = PaginationStyle.numeric,
    this.darkTheme = false,
    this.onPageChange,
    this.onPageSizeChange,
  });

  final int totalItems;
  final int pageSize;
  final int currentPage;
  final List<int> pageSizeOptions;

  /// Maximum page buttons visible before ellipsis kicks in.
  final int maxVisiblePages;

  final bool showPageSizeSelector;
  final bool showInfo;
  final bool showFirstLast;
  final bool showJumpToPage;
  final bool disabled;
  final PaginationVariant variant;
  final PaginationSize size;
  final PaginationEmphasis emphasis;

  /// Controls whether to render numbered pages or compact dot indicators.
  final PaginationStyle style;

  final bool darkTheme;

  /// Emitted when the page changes. Receives 1-based page index.
  final ValueChanged<int>? onPageChange;

  /// Emitted when page size changes.
  final ValueChanged<int>? onPageSizeChange;

  @override
  State<CustomPaginationWidget> createState() => _CustomPaginationWidgetState();
}

class _CustomPaginationWidgetState extends State<CustomPaginationWidget> {
  final _jumpCtrl = TextEditingController();

  @override
  void didUpdateWidget(CustomPaginationWidget old) {
    super.didUpdateWidget(old);
    // Reset jump input when data changes
    if (old.totalItems != widget.totalItems ||
        old.pageSize != widget.pageSize) {
      _jumpCtrl.clear();
    }
    // Clamp current page if needed
    if (widget.currentPage > _totalPages) {
      _goTo(_totalPages);
    }
  }

  @override
  void dispose() {
    _jumpCtrl.dispose();
    super.dispose();
  }

  // ── Computed ───────────────────────────────────────────────────────────

  int get _totalPages =>
      (widget.totalItems / widget.pageSize).ceil().clamp(1, double.maxFinite.toInt());

  bool get _isFirst => widget.currentPage <= 1;
  bool get _isLast => widget.currentPage >= _totalPages;

  int get _rangeStart =>
      widget.totalItems == 0 ? 0 : (widget.currentPage - 1) * widget.pageSize + 1;

  int get _rangeEnd =>
      (widget.currentPage * widget.pageSize).clamp(0, widget.totalItems);

  /// Builds the page item list with ellipsis using a sliding window.
  List<PageItem> get _pageItems {
    final total = _totalPages;
    final current = widget.currentPage;
    final max = widget.maxVisiblePages;

    if (total <= max) {
      return List.generate(total, (i) => PageNumber(i + 1));
    }

    final half = max ~/ 2;
    final items = <PageItem>[];

    int start = (current - half).clamp(2, total - 1);
    int end = (current + half).clamp(2, total - 1);

    if (current - half <= 2) end = (max - 2).clamp(2, total - 1);
    if (current + half >= total - 1) start = (total - max + 2).clamp(2, total - 1);

    items.add(PageNumber(1));
    if (start > 2) items.add(const PageEllipsis('left'));
    for (int v = start; v <= end; v++) items.add(PageNumber(v));
    if (end < total - 1) items.add(const PageEllipsis('right'));
    if (total > 1) items.add(PageNumber(total));

    return items;
  }

  // ── Actions ────────────────────────────────────────────────────────────

  void _goTo(int page) {
    if (widget.disabled) return;
    final clamped = page.clamp(1, _totalPages);
    if (clamped == widget.currentPage) return;
    widget.onPageChange?.call(clamped);
  }

  void _onJump() {
    final val = int.tryParse(_jumpCtrl.text);
    if (val == null) return;
    _goTo(val);
    _jumpCtrl.clear();
  }

  void _onPageSizeChange(int? val) {
    if (val == null || widget.disabled) return;
    widget.onPageSizeChange?.call(val);
    widget.onPageChange?.call(1);
  }

  // ── Size tokens ────────────────────────────────────────────────────────

  double get _fontSize => switch (widget.size) {
    PaginationSize.xs => 11.2,
    PaginationSize.sm => 12.8,
    PaginationSize.md => 14.0,
    PaginationSize.lg => 16.0,
  };

  double get _iconSize => switch (widget.size) {
    PaginationSize.xs => 12.0,
    PaginationSize.sm => 14.0,
    PaginationSize.md => 16.0,
    PaginationSize.lg => 18.0,
  };

  double get _btnMinSize => switch (widget.size) {
    PaginationSize.xs => 28.0,
    PaginationSize.sm => 32.0,
    PaginationSize.md => 36.0,
    PaginationSize.lg => 42.0,
  };

  double get _iconBtnPad => switch (widget.size) {
    PaginationSize.xs => 4.0,
    PaginationSize.sm => 5.0,
    PaginationSize.md => 6.0,
    PaginationSize.lg => 8.0,
  };

  // ── Variant tokens ─────────────────────────────────────────────────────

  ({
  Color light,
  Color dark,
  Color text,
  Color shadow,
  Color focus,
  }) get _vc => switch (widget.variant) {
    PaginationVariant.primary => (
    light: AppColors.colorPrimaryLight,
    dark: AppColors.colorPrimaryDark,
    text: AppColors.colorPrimaryText,
    shadow: AppColors.colorPrimaryShadow,
    focus: AppColors.colorPrimaryFocus,
    ),
    PaginationVariant.secondary => (
    light: AppColors.colorSecondaryLight,
    dark: AppColors.colorSecondaryDark,
    text: AppColors.colorSecondaryText,
    shadow: AppColors.colorSecondaryShadow,
    focus: AppColors.colorSecondaryFocus,
    ),
    PaginationVariant.tertiary => (
    light: AppColors.colorTertiaryLight,
    dark: AppColors.colorTertiaryDark,
    text: AppColors.colorTertiaryText,
    shadow: AppColors.colorTertiaryShadow,
    focus: AppColors.colorTertiaryFocus,
    ),
    PaginationVariant.success => (
    light: AppColors.colorSuccessLight,
    dark: AppColors.colorSuccessDark,
    text: AppColors.colorSuccessText,
    shadow: AppColors.colorSuccessShadow,
    focus: AppColors.colorSuccessFocus,
    ),
    PaginationVariant.warning => (
    light: AppColors.colorWarningLight,
    dark: AppColors.colorWarningDark,
    text: AppColors.colorWarningText,
    shadow: AppColors.colorWarningShadow,
    focus: AppColors.colorWarningFocus,
    ),
    PaginationVariant.error => (
    light: AppColors.colorErrorLight,
    dark: AppColors.colorErrorDark,
    text: AppColors.colorErrorText,
    shadow: AppColors.colorErrorShadow,
    focus: AppColors.colorErrorFocus,
    ),
    PaginationVariant.info => (
    light: AppColors.colorInfoLight,
    dark: AppColors.colorInfoDark,
    text: AppColors.colorInfoText,
    shadow: AppColors.colorInfoShadow,
    focus: AppColors.colorInfoFocus,
    ),
  };

  // ── Theme helpers ──────────────────────────────────────────────────────

  Color get _textColor =>
      widget.darkTheme ? AppColors.colorNeutral400 : AppColors.colorNeutral500;

  Color get _strongTextColor =>
      widget.darkTheme ? AppColors.colorNeutral300 : AppColors.colorNeutral600;

  Color get _inputBg =>
      widget.darkTheme ? AppColors.colorNeutral600 : AppColors.colorNeutral100;

  Color get _inputBorder =>
      widget.darkTheme ? AppColors.colorNeutral500 : AppColors.colorNeutral300;

  Color get _inputText =>
      widget.darkTheme ? AppColors.colorNeutral200 : AppColors.colorNeutral600;

  Color get _btnHoverBg =>
      widget.darkTheme ? AppColors.colorNeutral600 : AppColors.colorNeutral100;

  Color get _btnHoverBorder =>
      widget.darkTheme ? AppColors.colorNeutral500 : AppColors.colorNeutral300;

  Color get _btnHoverText =>
      widget.darkTheme ? AppColors.colorNeutral200 : AppColors.colorNeutral600;

  Color get _ellipsisColor =>
      widget.darkTheme ? AppColors.colorNeutral500 : AppColors.colorNeutral400;

  // ── Active page decoration ─────────────────────────────────────────────

  BoxDecoration _activeDecoration() {
    final vc = _vc;
    return switch (widget.emphasis) {
      PaginationEmphasis.filled => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [vc.light, vc.dark],
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusSm),
        border: Border.all(color: vc.dark, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: vc.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      PaginationEmphasis.soft => BoxDecoration(
        color: vc.light,
        borderRadius: BorderRadius.circular(AppColors.radiusSm),
        border: Border.all(color: vc.dark, width: 1.5),
      ),
      PaginationEmphasis.minimal => const BoxDecoration(),
    };
  }

  TextStyle _activeTextStyle() {
    final vc = _vc;
    return TextStyle(
      fontSize: _fontSize,
      fontWeight: widget.emphasis == PaginationEmphasis.minimal
          ? FontWeight.w800
          : FontWeight.w600,
      color: widget.emphasis == PaginationEmphasis.minimal
          ? (widget.darkTheme ? vc.light : vc.dark)
          : vc.text,
    );
  }

  // ── Sub-builders ───────────────────────────────────────────────────────

  /// Icon navigation button (first / prev / next / last).
  Widget _buildIconBtn({
    required IconData icon,
    required VoidCallback? onTap,
    required bool disabled,
    required String tooltip,
  }) {
    return _PaginationBtn(
      onTap: disabled || widget.disabled ? null : onTap,
      disabled: disabled || widget.disabled,
      padding: EdgeInsets.all(_iconBtnPad),
      idleColor: Colors.transparent,
      idleBorder: Colors.transparent,
      idleText: _textColor,
      hoverBg: _btnHoverBg,
      hoverBorder: _btnHoverBorder,
      hoverText: _btnHoverText,
      tooltip: tooltip,
      child: Icon(icon, size: _iconSize),
    );
  }

  /// Numbered page button.
  Widget _buildPageBtn(int page) {
    final isActive = page == widget.currentPage;

    if (isActive) {
      return Tooltip(
        message: 'Page $page',
        child: Container(
          constraints: BoxConstraints(minWidth: _btnMinSize),
          padding: EdgeInsets.symmetric(
            horizontal: _fontSize * 0.5,
            vertical: _fontSize * 0.35,
          ),
          decoration: _activeDecoration(),
          alignment: Alignment.center,
          child: Text('$page', style: _activeTextStyle()),
        ),
      );
    }

    return _PaginationBtn(
      onTap: widget.disabled ? null : () => _goTo(page),
      disabled: widget.disabled,
      padding: EdgeInsets.symmetric(
        horizontal: _fontSize * 0.5,
        vertical: _fontSize * 0.35,
      ),
      minWidth: _btnMinSize,
      idleColor: Colors.transparent,
      idleBorder: Colors.transparent,
      idleText: _textColor,
      hoverBg: _btnHoverBg,
      hoverBorder: _btnHoverBorder,
      hoverText: _btnHoverText,
      tooltip: 'Page $page',
      child: Text(
        '$page',
        style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Ellipsis separator.
  Widget _buildEllipsis() => SizedBox(
    width: _btnMinSize,
    child: Center(
      child: Text(
        '…',
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w700,
          color: _ellipsisColor,
          letterSpacing: 0.05,
        ),
      ),
    ),
  );

  /// Range info text.
  Widget _buildInfo() {
    if (widget.totalItems == 0) {
      return Text(
        'No results',
        style: TextStyle(
          fontSize: _fontSize * 0.8,
          fontStyle: FontStyle.italic,
          color: _textColor,
        ),
      );
    }
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: _fontSize * 0.8, color: _textColor),
        children: [
          TextSpan(
            text: '$_rangeStart–$_rangeEnd',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: _strongTextColor,
            ),
          ),
          const TextSpan(text: ' of '),
          TextSpan(
            text: '${widget.totalItems}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: _strongTextColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Page size dropdown.
  Widget _buildPageSizeSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Rows',
          style: TextStyle(fontSize: _fontSize * 0.8, color: _textColor),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(AppColors.radiusSm),
            border: Border.all(color: _inputBorder, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: widget.pageSize,
              isDense: true,
              icon: Icon(
                LucideIcons.chevronDown,
                size: 12,
                color: AppColors.colorNeutral400,
              ),
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.w600,
                color: _inputText,
              ),
              dropdownColor:
              widget.darkTheme ? AppColors.colorNeutral600 : Colors.white,
              items: widget.pageSizeOptions
                  .map((opt) => DropdownMenuItem(
                value: opt,
                child: Text('$opt'),
              ))
                  .toList(),
              onChanged: widget.disabled ? null : _onPageSizeChange,
            ),
          ),
        ),
      ],
    );
  }

  /// Jump-to-page input.
  Widget _buildJumpToPage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Go to',
          style: TextStyle(fontSize: _fontSize * 0.8, color: _textColor),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: _fontSize * 4,
          child: TextField(
            controller: _jumpCtrl,
            enabled: !widget.disabled,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            onSubmitted: (_) => _onJump(),
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: _inputText,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              filled: true,
              fillColor: _inputBg,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusSm),
                borderSide: BorderSide(color: _inputBorder, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusSm),
                borderSide: BorderSide(color: _vc.dark, width: 1.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusSm),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Dot style ──────────────────────────────────────────────────────────

  /// Renders compact dot indicators instead of numbered page buttons.
  Widget _buildDots() {
    final vc = _vc;
    final total = _totalPages;
    final current = widget.currentPage;

    // Dot dimensions based on size
    final dotIdle = switch (widget.size) {
      PaginationSize.xs => 6.0,
      PaginationSize.sm => 7.0,
      PaginationSize.md => 8.0,
      PaginationSize.lg => 10.0,
    };
    final dotActive = dotIdle * 2.25;
    final dotSpacing = dotIdle * 1.25;

    final dots = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final page = i + 1;
        final isActive = page == current;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: dotSpacing / 2),
          child: GestureDetector(
            onTap: widget.disabled ? null : () => _goTo(page),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: isActive ? dotActive : dotIdle,
              height: dotIdle,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dotIdle / 2),
                gradient: isActive
                    ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [vc.light, vc.dark],
                )
                    : null,
                color: isActive
                    ? null
                    : (widget.darkTheme
                    ? AppColors.colorNeutral500
                    : AppColors.colorNeutral300),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: vc.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );

    return dots;
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Dot style — bypasses the full numeric layout
    if (widget.style == PaginationStyle.dots) {
      return Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: _buildDots(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;
        final isMedium = constraints.maxWidth < 768;

        final opacity = widget.disabled ? 0.5 : 1.0;

        return Opacity(
          opacity: opacity,
          child: Wrap(
            spacing: switch (widget.size) {
              PaginationSize.xs => 4.0,
              PaginationSize.sm => 5.0,
              PaginationSize.md => 8.0,
              PaginationSize.lg => 10.0,
            },
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // ── Info ──────────────────────────────────────────────────
              if (widget.showInfo && !isMedium) _buildInfo(),

              // ── Page size selector ────────────────────────────────────
              if (widget.showPageSizeSelector && !isNarrow)
                _buildPageSizeSelector(),

              // ── Navigation controls ───────────────────────────────────
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // First
                  if (widget.showFirstLast)
                    _buildIconBtn(
                      icon: LucideIcons.chevronsLeft,
                      onTap: () => _goTo(1),
                      disabled: _isFirst,
                      tooltip: 'First page',
                    ),
                  // Prev
                  _buildIconBtn(
                    icon: LucideIcons.chevronLeft,
                    onTap: () => _goTo(widget.currentPage - 1),
                    disabled: _isFirst,
                    tooltip: 'Previous page',
                  ),

                  const SizedBox(width: 2),

                  // Pages list — hidden on very narrow screens
                  if (!isNarrow)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _pageItems.map((item) => switch (item) {
                        PageNumber p => _buildPageBtn(p.value),
                        PageEllipsis _ => _buildEllipsis(),
                      }).toList(),
                    ),

                  // Mobile indicator
                  if (isNarrow)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${widget.currentPage} / $_totalPages',
                        style: TextStyle(
                          fontSize: _fontSize * 0.85,
                          fontWeight: FontWeight.w700,
                          color: _textColor,
                        ),
                      ),
                    ),

                  const SizedBox(width: 2),

                  // Next
                  _buildIconBtn(
                    icon: LucideIcons.chevronRight,
                    onTap: () => _goTo(widget.currentPage + 1),
                    disabled: _isLast,
                    tooltip: 'Next page',
                  ),
                  // Last
                  if (widget.showFirstLast)
                    _buildIconBtn(
                      icon: LucideIcons.chevronsRight,
                      onTap: () => _goTo(_totalPages),
                      disabled: _isLast,
                      tooltip: 'Last page',
                    ),
                ],
              ),

              // ── Jump to page ──────────────────────────────────────────
              if (widget.showJumpToPage && !isNarrow) _buildJumpToPage(),
            ],
          ),
        );
      },
    );
  }
}

// ─── Internal sub-widget ──────────────────────────────────────────────────────

/// Reusable hoverable button for pagination controls.
class _PaginationBtn extends StatefulWidget {
  const _PaginationBtn({
    required this.onTap,
    required this.disabled,
    required this.padding,
    required this.idleColor,
    required this.idleBorder,
    required this.idleText,
    required this.hoverBg,
    required this.hoverBorder,
    required this.hoverText,
    required this.child,
    this.minWidth,
    this.tooltip = '',
  });

  final VoidCallback? onTap;
  final bool disabled;
  final EdgeInsets padding;
  final Color idleColor;
  final Color idleBorder;
  final Color idleText;
  final Color hoverBg;
  final Color hoverBorder;
  final Color hoverText;
  final Widget child;
  final double? minWidth;
  final String tooltip;

  @override
  State<_PaginationBtn> createState() => _PaginationBtnState();
}

class _PaginationBtnState extends State<_PaginationBtn> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.onTap == null;

    Widget btn = MouseRegion(
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) {
        if (!isDisabled) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (!isDisabled) setState(() => _pressed = true);
        },
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: isDisabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: BoxConstraints(
            minWidth: widget.minWidth ?? 0,
          ),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _hovered ? widget.hoverBg : widget.idleColor,
            borderRadius: BorderRadius.circular(AppColors.radiusSm),
            border: Border.all(
              color: _hovered ? widget.hoverBorder : widget.idleBorder,
              width: 1.5,
            ),
          ),
          transform: _pressed
              ? (Matrix4.identity()..scale(0.95))
              : (_hovered
              ? (Matrix4.identity()..translate(0.0, -1.0))
              : Matrix4.identity()),
          child: Opacity(
            opacity: isDisabled ? 0.35 : 1.0,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: _hovered ? widget.hoverText : widget.idleText,
              ),
              child: IconTheme.merge(
                data: IconThemeData(
                  color: _hovered ? widget.hoverText : widget.idleText,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip.isNotEmpty) {
      btn = Tooltip(message: widget.tooltip, child: btn);
    }

    return btn;
  }
}