import 'package:flutter/material.dart';
import 'package:redesigned/core/services/auth_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthService _authService;

  SettingsViewModel(this._authService);

  Future<void> logout() async {
    await _authService.signOut();
  }
}
