import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/addLump_ScoutList/addLumpScoutList_view.dart';
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
    var task = new Task();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((userDatas) async {
      /*userData = userDatas.documents[0];
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['start'] = Timestamp.now();
      data['uid'] = user.uid;
      data['group'] = userData['group'];
      data['family'] = userData['family'];
      data['feedback'] = '';
      data['uid_toAdd'] = uids;
      var listCategory = ['usagi', 'sika', 'kuma', 'challenge'];
      for (int i = 0; i < listCategory.length; i++) {
        String type = listCategory[i];
        List<dynamic> data_item = new List<dynamic>();
        if (itemSelected[listCategory[i]] != null) {
          List<dynamic> pageItem = itemSelected[listCategory[i]];
          print('here ' + pageItem.toString());
          for (int k = 0; k < pageItem.length; k++) {
            for (int number = 0; number < uids.length; number++) {
              List<dynamic> numberItem = pageItem[k];
              String uid = uids[number];
              int count;

              Map<String, dynamic> data_signed = Map<String, dynamic>();
              Firestore.instance
                  .collection(type)
                  .where('group', isEqualTo: 'z4pkBhhgr0fUMN4evr5z')
                  .where('uid', isEqualTo: 'K9xpz6kFB9aoJQUvOqkNOzu8yLi2')
                  .where('page', isEqualTo: 5)
                  .getDocuments()
                  .then((data) async {
                if (data.documents.length != 0) {
                  DocumentSnapshot snapshot = data.documents[0];
                  Map<String, dynamic> map = Map<String, dynamic>();
                  Map<String, dynamic> data_toAdd = Map<String, dynamic>();
                  map = snapshot['signed'];
                  for (int l = 0; l < numberItem.length; l++) {
                    bool isCheck = numberItem[l];
                    if (isCheck) {
                      data_toAdd['phaze'] = 'signed';
                      data_toAdd['family'] = userData['family'];
                      data_toAdd['uid'] = currentUser.uid;
                      data_toAdd['feedback'] = '';
                      data_toAdd['time'] = Timestamp.now();
                      map[l.toString()] = data_toAdd;
                    }

                  }
                  data_signed['signed'] = map;
                  count = map.length;
                  if (data_signed.length == task.getPartMap(type, k)['hasItem']) {
                    data_signed['end'] = Timestamp.now();
                    data_signed['isCitationed'] = false;
                  }
                  Firestore.instance
                      .collection(type)
                      .document(snapshot.documentID)
                      .updateData(data_signed);
                } else {
                  Map<String, dynamic> map = Map<String, dynamic>();
                  Map<String, dynamic> data_toAdd = Map<String, dynamic>();
                  for (int l = 0; l < numberItem.length; l++) {
                    bool isCheck = numberItem[l];
                    if (isCheck) {
                      data_toAdd['phaze'] = 'signed';
                      data_toAdd['family'] = userData['family'];
                      data_toAdd['uid'] = currentUser.uid;
                      data_toAdd['feedback'] = '';
                      data_toAdd['time'] = Timestamp.now();
                      map[l.toString()] = data_toAdd;
                    }
                  }
                  count = map.length;
                  data_signed['signed'] = map;
                  data_signed['page'] = k;
                  data_signed['uid'] = uid;
                  data_signed['start'] = Timestamp.now();
                  data_signed['signed'] = {number.toString(): data_toAdd};
                  data_signed['group'] = userData['group'];
                  if (data_signed.length == task.getPartMap(type, k)['hasItem']) {
                    data_signed['end'] = Timestamp.now();
                    data_signed['isCitationed'] = false;
                  }
                  Firestore.instance.collection(type).add(data_signed);
                }
              });
              Firestore.instance
                  .collection('user')
                  .where('group', isEqualTo: userData['group'])
                  .where('uid', isEqualTo: uid)
                  .getDocuments()
                  .then((data) {
                DocumentSnapshot snapshot = data.documents[0];
                Map<String, dynamic> map = Map<String, int>();
                if (snapshot[type] != null) {
                  map = snapshot[type];
                  if (map[k.toString()] != null) {
                    map[k.toString()] == count;
                  } else {
                    map[k.toString()] = count;
                  }
                } else {
                  map[k.toString()] = count;
                }
                var mapSend = {type: map};
                Firestore.instance
                    .collection('user')
                    .document(snapshot.documentID)
                    .updateData(mapSend);

                if (map[k.toString()] == count) {
                  onFinish(uid, type, k);
                }
              });

              // --- End New --- //

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
        }
        data[listCategory[i]] = data_item;
      }*/
      //print(data);
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
            Map<String, dynamic> toAdd = new Map<String, dynamic>();
            List<dynamic> numbers = new List<dynamic>();
            toAdd['page'] = k;
            for (int l = 0; l < numberItem.length; l++) {
              bool isCheck = numberItem[l];
              if (isCheck) {
                numbers.add(l);
              }
            }
            if(numbers.length != 0){
              toAdd['numbers'] = numbers;
              data_item.add(toAdd);
            }
          }
        }
        data[listCategory[i]] = data_item;
      }
      print(data);

      Firestore.instance.collection('lump').add(data).then((value) =>
          Navigator.popUntil(context, ModalRoute.withName('/homeLump')));
    });
  }

  Future<void> onFinish(String uid, String type, int page) async {
    var task = new Task();
    var theme = new ThemeInfo();
    QuerySnapshot data = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .where('group', isEqualTo: userData['group'])
        .getDocuments();
    DocumentSnapshot snapshot = data.documents[0];
    Map<String, dynamic> map = Map<String, dynamic>();
    Map<String, dynamic> taskMap = task.getPartMap(type, page);
    String body = theme.getTitle(type) +
        ' ' +
        taskMap['number'] +
        ' ' +
        taskMap['title'] +
        'を完修！';
    map['family'] = snapshot['family'];
    map['first'] = snapshot['first'];
    map['call'] = snapshot['call'];
    map['uid'] = snapshot['uid'];
    map['congrats'] = 0;
    map['body'] = body;
    map['type'] = type;
    map['group'] = snapshot['group'];
    map['time'] = Timestamp.now();
    Firestore.instance.collection('effort').add(map);
    Firestore.instance
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('group', isEqualTo: userData['group'])
        .getDocuments();
  }
}
