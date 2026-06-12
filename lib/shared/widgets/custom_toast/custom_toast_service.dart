// @file custom_toast_service.dart
// Riverpod-based service managing the lifecycle of toast notifications.

import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom_toast_model.dart';

// ─────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────

/// Global provider for [ToastService].
/// Access via `ref.read(toastServiceProvider.notifier)` to call methods,
/// or `ref.watch(toastServiceProvider)` to react to the toast list.
final toastServiceProvider = NotifierProvider<ToastService, List<ToastModel>>(
  ToastService.new,
);

// ─────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────

/// Centralized reactive store for toast notifications.
///
/// ### Usage
/// ```dart
/// // Show a toast
/// ref.read(toastServiceProvider.notifier).success('Prenotazione confermata!');
///
/// // With options
/// ref.read(toastServiceProvider.notifier).show(
///   'Operazione completata',
///   variant: ToastVariant.info,
///   options: ToastOptions(
///     title: 'Info',
///     position: ToastPosition.bottomCenter,
///     duration: Duration(seconds: 6),
///   ),
/// );
/// ```
class ToastService extends Notifier<List<ToastModel>> {
  static const _maxPerPosition = 5;
  static const _defaultDuration = Duration(seconds: 4);
  static const _errorDuration = Duration(seconds: 6);
  static const _defaultPosition = ToastPosition.topRight;

  final Map<String, Timer> _timers = {};

  @override
  List<ToastModel> build() => [];

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Shows a toast with a given [variant] and optional [options].
  /// Returns the generated toast id.
  String show(
    String message, {
    ToastVariant variant = ToastVariant.neutral,
    ToastOptions options = const ToastOptions(),
  }) {
    final id = _generateId();
    final duration = options.duration ?? _defaultDuration;
    final position = options.position ?? _defaultPosition;

    final toast = ToastModel(
      id: id,
      variant: variant,
      message: message,
      title: options.title,
      duration: duration,
      position: position,
      dismissible: options.dismissible ?? true,
      action: options.action,
      createdAt: DateTime.now(),
    );

    state = [..._evictOldestIfNeeded(position), toast];

    if (duration > Duration.zero) {
      _scheduleAutoDismiss(id, duration);
    }

    return id;
  }

  /// Shows a success toast.
  String success(
    String message, {
    ToastOptions options = const ToastOptions(),
  }) => show(message, variant: ToastVariant.success, options: options);

  /// Shows an error toast (default duration: 6s).
  String error(String message, {ToastOptions options = const ToastOptions()}) =>
      show(
        message,
        variant: ToastVariant.error,
        options: ToastOptions(
          title: options.title,
          duration: options.duration ?? _errorDuration,
          position: options.position,
          dismissible: options.dismissible,
          action: options.action,
        ),
      );

  /// Shows a warning toast.
  String warning(
    String message, {
    ToastOptions options = const ToastOptions(),
  }) => show(message, variant: ToastVariant.warning, options: options);

  /// Shows an info toast.
  String info(String message, {ToastOptions options = const ToastOptions()}) =>
      show(message, variant: ToastVariant.info, options: options);

  /// Shows a neutral toast.
  String neutral(
    String message, {
    ToastOptions options = const ToastOptions(),
  }) => show(message, variant: ToastVariant.neutral, options: options);

  /// Removes a toast by [id].
  void dismiss(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    state = state.where((t) => t.id != id).toList();
  }

  /// Removes all active toasts.
  void dismissAll() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
    state = [];
  }

  /// Removes all toasts at a given [position].
  void dismissPosition(ToastPosition position) {
    final ids = state
        .where((t) => t.position == position)
        .map((t) => t.id)
        .toList();
    for (final id in ids) {
      _timers[id]?.cancel();
      _timers.remove(id);
    }
    state = state.where((t) => t.position != position).toList();
  }

  /// Pauses the auto-dismiss timer (e.g. on hover).
  void pause(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    state = state
        .map((t) => t.id == id ? t.copyWith(paused: true) : t)
        .toList();
  }

  /// Resumes the auto-dismiss timer with remaining time.
  void resume(String id, {required Duration remaining}) {
    state = state
        .map(
          (t) => t.id == id
              ? t.copyWith(paused: false, createdAt: DateTime.now())
              : t,
        )
        .toList();
    if (remaining > Duration.zero) {
      _scheduleAutoDismiss(id, remaining);
    }
  }

  /// Returns toasts grouped by position.
  Map<ToastPosition, List<ToastModel>> get byPosition {
    final map = <ToastPosition, List<ToastModel>>{};
    for (final t in state) {
      (map[t.position] ??= []).add(t);
    }
    return map;
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  List<ToastModel> _evictOldestIfNeeded(ToastPosition position) {
    final forPosition = state.where((t) => t.position == position).toList();
    if (forPosition.length >= _maxPerPosition) {
      final oldest = forPosition.first;
      _timers[oldest.id]?.cancel();
      _timers.remove(oldest.id);
      return state.where((t) => t.id != oldest.id).toList();
    }
    return List.from(state);
  }

  void _scheduleAutoDismiss(String id, Duration duration) {
    _timers[id]?.cancel();
    _timers[id] = Timer(duration, () => dismiss(id));
  }

  String _generateId() =>
      'toast-${DateTime.now().millisecondsSinceEpoch}-'
      '${Random().nextInt(99999).toRadixString(36)}';
}
