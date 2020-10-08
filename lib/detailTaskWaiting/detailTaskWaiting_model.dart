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
  User currentUser;
  String documentID;
  String documentID_type;
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
            final StorageReference ref = FirebaseStorage()
                .ref()
                .child(taskSnapshot.data()['data'][i]['body']);
            final String url = await ref.getDownloadURL();
            body.add(url);
          } else {
            final StorageReference ref = FirebaseStorage()
                .ref()
                .child(taskSnapshot.data()['data'][i]['body']);
            final String url = await ref.getDownloadURL();
            final videoPlayerController = VideoPlayerController.network(url);
            await videoPlayerController.initialize();
            final chewieController = ChewieController(
                videoPlayerController: videoPlayerController,
                aspectRatio: videoPlayerController.value.aspectRatio,
                autoPlay: false,
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

  void onSnapshotHasData(DocumentSnapshot taskSnapshot) async {
    isLoaded = false;
    if (taskSnapshot != null) {
      if (taskSnapshot.id != documentID) {
        body = List<dynamic>();
        documentID = taskSnapshot.id;
        uid_get = taskSnapshot.data()['uid'];
        type = taskSnapshot.data()['type'];
        page = taskSnapshot.data()['page'];
        number = taskSnapshot.data()['number'];
        dataMap = taskSnapshot.data()['data'];
        if (taskSnapshot != null) {
          for (int i = 0; i < taskSnapshot.data()['data'].length; i++) {
            if (taskSnapshot.data()['data'][i]['type'] == 'text') {
              body.add(taskSnapshot.data()['data'][i]['body']);
            } else if (taskSnapshot.data()['data'][i]['type'] == 'image') {
              final StorageReference ref = FirebaseStorage()
                  .ref()
                  .child(taskSnapshot.data()['data'][i]['body']);
              final String url = await ref.getDownloadURL();
              body.add(url);
            } else {
              final StorageReference ref = FirebaseStorage()
                  .ref()
                  .child(taskSnapshot.data()['data'][i]['body']);
              final String url = await ref.getDownloadURL();
              final videoPlayerController = VideoPlayerController.network(url);
              await videoPlayerController.initialize();
              final chewieController = ChewieController(
                  videoPlayerController: videoPlayerController,
                  aspectRatio: 16 / 9,
                  autoPlay: false,
                  looping: false);
              body.add(chewieController);
            }
          }
          notifyListeners();
        } else {
          taskFinished = true;
        }
      }
    } else {
      taskFinished = true;
    }
    isLoaded = true;
  }

  void onTextChanged(String text) async {
    feedback = text;
  }

  void onTapSend() async {
    if (feedback != '') {
      isLoading = true;
      notifyListeners();
      User user = await FirebaseAuth.instance.currentUser;
      currentUser = user;
      currentUser.getIdTokenResult().then((token) async {
        tokenMap = token.claims;
        await updateDocumentInfo();
        await addEffort();
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
    if (feedback != '') {
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

  Future<void> updateUserInfo() async {
    var task = new Task();
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap['group'])
        .get()
        .then((data) {
      DocumentSnapshot snapshot = data.docs[0];
      Map<String, dynamic> map = Map<String, int>();
      if (snapshot.data()[type] != null) {
        map = snapshot.data()[type];
        if (map[page.toString()] != null) {
          map[page.toString()]++;
        } else {
          map[page.toString()] = 1;
        }
      } else {
        map[page.toString()] = 1;
      }
      var mapSend = {type: map};
      FirebaseFirestore.instance
          .collection('user')
          .doc(snapshot.id)
          .update(mapSend);

      if (map[page.toString()] == task.getPartMap(type, page)['hasItem']) {
        onFinish();
      }
    });
  }

  Future<void> updateDocumentInfo() async {
    var task = new Task();
    int count = 0;
    FirebaseFirestore.instance
        .collection(type)
        .where('uid', isEqualTo: uid_get)
        .where('page', isEqualTo: page)
        .where('group', isEqualTo: tokenMap['group'])
        .get()
        .then((data) {
      DocumentSnapshot snapshot = data.docs[0];
      documentID_type = snapshot.id;
      Map<String, dynamic> map = Map<String, dynamic>();
      map = snapshot.data()['signed'];
      map[number.toString()]['data'] = taskSnapshot.data()['data'];
      map[number.toString()]['phaze'] = 'signed';
      map[number.toString()]['family'] = tokenMap['family'];
      map[number.toString()]['uid'] = currentUser.uid;
      map[number.toString()]['feedback'] = feedback;
      map[number.toString()]['time'] = Timestamp.now();
      Map<String, dynamic> mapSend = Map<String, dynamic>();
      mapSend['signed'] = map;
      map.forEach((key, dynamic values) {
        Map<String, dynamic> partData = map[key.toString()];
        print(map);
        print(partData['phaze']);
        if (partData['phaze'] == 'signed') {
          count++;
        }
      });
      Map<String, dynamic> taskInfo = new Map<String, dynamic>();
      taskInfo = task.getPartMap(type, page);
      if (count == taskInfo['hasItem']) {
        mapSend['end'] = Timestamp.now();
        mapSend['isCitationed'] = false;
        if (type == 'gino') {
          if (taskInfo['examination']) {
            mapSend['phase'] = 'not examined';
          } else {
            mapSend['phase'] = 'complete';
          }
        }
      }
      FirebaseFirestore.instance
          .collection(type)
          .doc(snapshot.documentID)
          .update(mapSend);
      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid_get)
          .where('group', isEqualTo: tokenMap['group'])
          .get()
          .then((data) {
        DocumentSnapshot snapshot = data.docs[0];
        Map<String, dynamic> map = Map<String, int>();
        map.forEach((key, dynamic values) {
          Map<String, dynamic> partData = map[key.toString()];
          print(map);
          print(partData['phaze']);
          if (partData['phaze'] == 'signed') {
            count++;
          }
        });
        if (snapshot.data()[type] != null) {
          map = snapshot.data()[type];
          map[page.toString()] = count;
        } else {
          map[page.toString()] = count;
        }
        var mapSend = {type: map};
        FirebaseFirestore.instance
            .collection('user')
            .doc(snapshot.id)
            .update(mapSend);

        if (map[page.toString()] == task.getPartMap(type, page)['hasItem']) {
          onFinish();
        }
      });
    });
  }

  Future<void> updateDocumentInfo_reject() async {
    var task = new Task();
    FirebaseFirestore.instance
        .collection(type)
        .where('uid', isEqualTo: uid_get)
        .where('page', isEqualTo: page)
        .where('group', isEqualTo: tokenMap['group'])
        .get()
        .then((data) {
      DocumentSnapshot snapshot = data.documents[0];
      Map<String, dynamic> map = Map<String, dynamic>();
      map = snapshot.data()['signed'];
      map[number.toString()]['phaze'] = 'reject';
      map[number.toString()]['feedback'] = feedback;
      Map<String, dynamic> mapSend = Map<String, dynamic>();
      mapSend['signed'] = map;
      FirebaseFirestore.instance
          .collection(type)
          .doc(snapshot.id)
          .update(mapSend);
      deleteTask();
    });
  }

  Future<void> onFinish() async {
    var task = new Task();
    var theme = new ThemeInfo();
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
        'を完修！';
    map['family'] = snapshot.data()['family'];
    map['first'] = snapshot.data()['first'];
    map['call'] = snapshot.data()['call'];
    map['uid'] = snapshot.data()['uid'];
    map['congrats'] = 0;
    map['body'] = body;
    map['type'] = type;
    map['group'] = snapshot.data()['group'];
    map['time'] = Timestamp.now();
    map['data'] = dataMap;
    map['page'] = page;
    if (snapshot.data()['group'] == ' j27DETWHGYEfpyp2Y292' ||
        snapshot.data()['group'] == ' z4pkBhhgr0fUMN4evr5z') {
      map['taskID'] = documentID_type;
      map['enable_community'] = true;
    }
    FirebaseFirestore.instance.collection('effort').add(map);
    FirebaseFirestore.instance
        .collection(type)
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap['group'])
        .get();
  }

  Future<void> addEffort() async {
    var task = new Task();
    var theme = new ThemeInfo();
    QuerySnapshot data = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap['group'])
        .get();
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
    map['family'] = snapshot.data()['family'];
    map['first'] = snapshot.data()['first'];
    map['call'] = snapshot.data()['call'];
    map['uid'] = snapshot.data()['uid'];
    map['congrats'] = 0;
    map['body'] = body;
    map['type'] = type;
    map['page'] = page;
    map['number'] = number;
    map['group'] = snapshot.data()['group'];
    map['time'] = Timestamp.now();
  }

  Future<void> addNotification(String phase) async {
    var task = new Task();
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
