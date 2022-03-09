import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditActivityModel extends ChangeNotifier {
  QuerySnapshot? userSnapshot;
  late DocumentSnapshot activitySnapshot;
  int? countSnapshot;
  User? currentUser;
  bool isGet = false;
  String? group;
  String? position;
  String? age;
  DateTime? date;
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  bool EmptyError = false;
  List<Map<String, dynamic>> listMemberAbsent = <Map<String, dynamic>>[];
  Map<String, bool> uid_check = <String, bool>{};
  Map<String, dynamic> claims = <String, dynamic>{};
  Map<String, bool?> checkAbsents = <String, bool?>{};
  String? group_claim;
  String? documentID;

  void getGroup() async {
    final String? groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final DocumentSnapshot documentSnapshot = snapshot.docs[0];
      group = documentSnapshot.get('group');
      position = documentSnapshot.get('position');
      age = documentSnapshot.get('age');
      if (group != groupBefore) {
        notifyListeners();
      }
      /* user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });*/
    });
  }

  void openTimePicker(DateTime dateTime, BuildContext context) async {
    final DateTime? dateGet = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
    );
    if (dateGet != null) {
      date = dateGet;
      notifyListeners();
    }
  }

  void getInfo(DocumentSnapshot documentSnapshot) {
    if (documentID != documentSnapshot.id) {
      activitySnapshot = documentSnapshot;
      checkAbsents.clear();
      isGet = false;
      titleController.text = documentSnapshot.get('title');
      date = documentSnapshot.get('date').toDate();
      isGet = true;
      documentID = documentSnapshot.id;
      //notifyListeners();
    }
  }

  void getAbsents(QuerySnapshot? querySnapshot) {
    if (checkAbsents.isEmpty ||
        querySnapshot!.docs.length != countSnapshot) {
      for (int i = 0; i < querySnapshot!.docs.length; i++) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
        if(checkAbsents[documentSnapshot.id] == null) {
          checkAbsents[documentSnapshot.id] = documentSnapshot.get('absent');
        }
      }
      countSnapshot = querySnapshot.docs.length;
      //notifyListeners();
    }
  }

  void onCheckMember(String documentID) async {
    if (checkAbsents[documentID] != null) {
      checkAbsents[documentID] = !checkAbsents[documentID]!;
    } else {
      checkAbsents[documentID] = false;
    }
    notifyListeners();
    print('notifyListners');
    print(checkAbsents[documentID]);
  }

  void dismissUser(String id) async {
    await FirebaseFirestore.instance
        .collection('activity_personal')
        .doc(id)
        .delete();
    notifyListeners();
  }

  void cancelDismiss(String? id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('activity_personal')
        .doc(id)
        .set(data);
    notifyListeners();
  }

  void onPressSend(BuildContext context) async {
    int countUser = 0;
    int countAbsent = 0;
    isLoading = true;
    checkAbsents.forEach((String key, bool? absent) async {
      countUser++;
      if (absent!) {
        countAbsent++;
      }
      await FirebaseFirestore.instance
          .collection('activity_personal')
          .doc(key)
          .update(<String, dynamic>{
        'absent': absent,
        'date': date,
        'title': titleController.text
      });
    });
    FirebaseFirestore.instance
        .collection('activity')
        .doc(documentID)
        .update(<String, dynamic>{
      'count_absent': countAbsent,
      'count_user': countUser,
      'date': date,
      'title': titleController.text
    }).then((value) {
      Navigator.pop(context);
      EmptyError = false;
      isLoading = false;
    });
  }

  void onPressAdd(
      DocumentSnapshot userSnapshot, BuildContext context, bool isDark) {
    FirebaseFirestore.instance
        .collection('activity_personal')
        .add(<String, dynamic>{
      'absent': true,
      'activity': activitySnapshot.id,
      'age': userSnapshot.get('age'),
      'age_turn': userSnapshot.get('age_turn'),
      'date': activitySnapshot.get('date'),
      'group': activitySnapshot.get('group'),
      'name': userSnapshot.get('name'),
      'team': userSnapshot.get('team'),
      'title': activitySnapshot.get('title'),
      'uid': userSnapshot.get('uid')
    }).then((DocumentReference<Map<String, dynamic>> value) {
      final SnackBar snackBar = SnackBar(
        content: const Text('出席者リストに追加しました'),
        action: SnackBarAction(
          label: '取り消し',
          textColor: isDark ? Colors.blue[900] : Colors.blue[400],
          onPressed: () {
            FirebaseFirestore.instance
                .collection('activity_personal')
                .doc(value.id)
                .delete();
          },
        ),
        duration: const Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
