import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redesigned/core/constants/route_names.dart';
import 'package:redesigned/core/services/auth_service.dart';
import 'package:redesigned/core/services/navigation_service.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthService _authService;

  final NavigationService _navService;

  User? _user;
  bool _isLoading = false;

  SignInViewModel(this._authService, this._navService) {
    _authService.userChanges.listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  /// Text editing controller for username
  final TextEditingController userNameController = TextEditingController();

  /// Text editing controller for password
  final TextEditingController passwordController = TextEditingController();

  /// Login using user entered credentials
  Future<void> onLoginPress() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmailAndPassword(
          userNameController.text, passwordController.text);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Navigate to Forget password screen
  void onForgetPasswordPress() {
    _navService.go(RouteNames.FORGET_PASSWORD_SCREEN);
  }

  // Navigate to Sign up page
  void onSignUpPress() {
    _navService.go(RouteNames.SIGN_UP_SCREEN);
  }
}
