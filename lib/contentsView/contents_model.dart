import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ContentsModel with ChangeNotifier {
  DocumentSnapshot contentSnapshot;
  String id_before;
  void getContent(String id) async {
    if(id != id_before) {
      Firestore.instance.collection('specialcontents').document(id).get().then((
          snapshot) {
        contentSnapshot = snapshot;
        notifyListeners();
      });
    }
  }
}
