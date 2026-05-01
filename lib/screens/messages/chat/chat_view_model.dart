import 'package:flutter/material.dart';
import 'package:redesigned/core/models/chat.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatViewModel extends ChangeNotifier {
  final Person person;
  List<ChatText> chats = [...chatTexts];
  final ItemScrollController scrollController = ItemScrollController();
  final TextEditingController textEditingController = TextEditingController();

  String _currentInput = "";
  String get currentInput => _currentInput;

  ChatViewModel(this.person);

  void onInputChanged(String value) {
    _currentInput = value;
    notifyListeners();
  }

  void sendMessage() {
    if (_currentInput.trim().isEmpty) return;

    chats.insert(
        0,
        ChatText(
            text: _currentInput,
            sentByUser: true,
            time: "now",
            textid: chats.length));
    _currentInput = "";
    textEditingController.clear();
    notifyListeners();
  }

  void goToChat(int id) {
    scrollController.scrollTo(index: id, duration: Durations.medium1);
  }

  void onBackPress(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  List<String> get emojiList => [
        "❤️", "👍", "🎉", "💀", "😀", "😄", "😁", "😂", "🤣", "😊",
        "😇", "😉", "😍", "🥰", "🤗", "🤓", "😎", "🥳",
      ];
}
