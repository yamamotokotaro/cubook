import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/addLump_ScoutList/addLumpScoutList_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AddLumpSelectItemModel extends ChangeNotifier {
  List<DocumentSnapshot> userSnapshot;
  FirebaseUser currentUser;
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
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((userDatas) async {
      DocumentSnapshot userData = userDatas.documents[0];
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['start'] = Timestamp.now();
      data['uid'] = user.uid;
      data['group'] = userData['group'];
      data['family'] = userData['family'];
      data['feedback'] = '';
      data['uid_toAdd'] = uids;
      var listCategory = ['usagi', 'sika', 'kuma', 'challenge'];
      for (int i = 0; i < listCategory.length; i++) {
        List<dynamic> data_item = new List<dynamic>();
        if (itemSelected[listCategory[i]] != null) {
          List<dynamic> pageItem = itemSelected[listCategory[i]];
          for (int k = 0; k < pageItem.length; k++) {
            List<dynamic> numberItem = pageItem[k];
            for (int l = 0; l < numberItem.length; l++) {
              bool isCheck = numberItem[l];
              if (isCheck) {
                Map<String, int> toAdd = new Map<String, int>();
                toAdd['page'] = k;
                toAdd['number'] = l;
                data_item.add(toAdd);
              }
            }
          }
        }
        data[listCategory[i]] = data_item;
      }
      print(data);
      Firestore.instance.collection('lump').add(data).then((value) => Navigator.popUntil(context, ModalRoute.withName('/homeLump')));
    });
  }
}
