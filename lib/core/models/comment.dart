import 'package:redesigned/core/models/person.dart';

class Comment {
  final Person person;
  final String text;
  final String dateTime;
  int likes;
  List<CommentReply> replies;
  bool isLiked;

  Comment({
    required this.person,
    required this.text,
    required this.dateTime,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
  });
}

class CommentReply {
  CommentReply({
    required this.person,
    required this.text,
    required this.dateTime,
    required this.replyTo,
    this.isLiked = false,
    this.likes = 0,
  });
  final Person person;
  final DateTime dateTime;
  final String text;
  final String replyTo;
  bool isLiked;
  int likes;
}

class Reply {
  String to;
  Person person;
  String text;
  DateTime dateTime;
  Reply({
    required this.to,
    required this.person,
    required this.text,
    required this.dateTime,
  });
}
