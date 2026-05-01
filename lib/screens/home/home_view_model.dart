import 'package:flutter/material.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/screens/home/home_data.dart';

class HomeViewModel extends ChangeNotifier {
  final Set<Filters> _selectedFilters = <Filters>{};
  Set<Filters> get selectedFilters => _selectedFilters;

  void toggleFilter(Filters filter, bool selected) {
    if (selected) {
      _selectedFilters.add(filter);
    } else {
      _selectedFilters.remove(filter);
    }
    notifyListeners();
  }

  List<Post> get posts => dummyPosts;
  List<List<dynamic>> get storiesData => li;
  String get profilePictureLink => linkToPfp;

  void onSearchTap() {
    // TODO: Search bar tapped
  }

  void onMicPressed() {
    // TODO: Mic pressed
  }
  void onNewPostPressed() {
    // TODO: onNewPostPress
  }
  void onSwitchButtonPressed() {
    // TODO: onNewPostPress
  }
}
