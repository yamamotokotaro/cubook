import 'package:flutter/cupertino.dart';

class StepDetailModel extends ChangeNotifier{
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