import 'package:flutter/material.dart';
import 'package:redesigned/Components/Utils/classes.dart';

class StoryViewModel extends ChangeNotifier {
  final StoryGroup storyGroup;
  int _currentIndex = 0;

  StoryViewModel(this.storyGroup);

  int get currentIndex => _currentIndex;
  int get length => storyGroup.stories.length;
  Story get currentStory => storyGroup.stories[_currentIndex];
  Person get person => storyGroup.person;

  void nextStory(VoidCallback onComplete) {
    if (_currentIndex < length - 1) {
      _currentIndex++;
      notifyListeners();
    } else {
      onComplete();
    }
  }

  void previousStory() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void jumpToStory(int index) {
    if (index >= 0 && index < length) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
