import 'package:redesigned/core/models/user.dart';
import 'package:redesigned/data/local/local_user_data_source.dart';

/// Interface for [UserRepository]
abstract class IUserRepository {
  /// Get or refresh user data
  Future<User?> getUserData();

  /// Update user UserName
  Future<void> updateUserName();

  /// Update user's Name
  Future<void> updateName();

  /// Update user's email
  Future<void> updateEmail();

  /// Update user's bio
  Future<void> updateBio();

  /// Update user's pronouns
  Future<void> updatePronouns();

  /// Update user's ProfilePicture
  Future<void> updateProfilePicture();

  /// Update user's profile privacy
  Future<void> updateProfilePrivacy();
}

class UserRepository implements IUserRepository {
  UserRepository(this._localUserService);

  final LocalUserDataSource _localUserService;

  @override
  Future<User?> getUserData() async {
    try {
      User? user = await _localUserService.getUserData();
      return user;
    } catch (e) {
      rethrow;
    }
    // return User(
    //     id: '0a16b9d6-56a9-4d1a-8e2b-7c3e8f5d0b9a',
    //     userName: 'angel_wings',
    //     name: "Angel Wings",
    //     profilePicturePath:
    //         "https://drive.google.com/uc?export=view&id=1Y0QB4V0MeyoRUO0QQZu5qFMhT7ajlxzb");
  }

  @override
  Future<void> updateBio() async {
    // TODO: implement updateBio
  }

  @override
  Future<void> updateEmail() async {
    // TODO: implement updateEmail
  }

  @override
  Future<void> updateName() async {
    // TODO: implement updateName
  }

  @override
  Future<void> updateProfilePicture() async {
    // TODO: implement updateProfilePicture
  }

  @override
  Future<void> updateProfilePrivacy() async {
    // TODO: implement updateProfilePrivacy
  }

  @override
  Future<void> updatePronouns() async {
    // TODO: implement updatePronouns
  }

  @override
  Future<void> updateUserName() async {
    // TODO: implement updateUserName
  }
}
