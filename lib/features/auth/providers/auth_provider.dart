import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

// TODO: replace with real auth state from flutter_appauth + flutter_secure_storage

@riverpod
class IsAuthenticated extends _$IsAuthenticated {
  @override
  bool build() => false;

  void setAuthenticated(bool value) => state = value;
}