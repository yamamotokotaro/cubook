import 'package:flutter/cupertino.dart';

class ChallengeDetailModel extends ChangeNotifier{
  var list_isSelected = new List();
  bool checkParent = false;

  void onPressAdd() {
    list_isSelected.add(false);
    notifyListeners();
  }

  void onPressedCheckParent(bool e) {
    checkParent = e;
    notifyListeners();
  }
}