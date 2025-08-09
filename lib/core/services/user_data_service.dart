import 'package:flutter/cupertino.dart';
import 'package:redesigned/core/models/user.dart';
import 'package:redesigned/data/repositories/user_repository.dart';

class UserDataService extends ChangeNotifier {
  bool _isLoaded = false;
  User? _user;

  UserDataService(this._userRepository) {
    _fetchData();
  }

  /// Data fetching check
  bool get isLoaded => _isLoaded;

  /// Instance of [User]
  User? get user => _user;

  /// Instance of [UserRepository] for fetching/updating data;
  final UserRepository _userRepository;

  /// Fetch User data from [UserRepository]
  void _fetchData() async {
    _isLoaded = false;
    notifyListeners();
    try {
      _user = await _userRepository.getUserData();
    } catch (e) {
      rethrow;
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }
}
