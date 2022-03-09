import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AddLumpSelectItemModel extends ChangeNotifier {
  List<DocumentSnapshot>? userSnapshot;
  User? currentUser;
  DocumentSnapshot? userData;
  bool isGet = false;
  Map<dynamic, dynamic> itemSelected = <dynamic, dynamic>{};

  void createList(String? type, int quant) {
    itemSelected[type] =
        List<dynamic>.generate(quant, (int index) => <bool>[]);
    notifyListeners();
  }

  void createbool(String? type, int page, int quant) {
    itemSelected[type][page] = List<bool>.generate(quant, (int index) => false);
    notifyListeners();
  }

  void onPressedCheck(String? type, int page, int number) {
    itemSelected[type][page][number] = !itemSelected[type][page][number];
    notifyListeners();
  }

  Future<void> onPressedSend(List<String>? uids, BuildContext context) async {
    Navigator.of(context).pop(itemSelected);
  }
}
