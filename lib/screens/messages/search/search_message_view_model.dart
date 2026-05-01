import 'package:flutter/material.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/data/mock_data.dart';

class SearchMessageViewModel extends ChangeNotifier {
  final List<String> _selectedUserNames = [];
  List<String> get selectedUserNames => _selectedUserNames;

  List<Person> get recents => suggestedPeople;
  List<Person> get suggested => myFollowersConst;

  void toggleSelection(String userName) {
    if (_selectedUserNames.contains(userName)) {
      _selectedUserNames.remove(userName);
    } else {
      _selectedUserNames.add(userName);
    }
    notifyListeners();
  }

  void onBackPress(BuildContext context) {
    Navigator.of(context).pop();
  }
}
