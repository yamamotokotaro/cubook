import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListTaskWaitingModel extends ChangeNotifier {
  QuerySnapshot taskSnapshot;
  bool isGet = false;
  bool isLoaded = false;

  Future getTaskSnapshot() async {
    isLoaded = false;
    notifyListeners();
    Firestore.instance.collection('task').snapshots().listen((data) {
      taskSnapshot = data;
      notifyListeners();
    });
    isGet = true;
    isLoaded = true;
    notifyListeners();
  }
}