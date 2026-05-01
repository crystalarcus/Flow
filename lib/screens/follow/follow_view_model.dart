import 'package:flutter/material.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:provider/provider.dart';

class FollowViewModel extends ChangeNotifier {
  final String name;
  final List<FollowPerson> followers;
  final List<FollowPerson> following;
  final List<FollowPerson> mutual = [];

  FollowViewModel({
    required this.name,
    required this.followers,
    required this.following,
    required BuildContext context,
  }) {
    _calculateMutual(context);
  }

  void _calculateMutual(BuildContext context) {
    for (FollowPerson element in followers) {
      if (context.read<AppService>().isFollowing(element)) {
        mutual.add(element);
      }
    }
  }
}
