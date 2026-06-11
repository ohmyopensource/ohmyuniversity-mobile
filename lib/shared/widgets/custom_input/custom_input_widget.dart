import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums & models
// ─────────────────────────────────────────────────────────────────────────────

/// Rendering mode — maps to Angular `InputType`.
enum InputType {
  text,
  email,
  password,
  tel,
  number,
  url,
  search,
  textarea,
  select,
}

/// Size scale — maps to Angular `InputSize`.
enum InputSize { sm, md, lg }

/// Semantic colour accent — maps to Angular `InputVariant`.
enum InputVariant { primary, secondary, success, warning, error, info }

/// Option model for select-type inputs — maps to Angular `SelectOption`.
class SelectOption {
  const SelectOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });

  final String label;
  final String value;
  final bool disabled;
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────

/// Highly configurable form field supporting text, textarea, select,
/// password toggle, icons, prefix/suffix, and validation states.
///
/// Direct Flutter migration of `CustomInputComponent` (Angular).
///
/// ### Basic usage
/// ```dart
/// CustomInputWidget(
///   label: 'Email',
///   type: InputType.email,
///   placeholder: 'inserisci email',
///   onChanged: (v) => print(v),
/// )
///
/// CustomInputWidget(
///   label: 'Note',
///   type: InputType.textarea,
///   rows: 5,
/// )
///
/// CustomInputWidget(
///   label: 'Corso',
///   type: InputType.select,
///   options: [SelectOption(label: 'Informatica', value: 'inf')],
///   onChanged: (v) => print(v),
/// )
/// ```
class CustomInputWidget extends StatefulWidget {
  const CustomInputWidget({
    super.key,

    // Content
    this.label = '',
    this.placeholder = '',
    this.hint = '',
    this.errorMessage = '',
    this.successMessage = '',
    this.initialValue = '',

    // Type & options
    this.type = InputType.text,
    this.options = const [],
    this.selectPlaceholder = 'Seleziona',

    // Appearance
    this.variant = InputVariant.primary,
    this.size = InputSize.md,
    this.fullWidth = true,

    // Icons & decorations
    this.iconLeft,
    this.iconRight,
    this.prefix = '',
    this.suffix = '',

    // Behaviour
    this.clearable = false,
    this.disabled = false,
    this.readonly = false,
    this.required = false,
    this.rows = 4,
    this.maxLength,
    this.minLength,
    this.controller,

    // Callbacks
    this.onChanged,
    this.onFocus,
    this.onBlur,
    this.onSubmitted,
    this.onCleared,
  });

  final String label;
  final String placeholder;
  final String hint;
  final String errorMessage;
  final String successMessage;
  final String initialValue;

  final InputType type;
  final List<SelectOption> options;
  final String selectPlaceholder;

  final InputVariant variant;
  final InputSize size;
  final bool fullWidth;

  final IconData? iconLeft;
  final IconData? iconRight;
  final String prefix;
  final String suffix;

  final bool clearable;
  final bool disabled;
  final bool readonly;
  final bool required;
  final int rows;
  final int? maxLength;
  final int? minLength;

  /// Optional external controller. If provided, the widget does not create
  /// its own — caller is responsible for disposal.
  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onFocus;
  final VoidCallback? onBlur;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onCleared;

  @override
  State<CustomInputWidget> createState() => _CustomInputWidgetState();
}

class _CustomInputWidgetState extends State<CustomInputWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _ownsController = false;
  bool _isFocused = false;
  bool _showPassword = false;
  String _selectedValue = '';

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _ownsController = true;
    }

    _selectedValue = widget.initialValue;

    _focusNode = FocusNode()
      ..addListener(() {
        final focused = _focusNode.hasFocus;
        if (focused != _isFocused) {
          setState(() => _isFocused = focused);
          if (focused) {
            widget.onFocus?.call();
          } else {
            widget.onBlur?.call();
          }
        }
      });
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Derived state ──────────────────────────────────────────────────────────

  _InputStatus get _status {
    if (widget.errorMessage.isNotEmpty) return _InputStatus.error;
    if (widget.successMessage.isNotEmpty) return _InputStatus.success;
    return _InputStatus.defaultState;
  }

  bool get _showClearBtn =>
      widget.clearable &&
      _controller.text.isNotEmpty &&
      !widget.disabled &&
      !widget.readonly &&
      widget.type != InputType.select;

  bool get _showPasswordToggle => widget.type == InputType.password;

  bool get _hasRightSlot =>
      _showPasswordToggle ||
      _showClearBtn ||
      widget.iconRight != null ||
      widget.suffix.isNotEmpty ||
      _status != _InputStatus.defaultState;

  // ── Size tokens ────────────────────────────────────────────────────────────

  double get _fontSize => switch (widget.size) {
    InputSize.sm => 12.8,
    InputSize.md => 14,
    InputSize.lg => 16,
  };

  double get _minHeight => switch (widget.size) {
    InputSize.sm => 34,
    InputSize.md => 42,
    InputSize.lg => 52,
  };

  double get _horizontalPadding => switch (widget.size) {
    InputSize.sm => 10,
    InputSize.md => 13,
    InputSize.lg => 16,
  };

  double get _verticalPadding => switch (widget.size) {
    InputSize.sm => 6,
    InputSize.md => 9,
    InputSize.lg => 12,
  };

  double get _iconSize => switch (widget.size) {
    InputSize.sm => 14,
    InputSize.md => 16,
    InputSize.lg => 18,
  };

  double get _labelFontSize => 13.1; // ~0.82rem

  // ── Colour resolution ──────────────────────────────────────────────────────

  Color get _focusBorderColor => switch (widget.variant) {
    InputVariant.primary => AppColors.colorPrimaryDark,
    InputVariant.secondary => AppColors.colorSecondaryDark,
    InputVariant.success => AppColors.colorSuccessDark,
    InputVariant.warning => AppColors.colorWarningDark,
    InputVariant.error => AppColors.colorErrorDark,
    InputVariant.info => AppColors.colorInfoDark,
  };

  Color get _focusShadowColor => switch (widget.variant) {
    InputVariant.primary => AppColors.colorPrimaryFocus,
    InputVariant.secondary => AppColors.colorSecondaryFocus,
    InputVariant.success => AppColors.colorSuccessFocus,
    InputVariant.warning => AppColors.colorWarningFocus,
    InputVariant.error => AppColors.colorErrorFocus,
    InputVariant.info => AppColors.colorInfoFocus,
  };

  Color get _variantBorderRestColor => switch (widget.variant) {
    InputVariant.primary => AppColors.colorPrimaryLight,
    InputVariant.secondary => AppColors.colorSecondaryLight,
    InputVariant.success => AppColors.colorSuccessLight,
    InputVariant.warning => AppColors.colorWarningLight,
    InputVariant.error => AppColors.colorErrorLight,
    InputVariant.info => AppColors.colorInfoLight,
  };

  Color _resolveBorderColor(bool isDark) {
    if (_status == _InputStatus.error) return AppColors.colorErrorDark;
    if (_status == _InputStatus.success) return AppColors.colorSuccessDark;
    if (_isFocused) return _focusBorderColor;
    if (isDark) return AppColors.colorNeutral600;
    return _variantBorderRestColor;
  }

  Color _resolveBackgroundColor(bool isDark) {
    if (widget.disabled) {
      return isDark ? AppColors.colorNeutral600 : AppColors.colorNeutral100;
    }
    if (widget.readonly) {
      return isDark ? AppColors.colorNeutral600 : AppColors.colorNeutral100;
    }
    if (_status == _InputStatus.success) return AppColors.colorSuccessLight;
    if (_status == _InputStatus.error) return AppColors.colorErrorLight;
    return isDark ? AppColors.colorNeutral900 : Colors.white;
  }

  List<BoxShadow> _resolveShadow() {
    if (!_isFocused) return const [];
    return [
      BoxShadow(color: _focusShadowColor, blurRadius: 0, spreadRadius: 3),
    ];
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget field = _buildField(isDark);

    if (!widget.fullWidth) {
      field = IntrinsicWidth(child: field);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label.isNotEmpty) ...[
          _buildLabel(isDark),
          const SizedBox(height: 5),
        ],
        field,
        if (widget.errorMessage.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildHint(
            widget.errorMessage,
            color: AppColors.colorErrorDark,
            bold: true,
          ),
        ] else if (widget.successMessage.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildHint(
            widget.successMessage,
            color: AppColors.colorSuccessDark,
            bold: true,
          ),
        ] else if (widget.hint.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildHint(
            widget.hint,
            color: isDark
                ? AppColors.colorNeutral500
                : AppColors.colorNeutral400,
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(bool isDark) {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: TextStyle(
          fontSize: _labelFontSize,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.colorNeutral300 : AppColors.colorNeutral600,
          height: 1.3,
        ),
        children: [
          if (widget.required)
            TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.colorErrorDark),
            ),
        ],
      ),
    );
  }

  Widget _buildField(bool isDark) {
    final borderColor = _resolveBorderColor(isDark);
    final bgColor = _resolveBackgroundColor(isDark);
    final shadows = _resolveShadow();

    final decoration = BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: borderColor, width: 1.5),
      boxShadow: shadows,
    );

    if (widget.type == InputType.select) {
      return _buildSelectField(decoration, isDark);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: BoxConstraints(minHeight: _minHeight),
      decoration: decoration,
      child: Row(
        crossAxisAlignment: widget.type == InputType.textarea
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          if (widget.prefix.isNotEmpty) _buildPrefix(isDark),
          if (widget.iconLeft != null) _buildLeftIcon(isDark),
          Expanded(child: _buildInputCore(isDark)),
          _buildRightSlot(isDark),
          if (widget.suffix.isNotEmpty) _buildSuffix(isDark),
        ],
      ),
    );
  }

  // ── Input core ─────────────────────────────────────────────────────────────

  Widget _buildInputCore(bool isDark) {
    final textColor = isDark
        ? AppColors.colorNeutral100
        : AppColors.colorNeutral900;
    final hintColor = isDark
        ? AppColors.colorNeutral500
        : AppColors.colorNeutral400;

    final style = TextStyle(
      fontSize: _fontSize,
      color: widget.disabled ? textColor.withValues(alpha: 0.65) : textColor,
      height: 1.5,
    );

    final EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: _horizontalPadding,
      vertical: _verticalPadding,
    );

    if (widget.type == InputType.textarea) {
      return Padding(
        padding: contentPadding,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: widget.rows,
          minLines: widget.rows,
          enabled: !widget.disabled,
          readOnly: widget.readonly,
          maxLength: widget.maxLength,
          style: style,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: hintColor, fontSize: _fontSize),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            filled: false,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            counterText: '',
          ),
          onChanged: (v) {
            setState(() {});
            widget.onChanged?.call(v);
          },
          onSubmitted: widget.onSubmitted,
        ),
      );
    }

    // Standard text-based inputs
    final effectiveObscure =
        widget.type == InputType.password && !_showPassword;

    final keyboardType = switch (widget.type) {
      InputType.email => TextInputType.emailAddress,
      InputType.number => TextInputType.number,
      InputType.tel => TextInputType.phone,
      InputType.url => TextInputType.url,
      InputType.search => TextInputType.text,
      _ => TextInputType.text,
    };

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      obscureText: effectiveObscure,
      keyboardType: keyboardType,
      enabled: !widget.disabled,
      readOnly: widget.readonly,
      maxLength: widget.maxLength,
      style: style,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: hintColor, fontSize: _fontSize),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        counterText: '',
      ),
      onChanged: (v) {
        setState(() {});
        widget.onChanged?.call(v);
      },
      onSubmitted: widget.onSubmitted,
    );
  }

  // ── Select field ───────────────────────────────────────────────────────────

  Widget _buildSelectField(BoxDecoration decoration, bool isDark) {
    final textColor = isDark
        ? AppColors.colorNeutral100
        : AppColors.colorNeutral900;
    final hintColor = isDark
        ? AppColors.colorNeutral500
        : AppColors.colorNeutral400;
    final iconColor = isDark
        ? AppColors.colorNeutral500
        : AppColors.colorNeutral400;

    final hasValue = _selectedValue.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: BoxConstraints(minHeight: _minHeight),
      decoration: decoration,
      child: Row(
        children: [
          if (widget.prefix.isNotEmpty) _buildPrefix(isDark),
          if (widget.iconLeft != null) _buildLeftIcon(isDark),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: hasValue ? _selectedValue : null,
                  isDense: true,
                  isExpanded: true,
                  icon: Icon(
                    LucideIcons.chevronDown,
                    size: _iconSize,
                    color: iconColor,
                  ),
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: textColor,
                    height: 1.5,
                  ),
                  hint: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _horizontalPadding,
                    ),
                    child: Text(
                      widget.selectPlaceholder,
                      style: TextStyle(fontSize: _fontSize, color: hintColor),
                    ),
                  ),
                  onChanged: widget.disabled
                      ? null
                      : (v) {
                          if (v == null) return;
                          setState(() => _selectedValue = v);
                          widget.onChanged?.call(v);
                        },
                  items: widget.options
                      .map(
                        (opt) => DropdownMenuItem<String>(
                          value: opt.value,
                          enabled: !opt.disabled,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _horizontalPadding,
                            ),
                            child: Text(
                              opt.label,
                              style: TextStyle(
                                fontSize: _fontSize,
                                color: opt.disabled
                                    ? textColor.withValues(alpha: 0.4)
                                    : textColor,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Slots ──────────────────────────────────────────────────────────────────

  Widget _buildLeftIcon(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: _horizontalPadding),
      child: Icon(
        widget.iconLeft,
        size: _iconSize,
        color: isDark ? AppColors.colorNeutral500 : AppColors.colorNeutral400,
      ),
    );
  }

  Widget _buildRightSlot(bool isDark) {
    if (!_hasRightSlot) return const SizedBox.shrink();

    // Password toggle takes precedence
    if (_showPasswordToggle) {
      return _IconButton(
        icon: _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
        size: _iconSize,
        color: isDark ? AppColors.colorNeutral500 : AppColors.colorNeutral400,
        hoverColor: isDark
            ? AppColors.colorNeutral600
            : AppColors.colorNeutral100,
        onTap: () => setState(() => _showPassword = !_showPassword),
        semanticLabel: _showPassword ? 'Nascondi password' : 'Mostra password',
      );
    }

    // Clear button
    if (_showClearBtn) {
      return _IconButton(
        icon: LucideIcons.x,
        size: _iconSize,
        color: isDark ? AppColors.colorNeutral500 : AppColors.colorNeutral400,
        hoverColor: isDark
            ? AppColors.colorNeutral600
            : AppColors.colorNeutral100,
        onTap: () {
          _controller.clear();
          setState(() {});
          widget.onCleared?.call();
          widget.onChanged?.call('');
        },
        semanticLabel: 'Svuota campo',
      );
    }

    // Status icon (no iconRight, no password, no clear)
    if (_status != _InputStatus.defaultState && widget.iconRight == null) {
      final statusColor = _status == _InputStatus.error
          ? AppColors.colorErrorDark
          : AppColors.colorSuccessDark;
      final statusIcon = _status == _InputStatus.error
          ? LucideIcons.circleAlert
          : LucideIcons.circleCheck;

      return Padding(
        padding: EdgeInsets.only(right: _horizontalPadding),
        child: Icon(statusIcon, size: _iconSize, color: statusColor),
      );
    }

    // Static right icon
    if (widget.iconRight != null) {
      return Padding(
        padding: EdgeInsets.only(right: _horizontalPadding),
        child: Icon(
          widget.iconRight,
          size: _iconSize,
          color: isDark ? AppColors.colorNeutral500 : AppColors.colorNeutral400,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPrefix(bool isDark) {
    return _FixedDecoration(
      text: widget.prefix,
      fontSize: _labelFontSize,
      isDark: isDark,
      isPrefix: true,
    );
  }

  Widget _buildSuffix(bool isDark) {
    return _FixedDecoration(
      text: widget.suffix,
      fontSize: _labelFontSize,
      isDark: isDark,
      isPrefix: false,
    );
  }

  Widget _buildHint(String text, {required Color color, bool bold = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
        height: 1.4,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────────────────────────────────────────

enum _InputStatus { defaultState, success, error }

class _IconButton extends StatefulWidget {
  const _IconButton({
    required this.icon,
    required this.size,
    required this.color,
    required this.hoverColor,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final double size;
  final Color color;
  final Color hoverColor;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: _hovered ? widget.hoverColor : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(widget.icon, size: widget.size, color: widget.color),
          ),
        ),
      ),
    );
  }
}

class _FixedDecoration extends StatelessWidget {
  const _FixedDecoration({
    required this.text,
    required this.fontSize,
    required this.isDark,
    required this.isPrefix,
  });

  final String text;
  final double fontSize;
  final bool isDark;
  final bool isPrefix;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? AppColors.colorNeutral600
        : AppColors.colorNeutral100;
    final textColor = isDark
        ? AppColors.colorNeutral400
        : AppColors.colorNeutral500;
    final borderColor = isDark
        ? AppColors.colorNeutral500
        : AppColors.colorNeutral200;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          left: isPrefix
              ? BorderSide.none
              : BorderSide(color: borderColor, width: 1.5),
          right: isPrefix
              ? BorderSide(color: borderColor, width: 1.5)
              : BorderSide.none,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
