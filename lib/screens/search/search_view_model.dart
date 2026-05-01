import 'package:flutter/material.dart';
import 'package:redesigned/core/models/account.dart';
import 'package:redesigned/data/mock_data.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  List<String> get filters => filterItems;
  List<String> get recents => recentSearchs;
  List<Account> get profiles => searchAccounts;

  void onSearchChanged(String value) {
    // Implement search logic
    notifyListeners();
  }

  void onClearSearch() {
    searchController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
