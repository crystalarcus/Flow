import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesigned/core/models/user.dart';

class RemoteUserDataSource {
  // Firestore instance
  final _firestore = FirebaseFirestore.instance;

  /// Get user data from firestore
  Future<User?> getUserData(String userID) async {
    try {
      final userSnapShot =
          await _firestore.collection('users').doc(userID).get();
      if (userSnapShot.exists) {
        /// Return user object if user is found
        return User.fromJson(userSnapShot.data()!);
      } else {
        /// Return null if user not found
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
