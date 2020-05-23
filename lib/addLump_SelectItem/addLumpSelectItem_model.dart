import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AddLumpSelectItemModel extends ChangeNotifier{
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
    itemSelected[type][page] =
    new List<bool>.generate(quant, (index) => false);
    notifyListeners();
  }

  void onPressedCheck(String type,int page, int number) {
    itemSelected[type][page][number] = !itemSelected[type][page][number];
    notifyListeners();
  }

  Future<void> onPressedSend(List<String> uids) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((userDatas) async {
      DocumentSnapshot userData = userDatas.documents[0];
      Map<String, dynamic> data_item = new Map<String, dynamic>();
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['start'] = Timestamp.now();
      data['uid'] = user.uid;
      data['family'] = userData['family'];
      data['feedback'] = '';
      data['uid_toAdd'] = uids;
      var listCategory = ['usagi','sika','kuma','challenge'];
      for(int i=0; i<listCategory.length; i++) {
        for (int j=0; j < itemSelected[listCategory[i]].length; j++) {
          List<dynamic> pageItem = itemSelected[listCategory[i]];
          for (int k=0; k < pageItem.length; k++){
            List<dynamic> numberItem = pageItem[k];
            for (int l=0; l<numberItem.length; l++) {
              bool isCheck = numberItem[l];
              if (isCheck) {
                Map<String, int> toAdd = new Map<String, int>();
                toAdd['page'] = k;
                toAdd['number'] = l;
                data[listCategory[i]] = toAdd;
              }
            }
          }
        }
      }
      print(data);
    });
  }
}