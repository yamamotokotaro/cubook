import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AddLumpSelectItemModel extends ChangeNotifier {
  List<DocumentSnapshot> userSnapshot;
  FirebaseUser currentUser;
  DocumentSnapshot userData;
  bool isGet = false;
  Map<dynamic, dynamic> itemSelected = new Map<dynamic, dynamic>();

  void createList(String type, int quant) {
    itemSelected[type] =
        new List<dynamic>.generate(quant, (index) => new List<bool>());
    notifyListeners();
  }

  void createbool(String type, int page, int quant) {
    itemSelected[type][page] = new List<bool>.generate(quant, (index) => false);
    notifyListeners();
  }

  void onPressedCheck(String type, int page, int number) {
    itemSelected[type][page][number] = !itemSelected[type][page][number];
    notifyListeners();
  }

  Future<void> onPressedSend(List<String> uids, BuildContext context) async {
    Navigator.of(context).pop(itemSelected);
  }
}
