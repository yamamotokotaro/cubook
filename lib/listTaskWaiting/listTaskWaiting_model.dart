import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListTaskWaitingModel extends ChangeNotifier {
  QuerySnapshot taskSnapshot;
  bool isLoaded = false;

  Future getTaskSnapshot() async {
    isLoaded = true;
    Firestore.instance.collection('task').snapshots().listen((data) {
      taskSnapshot = data;
      notifyListeners();
    });
    notifyListeners();
  }
}