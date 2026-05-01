import 'package:flutter/material.dart';
import 'package:redesigned/core/models/reel_model.dart';
import 'package:redesigned/data/mock_data.dart';

class ReelsViewModel extends ChangeNotifier {
  List<Reel> get reelsData => reels;

  void onBackPress(BuildContext context) {
    Navigator.of(context).pop();
  }
}
