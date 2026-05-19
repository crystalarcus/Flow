import 'package:flutter/material.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/screens/home/home_data.dart';
import 'package:redesigned/core/services/app_service.dart';

class HomeViewModel extends ChangeNotifier {
  final AppService _appService;
  final ScrollController scrollController = ScrollController();
  double _lastScrollOffset = 0;

  HomeViewModel(this._appService) {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentOffset = scrollController.offset;
    final delta = currentOffset - _lastScrollOffset;

    if (delta > 10) {
      // Scrolled down
      _appService.setNavBarVisible(false);
    } else if (delta < -10) {
      // Scrolled up
      _appService.setNavBarVisible(true);
    }

    _lastScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

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
