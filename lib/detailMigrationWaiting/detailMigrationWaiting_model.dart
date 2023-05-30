
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailMigrationWaitingModel extends ChangeNotifier {
  DocumentSnapshot? taskSnapshot;
  User? currentUser;
  String? documentID;
  String? documentID_type;
  String? uid_get;
  String? type;
  TextEditingController feedbackController = TextEditingController();
  int? page;
  int? number;
  bool isGet = false;
  bool isLoaded = false;
  bool isLoading = false;
  bool taskFinished = false;
  List<dynamic> body = <dynamic>[];
  Map<dynamic, dynamic>? tokenMap;
  List<dynamic>? dataMap;
  bool EmptyError = false;
  bool isEmpty = false;
  bool isFinish = false;
  bool isAdmin = false;

  Future<void> migrateAccount(BuildContext context, String? documentID) async {
    isLoading = true;

    final HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'asia-northeast1').httpsCallable(
      'executeMigrationCall',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 5),
      ),
    );

    try {
      final HttpsCallableResult result = await callable
          .call<String>(<String, String>{'documentID': documentID!});
      if (result.data == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('申請の送信が完了しました'),
        ));
        isFinish = true;
      } else if (result.data == 'you are not admin') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('アカウントの移行は管理者のみ操作可能です'),
        ));
      } else {
        isFinish = true;
      }
    } catch (e) {
      isFinish = true;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> rejectMigrate(BuildContext context, String? documentID) async {
    isLoading = true;

    final HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'asia-northeast1').httpsCallable(
      'rejectMigrationCall',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 5),
      ),
    );

    try {
      final HttpsCallableResult result = await callable
          .call<String>(<String, String>{'documentID': documentID!});
      if (result.data == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('申請の送信が完了しました'),
        ));
        isFinish = true;
      } else if (result.data == 'you are not admin') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('アカウントの移行は管理者のみ操作可能です'),
        ));
      } else {
        isFinish = true;
      }
    } catch (e) {
      isFinish = true;
    }
    isLoading = false;
    notifyListeners();
  }
}
