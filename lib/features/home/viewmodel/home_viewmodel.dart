import 'package:flutter/cupertino.dart';

class HomeViewModel with ChangeNotifier {
  late int _selectedIndex;
  int get selectedIndex => _selectedIndex;
  late PageController pageController;
  int curvedNavigationBarAnimationDuration = 700;

  HomeViewModel() {
    _selectedIndex = 0;

    pageController = pageController = PageController(
      initialPage: selectedIndex,
      keepPage: true,
    );
  }

  set selectedIndex(int value) {
    int temp = _selectedIndex;
    _selectedIndex = value;

    if (temp - value == 1 || temp - value == -1) {
      notifyListeners();
    }
  }

  set animateToPage(int index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: curvedNavigationBarAnimationDuration),
        curve: Curves.ease);
    notifyListeners();
  }
}
