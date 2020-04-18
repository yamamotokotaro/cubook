import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailTaskWaitingModel extends ChangeNotifier {
  DocumentSnapshot taskSnapshot;
  FirebaseUser currentUser;
  String documentID;
  String feedback = '';
  String uid_get;
  String type;
  int page;
  int number;
  bool isGet = false;
  bool isLoaded = false;
  bool isLoading = false;
  bool taskFinished = false;
  List<dynamic> body = List<dynamic>();
  Map<dynamic, dynamic> tokenMap;

  Future<void> getTaskSnapshot(String _documentID) async {
    documentID = _documentID;
    isLoaded = false;
    print('j');
    Firestore.instance
        .collection('task')
        .document(documentID)
        .snapshots()
        .listen((data) async {
      taskSnapshot = data;
      print(data.data);
      if (taskSnapshot.data == null) {
        taskFinished = true;
      } else {
        uid_get = taskSnapshot['uid'];
        type = taskSnapshot['type'];
        page = taskSnapshot['page'];
        number = taskSnapshot['number'];
        for (int i = 0; i < taskSnapshot['data'].length; i++) {
          if (taskSnapshot['data'][i]['type'] == 'text') {
            body.add(taskSnapshot['data'][i]['body']);
          } else if (taskSnapshot['data'][i]['type'] == 'image') {
            final StorageReference ref =
                FirebaseStorage().ref().child(taskSnapshot['data'][i]['body']);
            final String url = await ref.getDownloadURL();
            body.add(url);
          } else {
            final StorageReference ref =
                FirebaseStorage().ref().child(taskSnapshot['data'][i]['body']);
            final String url = await ref.getDownloadURL();
            final videoPlayerController = VideoPlayerController.network(url);
            final chewieController = ChewieController(
                videoPlayerController: videoPlayerController,
                aspectRatio: 16 / 9,
                autoPlay: true,
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

  void onTextChanged(String text) async {
    feedback = text;
  }

  void onTapSend() async {
    if (feedback != '') {
      isLoading = true;
      notifyListeners();
      FirebaseAuth.instance.currentUser().then((user) async {
        currentUser = user;
        currentUser.getIdToken().then((token) async {
          print(token.claims);
          tokenMap = token.claims;
          await updateUserInfo();
          await updateDocumentInfo();
          await addEffort();
          await deleteTask();
        });
        isLoading = false;
      });
    }
  }

  Future<void> updateUserInfo() async {
    var task = new Task();
    Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap['group'])
        .getDocuments()
        .then((data) {
      DocumentSnapshot snapshot = data.documents[0];
      Map<String, dynamic> map = Map<String, int>();
      if (snapshot[type] != null) {
        map = snapshot[type];
        if (map[page.toString()] != null) {
          map[page.toString()]++;
        } else {
          map[page.toString()] = 1;
        }
      } else {
        map[page.toString()] = 1;
      }
      var mapSend = {type: map};
      Firestore.instance
          .collection('user')
          .document(snapshot.documentID)
          .updateData(mapSend);

      if (map[page.toString()] == task.getPartMap(type, page)['hasItem']) {
        onFinish();
      }
    });
  }

  Future<void> updateDocumentInfo() async {
    var task = new Task();
    Firestore.instance
        .collection(type)
        .where('uid', isEqualTo: uid_get)
        .where('page', isEqualTo: page)
        .where('group', isEqualTo: tokenMap['group'])
        .getDocuments()
        .then((data) {
      DocumentSnapshot snapshot = data.documents[0];
      Map<String, dynamic> map = Map<String, dynamic>();
      map = snapshot['signed'];
      map[number.toString()]['phaze'] = 'signed';
      map[number.toString()]['family'] = tokenMap['family'];
      map[number.toString()]['uid'] = currentUser.uid;
      map[number.toString()]['feedback'] = feedback;
      map[number.toString()]['time'] = Timestamp.now();
      Map<String, dynamic> mapSend = Map<String, dynamic>();
      mapSend['signed'] = map;
      if (map.length == task.getPartMap(type, page)['hasItem']) {
        mapSend['end'] = Timestamp.now();
      }
      Firestore.instance
          .collection(type)
          .document(snapshot.documentID)
          .updateData(mapSend);
    });
  }

  Future<void> onFinish() async {
    var task = new Task();
    var theme = new ThemeInfo();
    QuerySnapshot data = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap['group'])
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
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap['group'])
        .getDocuments();
  }

  Future<void> addEffort() async {
    var task = new Task();
    var theme = new ThemeInfo();
    QuerySnapshot data = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap['group'])
        .getDocuments();
    DocumentSnapshot snapshot = data.documents[0];
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
        'を完了！';
    map['family'] = snapshot['family'];
    map['first'] = snapshot['first'];
    map['call'] = snapshot['call'];
    map['uid'] = snapshot['uid'];
    map['congrats'] = 0;
    map['body'] = body;
    map['type'] = type;
    map['group'] = snapshot['group'];
    map['time'] = Timestamp.now();
  }

  void deleteTask() {
    Firestore.instance.collection('task').document(documentID).delete();
  }
}
