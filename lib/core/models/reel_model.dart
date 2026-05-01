import 'package:redesigned/core/models/comment.dart';
import 'package:redesigned/core/models/person.dart';

class Reel {
  Reel({
    required this.person,
    required this.title,
    required this.description,
    required this.pathToMedia,
    this.audio,
    required this.postId,
    required this.likes,
    required this.playCount,
    this.comments = const [],
  });
  final Person person;
  final String title;
  final String description;
  final String pathToMedia;
  final AudioSource? audio;
  final int postId;

  // Public Data
  int likes;
  int playCount;
  List<Comment> comments;
}

class AudioSource {
  AudioSource({
    required this.accountUserName,
    required this.pathToAudio,
    required this.title,
  });
  String pathToAudio;
  String accountUserName;
  String title;
}
