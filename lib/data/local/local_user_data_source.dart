import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redesigned/core/models/user.dart';

class LocalUserDataSource {
  /// The Isar database instance. This is the direct connection to the local database.
  late final Isar _isarInstance;
  LocalUserDataSource();

  /// Retrieves a [User] object from the local database
  Future<User?> getUserData() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isarInstance = await Isar.open([UserSchema], directory: dir.path);
    } catch (e) {
      rethrow;
    }
    return _isarInstance.users.get(0);
  }

  /// Saves user data to local database
  Future<void> saveUser(User user) async {
    final dir = await getApplicationDocumentsDirectory();
    _isarInstance = await Isar.open([UserSchema], directory: dir.path);
  }
}
