import 'package:go_router/go_router.dart';

/// Handles all Navigation Logic
/// It can be used instead of BuildContext
class NavigationService {
  /// Singleton instance
  NavigationService._(this._router);
  static NavigationService? _instance;
  factory NavigationService(GoRouter router) {
    _instance ??= NavigationService._(router);
    return _instance!;
  }

  /// A instance of GoRouter
  final GoRouter _router;

  /// Navigate to a named route
  void go(String name) {
    _router.goNamed(name);
  }

  /// Push a route onto the stack
  void push(String name) {
    _router.pushNamed(name);
  }

  /// if canPop(), Pop current route
  void pop() {
    if (_router.canPop()) {
      _router.pop();
    }
  }
}
