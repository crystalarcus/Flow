import 'package:flutter/material.dart';
import 'package:redesigned/Components/Utils/classes.dart';
import 'package:redesigned/Components/Utils/data.dart';

class StoriesViewModel extends ChangeNotifier {
  final List<List<dynamic>> _storiesData = [
    [accounts[09].person, 4],
    [accounts[19].person, 0],
    [accounts[10].person, 2],
    [accounts[24].person, 0],
    [accounts[25].person, 3],
    [accounts[15].person, 1],
    [accounts[17].person, 0],
    [accounts[22].person, 0],
  ];

  List<List<dynamic>> get storiesData => _storiesData;

  String get profilePictureLink => linkToPfp;

  void addStory() {
    // TODO: Implement add story logic
  }
}
