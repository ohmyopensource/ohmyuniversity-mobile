// @file custom_toast_model.dart
// Data models for the toast notification system.

// ─────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────

/// Visual and semantic variant of a toast — maps to Angular `ToastVariant`.
enum ToastVariant { success, error, warning, info, neutral }

/// Screen position where toasts are stacked — maps to Angular `ToastPosition`.
enum ToastPosition {
  topRight,
  topLeft,
  topCenter,
  bottomRight,
  bottomLeft,
  bottomCenter,
}

// ─────────────────────────────────────────────
// Toast action
// ─────────────────────────────────────────────

/// Optional user-interactable action attached to a toast.
class ToastAction {
  const ToastAction({required this.label, required this.onClick});

  final String label;
  final void Function() onClick;
}

// ─────────────────────────────────────────────
// Toast model
// ─────────────────────────────────────────────

/// Full internal state of a single toast notification.
class ToastModel {
  ToastModel({
    required this.id,
    required this.variant,
    required this.message,
    required this.duration,
    required this.position,
    required this.dismissible,
    required this.createdAt,
    this.title,
    this.action,
    this.paused = false,
  });

  final String id;
  final ToastVariant variant;
  final String message;
  final String? title;
  final Duration duration;
  final ToastPosition position;
  final bool dismissible;
  final ToastAction? action;
  final DateTime createdAt;
  final bool paused;

  ToastModel copyWith({bool? paused, DateTime? createdAt}) => ToastModel(
    id: id,
    variant: variant,
    message: message,
    title: title,
    duration: duration,
    position: position,
    dismissible: dismissible,
    action: action,
    createdAt: createdAt ?? this.createdAt,
    paused: paused ?? this.paused,
  );
}

// ─────────────────────────────────────────────
// Toast options
// ─────────────────────────────────────────────

/// Optional overrides when creating a toast.
class ToastOptions {
  const ToastOptions({
    this.title,
    this.duration,
    this.position,
    this.dismissible,
    this.action,
  });

  final String? title;
  final Duration? duration;
  final ToastPosition? position;
  final bool? dismissible;
  final ToastAction? action;
}
