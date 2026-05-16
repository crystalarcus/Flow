import 'package:flutter/material.dart';
import 'package:redesigned/core/models/account.dart';

class ProfileViewScreenModel extends ChangeNotifier {
  final Account account;

  ProfileViewScreenModel(this.account);

  // Add more profile specific logic here (follow/unfollow, etc)
}
