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
  late DocumentSnapshot taskSnapshot;
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

  Future<void> getTaskSnapshot(String? _documentID) async {
    documentID = _documentID;
    isLoaded = false;
    FirebaseFirestore.instance
        .collection('task')
        .doc(documentID)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> data) async {
      taskSnapshot = data;
      if (taskSnapshot.data == null) {
        taskFinished = true;
        notifyListeners();
      } else {
        uid_get = taskSnapshot.get('uid');
        type = taskSnapshot.get('type');
        page = taskSnapshot.get('page');
        number = taskSnapshot.get('number');
        dataMap = taskSnapshot.get('data');
        for (int i = 0; i < taskSnapshot.get('data').length; i++) {
          if (taskSnapshot.get('data')[i]['type'] == 'text') {
            body.add(taskSnapshot.get('data')[i]['body']);
          } else if (taskSnapshot.get('data')[i]['type'] == 'image') {
            final Reference ref = FirebaseStorage.instance
                .ref()
                .child(taskSnapshot.get('data')[i]['body']);
            final String url = await ref.getDownloadURL();
            body.add(url);
          } else {
            final Reference ref = FirebaseStorage.instance
                .ref()
                .child(taskSnapshot.get('data')[i]['body']);
            final String url = await ref.getDownloadURL();
            final VideoPlayerController videoPlayerController =
                VideoPlayerController.network(url);
            await videoPlayerController.initialize();
            final ChewieController chewieController = ChewieController(
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

  Future<void> onTapSend() async {
    if (feedbackController.text != '') {
      isLoading = true;
      notifyListeners();
      final User? user = FirebaseAuth.instance.currentUser;
      currentUser = user;
      currentUser!.getIdTokenResult().then((IdTokenResult token) async {
        tokenMap = token.claims;
        signItem(
            uid_get, type, page, number, feedbackController.text, false, false);
        await addNotification('signed');
        deleteTask();
      });
      isLoading = false;
    } else {
      EmptyError = true;
      notifyListeners();
    }
  }

  Future<void> onTapReject() async {
    if (feedbackController.text != '') {
      isLoading = true;
      notifyListeners();
      final User? user = FirebaseAuth.instance.currentUser;
      currentUser = user;
      currentUser!.getIdTokenResult().then((IdTokenResult token) async {
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
    final TaskContents task = TaskContents();
    FirebaseFirestore.instance
        .collection(type!)
        .where('uid', isEqualTo: uid_get)
        .where('page', isEqualTo: page)
        .where('group', isEqualTo: tokenMap!['group'])
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> data) {
      final DocumentSnapshot snapshot = data.docs[0];
      Map<String, dynamic>? map = <String, dynamic>{};
      map = snapshot.get('signed');
      map![number.toString()]['phaze'] = 'reject';
      map[number.toString()]['feedback'] = feedbackController.text;
      final Map<String, dynamic> mapSend = <String, dynamic>{};
      mapSend['signed'] = map;
      FirebaseFirestore.instance
          .collection(type!)
          .doc(snapshot.id)
          .update(mapSend);
      deleteTask();
    });
  }

  Future<void> addNotification(String phase) async {
    final TaskContents task = TaskContents();
    final ThemeInfo theme = ThemeInfo();
    late String mes;
    if (phase == 'signed') {
      mes = 'サインされました';
    } else if (phase == 'reject') {
      mes = 'やりなおしになりました';
    }
    final QuerySnapshot data = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid_get)
        .where('group', isEqualTo: tokenMap!['group'])
        .get();
    final DocumentSnapshot snapshot = data.docs[0];
    final Map<String, dynamic> map = <String, dynamic>{};
    final Map<String, dynamic> taskMap = task.getPartMap(type, page)!;
    final String body = theme.getTitle(type)! +
        ' ' +
        taskMap['number'] +
        ' ' +
        taskMap['title'] +
        '(' +
        (number! + 1).toString() +
        ')' +
        'が' +
        mes;
    map['uid'] = uid_get;
    map['body'] = body;
    map['type'] = type;
    map['page'] = page;
    map['number'] = number;
    map['group'] = snapshot.get('group');
    map['time'] = Timestamp.now();
    FirebaseFirestore.instance.collection('notification').add(map);
  }

  void deleteTask() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['date_signed'] = Timestamp.now();
    map['uid_signed'] = currentUser!.uid;
    map['phase'] = 'signed';
    FirebaseFirestore.instance.collection('task').doc(documentID).update(map);
  }
}
