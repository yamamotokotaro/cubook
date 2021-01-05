import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailTaskWaitingModel extends ChangeNotifier {
  DocumentSnapshot taskSnapshot;
  User currentUser;
  String documentID;
  String documentID_type;
  String uid_get;
  String type;
  TextEditingController feedbackController = new TextEditingController();
  int page;
  int number;
  bool isGet = false;
  bool isLoaded = false;
  bool isLoading = false;
  bool taskFinished = false;
  List<dynamic> body = List<dynamic>();
  Map<dynamic, dynamic> tokenMap;
  List<dynamic> dataMap;
  bool EmptyError = false;

  Future<void> getTaskSnapshot(String _documentID) async {
    documentID = _documentID;
    isLoaded = false;
    FirebaseFirestore.instance
        .collection('task')
        .doc(documentID)
        .snapshots()
        .listen((data) async {
      taskSnapshot = data;
      if (taskSnapshot.data == null) {
        taskFinished = true;
        notifyListeners();
      } else {
        uid_get = taskSnapshot.data()['uid'];
        type = taskSnapshot.data()['type'];
        page = taskSnapshot.data()['page'];
        number = taskSnapshot.data()['number'];
        dataMap = taskSnapshot.data()['data'];
        for (int i = 0; i < taskSnapshot.data()['data'].length; i++) {
          if (taskSnapshot.data()['data'][i]['type'] == 'text') {
            body.add(taskSnapshot.data()['data'][i]['body']);
          } else if (taskSnapshot.data()['data'][i]['type'] == 'image') {
            final ref = FirebaseStorage.instance
                .ref()
                .child(taskSnapshot.data()['data'][i]['body']);
            final String url = await ref.getDownloadURL();
            body.add(url);
          } else {
            final ref = FirebaseStorage.instance
                .ref()
                .child(taskSnapshot.data()['data'][i]['body']);
            final String url = await ref.getDownloadURL();
            final videoPlayerController = VideoPlayerController.network(url);
            await videoPlayerController.initialize();
            final chewieController = ChewieController(
                videoPlayerController: videoPlayerController,
                aspectRatio: videoPlayerController.value.aspectRatio,
                autoPlay: false,
                allowPlaybackSpeedChanging: false,
                looping: false);
            body.add(chewieController);
          }
        }
        isLoaded = true;
      }
      isGet = true;
      isLoaded = true;
      notifyListeners();
    });
  }

  void onTapSend() async {
    if (feedbackController.text != '') {
      isLoading = true;
      notifyListeners();
      User user = await FirebaseAuth.instance.currentUser;
      currentUser = user;
      currentUser.getIdTokenResult().then((token) async {
        tokenMap = token.claims;
        signItem(uid_get, type, page, number, feedbackController.text, false, false);
        await addNotification('signed');
        await deleteTask();
      });
      isLoading = false;
    } else {
      EmptyError = true;
      notifyListeners();
    }
  }

  void onTapReject() async {
    if (feedbackController.text != '') {
      isLoading = true;
      notifyListeners();
      User user = await FirebaseAuth.instance.currentUser;
      currentUser = user;
      currentUser.getIdTokenResult().then((token) async {
        tokenMap = token.claims;
        await updateDocumentInfo_reject();
        await addNotification('reject');
      });
      isLoading = false;
    } else {
      EmptyError = true;
      notifyListeners();
    }
  }

  Future<void> updateDocumentInfo_reject() async {
    var task = new TaskContents();
    FirebaseFirestore.instance
        .collection(type)
        .where('uid', isEqualTo: uid_get)
        .where('page', isEqualTo: page)
        .where('group', isEqualTo: tokenMap['group'])
        .get()
        .then((data) {
      DocumentSnapshot snapshot = data.docs[0];
      Map<String, dynamic> map = Map<String, dynamic>();
      map = snapshot.data()['signed'];
      map[number.toString()]['phaze'] = 'reject';
      map[number.toString()]['feedback'] = feedbackController.text;
      Map<String, dynamic> mapSend = Map<String, dynamic>();
      mapSend['signed'] = map;
      FirebaseFirestore.instance
          .collection(type)
          .doc(snapshot.id)
          .update(mapSend);
      deleteTask();
    });
  }

  Future<void> addNotification(String phase) async {
    var task = new TaskContents();
    var theme = new ThemeInfo();
    String mes;
    if (phase == 'signed') {
      mes = 'サインされました';
    } else if (phase == 'reject') {
      mes = 'やり直しになりました';
    }
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap['group'])
        .get();
    DocumentSnapshot snapshot = data.docs[0];
    Map<String, dynamic> map = Map<String, dynamic>();
    Map<String, dynamic> taskMap = task.getPartMap(type, page);
    String body = theme.getTitle(type) +
        ' ' +
        taskMap['number'] +
        ' ' +
        taskMap['title'] +
        '(' +
        (number + 1).toString() +
        ')' +
        'が' +
        mes;
    map['uid'] = uid_get;
    map['body'] = body;
    map['type'] = type;
    map['page'] = page;
    map['number'] = number;
    map['group'] = snapshot.data()['group'];
    map['time'] = Timestamp.now();
    FirebaseFirestore.instance.collection('notification').add(map);
  }

  void deleteTask() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['date_signed'] = Timestamp.now();
    map['uid_signed'] = currentUser.uid;
    map['phase'] = 'signed';
    FirebaseFirestore.instance.collection('task').doc(documentID).update(map);
  }
}
