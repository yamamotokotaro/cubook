import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TaskDetailScoutConfirmModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var list_isSelected = new List<bool>();
  String documentID;
  bool checkParent = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot stepSnapshot;
  DocumentReference documentReference;
  QuerySnapshot effortSnapshot;
  FirebaseUser currentUser;
  StreamSubscription<FirebaseUser> _listener;
  bool isGet = false;
  int numberPushed = 0;
  int quant = 0;
  int countToSend = 0;
  String documentID_exit;

  //bool isAdded = false;
  bool isLoaded = false;
  bool isExit = false;

  var list_snapshot = new List<bool>();
  var list_attach = new List<dynamic>();
  var map_attach = new List<dynamic>();
  var isAdded = new List<dynamic>();
  var list_toSend = new List<dynamic>();
  var count_toSend = new List<dynamic>();
  var isLoading = new List<dynamic>();
  Map<dynamic, dynamic> tokenMap;
  String type;
  String uid;

  TaskDetailScoutConfirmModel(
      int number, int quant, String _type, String _uid) {
    numberPushed = number;
    this.quant = quant;
    type = _type;
    uid = _uid;
  }

  void getSnapshot() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    list_snapshot = new List<bool>.generate(numberPushed, (index) => false);

    list_attach =
        new List<dynamic>.generate(quant, (index) => new List<dynamic>());

    map_attach =
        new List<dynamic>.generate(quant, (index) => new Map<int, dynamic>());

    isAdded = new List<dynamic>.generate(quant, (index) => false);

    isLoading = new List<dynamic>.generate(quant, (index) => false);

    list_toSend = new List<dynamic>.generate(
        quant, (index) => new List<Map<String, dynamic>>());

    count_toSend = new List<dynamic>.generate(quant, (index) => 0);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      user.getIdToken().then((token) async {
        tokenMap = token.claims;
        Firestore.instance
            .collection(type)
            .where('group', isEqualTo: tokenMap['group'])
            .where('page', isEqualTo: numberPushed)
            .where('uid', isEqualTo: uid)
            .snapshots()
            .listen((data) {
          if (data.documents.length != 0) {
            stepSnapshot = data.documents[0];
            documentID_exit = data.documents[0].documentID;
            isExit = true;
          } else {
            isExit = false;
          }
          isLoaded = true;
          notifyListeners();
        });
        isGet = true;
        notifyListeners();
      });
    });
  }

  void openTimePicker(DateTime dateTime, BuildContext context) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: dateTime,
    );
  }
}
