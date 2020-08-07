import 'dart:async';
import 'dart:collection';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TaskDetailScoutConfirmModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var list_isSelected = new List<bool>();
  String documentID;
  bool checkCitation = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot stepSnapshot;
  DocumentReference documentReference;
  QuerySnapshot effortSnapshot;
  FirebaseUser currentUser;
  StreamSubscription<FirebaseUser> _listener;
  bool isGet = false;
  int page = 0;
  int quant = 0;
  int countToSend = 0;
  String documentID_exit;
  bool isLoaded = false;
  bool isExit = false;
  List<dynamic> body = List<dynamic>();
  List<dynamic> dataMap;

  var list_snapshot = new List<bool>();
  var list_attach = new List<dynamic>();
  var map_attach = new List<dynamic>();
  var isAdded = new List<dynamic>();
  var list_toSend = new List<dynamic>();
  var count_toSend = new List<dynamic>();
  var isLoading = new List<dynamic>();
  var dateSelected = new List<dynamic>();
  var dataList = new List<dynamic>();
  var textField_signature = new List<TextEditingController>();
  var textField_feedback = new List<TextEditingController>();
  Map<dynamic, dynamic> tokenMap;
  String type;
  String uid;

  TaskDetailScoutConfirmModel(
      int number, int quant, String _type, String _uid) {
    page = number;
    this.quant = quant;
    type = _type;
    uid = _uid;
  }

  void getSnapshot() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    list_snapshot = new List<bool>.generate(page, (index) => false);

    list_attach =
        new List<dynamic>.generate(quant, (index) => new List<dynamic>());

    map_attach =
        new List<dynamic>.generate(quant, (index) => new Map<int, dynamic>());

    isAdded = new List<dynamic>.generate(quant, (index) => false);

    isLoading = new List<dynamic>.generate(quant, (index) => false);
    dateSelected = new List<dynamic>.generate(quant, (index) => null);
    dataList =
        new List<dynamic>.generate(quant, (index) => new List<dynamic>());
    textField_signature =
        new List<TextEditingController>.generate(quant, (index) => null);
    textField_feedback =
        new List<TextEditingController>.generate(quant, (index) => null);

    list_toSend = new List<dynamic>.generate(
        quant, (index) => new List<Map<String, dynamic>>());

    count_toSend = new List<dynamic>.generate(quant, (index) => 0);

    FirebaseAuth.instance.currentUser().then((user) {
      currentUser = user;
      user.getIdToken().then((token) async {
        tokenMap = token.claims;
        Firestore.instance
            .collection(type)
            .where('group', isEqualTo: tokenMap['group'])
            .where('page', isEqualTo: page)
            .where('uid', isEqualTo: uid)
            .snapshots()
            .listen((data) async {
          if (data.documents.length != 0) {
            stepSnapshot = data.documents[0];
            documentID_exit = data.documents[0].documentID;
            isExit = true;
            for (int i = 0; i < quant; i++) {
              if (stepSnapshot['signed'][i.toString()] != null) {
                Map<String, dynamic> doc = stepSnapshot['signed'][i.toString()];
                if (doc != null) {
                  if (doc['phaze'] == 'signed') {
                    dateSelected[i] = doc['time'].toDate();
                    textField_signature[i] =
                        TextEditingController(text: doc['family']);
                    textField_feedback[i] =
                        TextEditingController(text: doc['feedback']);
                    dataMap = doc['data'];
                    if (dataMap != null) {
                      List<dynamic> body = List<dynamic>();
                      for (int j = 0; j < dataMap.length; j++) {
                        if (dataMap[j]['type'] == 'text') {
                          body.add(dataMap[j]['body']);
                        } else if (dataMap[j]['type'] == 'image') {
                          final StorageReference ref =
                              FirebaseStorage().ref().child(dataMap[j]['body']);
                          final String url = await ref.getDownloadURL();
                          body.add(url);
                        } else {
                          final StorageReference ref =
                              FirebaseStorage().ref().child(dataMap[j]['body']);
                          final String url = await ref.getDownloadURL();
                          final videoPlayerController =
                              VideoPlayerController.network(url);
                          await videoPlayerController.initialize();
                          final chewieController = ChewieController(
                              videoPlayerController: videoPlayerController,
                              aspectRatio:
                                  videoPlayerController.value.aspectRatio,
                              autoPlay: false,
                              looping: false);
                          body.add(chewieController);
                        }
                        dataList[i] = body;
                      }
                    }
                  }
                }
              }
            }
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

  void openTimePicker(DateTime dateTime, BuildContext context, int page) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
    );
    if (date != null) {
      dateSelected[page] = date;
      notifyListeners();
    }
  }

  void changeTime(DateTime dateTime, BuildContext context, String documentID, String type_time) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
    );
    if (date != null) {
      Firestore.instance.collection(type).document(documentID).updateData(<String, dynamic>{type_time: date});
      notifyListeners();
    }
  }

  void onPressCheckbox(bool e) async {
    checkCitation = e;
    notifyListeners();
  }

  void onTapSend(int number) async {
    isLoading[number] = true;
    notifyListeners();
    FirebaseAuth.instance.currentUser().then((user) async {
      currentUser = user;
      currentUser.getIdToken().then((token) async {
        tokenMap = token.claims;
        await updateUserInfo(number);
        isLoading[number] = false;
        //await updateDocumentInfo(number, isComplete);
      });
    });
  }

  void onTapCancel(int number) async {
    isLoading[number] = true;
    notifyListeners();
    FirebaseAuth.instance.currentUser().then((user) async {
      currentUser = user;
      currentUser.getIdToken().then((token) async {
        tokenMap = token.claims;
        await updateDocumentInfo_cancel(number);
        isLoading[number] = false;
      });
    });
  }

  void onTapExamination(String documentID) async {
    Firestore.instance.collection('gino').document(documentID).updateData(<String, dynamic>{'phase': 'complete', 'date_examination': DateTime.now()});
  }

  void onTapNotExamination(String documentID) async {
    Firestore.instance.collection('gino').document(documentID).updateData(<String, dynamic>{'phase': 'not examined', 'date_examination': FieldValue.delete()});
  }

  Future<void> updateUserInfo(int number) async {
    bool isComplete = checkCitation;
    var task = new Task();
    int count = 0;

    FirebaseUser user = await auth.currentUser();
    Map<String, dynamic> data_signed = Map<String, dynamic>();
    Firestore.instance
        .collection(type)
        .where('group', isEqualTo: tokenMap['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .getDocuments()
        .then((data) async {
      if (data.documents.length != 0) {
        DocumentSnapshot snapshot = data.documents[0];
        Map<String, dynamic> map = Map<String, dynamic>();
        Map<String, dynamic> data_toAdd = Map<String, dynamic>();
        map = snapshot['signed'];
        data_toAdd['phaze'] = 'signed';
        data_toAdd['family'] = tokenMap['family'];
        data_toAdd['uid'] = currentUser.uid;
        data_toAdd['feedback'] = '';
        data_toAdd['time'] = Timestamp.now();
        map[number.toString()] = data_toAdd;
        data_signed['signed'] = map;
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
          data_signed['end'] = Timestamp.now();
          data_signed['isCitationed'] = checkCitation;
          if(type == 'gino') {
            if (taskInfo['examination']) {
              data_signed['phase'] = 'not examined';
            } else {
              data_signed['phase'] = 'complete';
            }
          }
        }
        Firestore.instance
            .collection(type)
            .document(snapshot.documentID)
            .updateData(data_signed);
      } else {
        Map<String, dynamic> data_toAdd = Map<String, dynamic>();
        data_toAdd['phaze'] = 'signed';
        data_toAdd['family'] = tokenMap['family'];
        data_toAdd['uid'] = uid;
        data_toAdd['feedback'] = '';
        data_toAdd['time'] = Timestamp.now();
        data_signed['page'] = page;
        data_signed['uid'] = uid;
        data_signed['start'] = Timestamp.now();
        data_signed['signed'] = {number.toString(): data_toAdd};
        data_signed['group'] = tokenMap['group'];
        count = 1;
        Map<String, dynamic> taskInfo = new Map<String, dynamic>();
        taskInfo = task.getPartMap(type, page);
        if (count == taskInfo['hasItem']) {
          data_signed['end'] = Timestamp.now();
          data_signed['isCitationed'] = checkCitation;
          if(type == 'gino') {
            if (taskInfo['examination']) {
              data_signed['phase'] = 'not examined';
            } else {
              data_signed['phase'] = 'complete';
            }
          }
        }
        DocumentReference documentReference_add =
            await Firestore.instance.collection(type).add(data_signed);
      }

      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid)
          .where('group', isEqualTo: tokenMap['group'])
          .getDocuments()
          .then((data) {
        DocumentSnapshot snapshot = data.documents[0];
        Map<String, dynamic> map = Map<String, int>();
        if (snapshot[type] != null) {
          map = snapshot[type];
          map[page.toString()] = count;
        } else {
          map[page.toString()] = count;
        }
        var mapSend = {type: map};
        Firestore.instance
            .collection('user')
            .document(snapshot.documentID)
            .updateData(mapSend);

        if (map[page.toString()] == task.getPartMap(type, page)['hasItem'] && !isComplete) {
          onFinish();
        }
      });
    });
  }

  Future<void> updateDocumentInfo(int number, bool isComplete) async {
    FirebaseUser user = await auth.currentUser();
    Map<String, dynamic> data_signed = Map<String, dynamic>();
    Firestore.instance
        .collection(type)
        .where('group', isEqualTo: tokenMap['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .getDocuments()
        .then((data) async {
      if (data.documents.length != 0) {
        DocumentSnapshot snapshot = data.documents[0];
        Map<String, dynamic> map = Map<String, dynamic>();
        Map<String, dynamic> data_toAdd = Map<String, dynamic>();
        map = snapshot['signed'];
        data_toAdd['phaze'] = 'signed';
        data_toAdd['family'] = tokenMap['family'];
        data_toAdd['uid'] = currentUser.uid;
        data_toAdd['feedback'] = '';
        data_toAdd['time'] = Timestamp.now();
        map[number.toString()] = data_toAdd;
        data_signed['signed'] = map;
        if (isComplete) {
          data_signed['end'] = Timestamp.now();
        }
        Firestore.instance
            .collection(type)
            .document(snapshot.documentID)
            .updateData(data_signed);
      } else {
        Map<String, dynamic> data_toAdd = Map<String, dynamic>();
        data_toAdd['phaze'] = 'signed';
        data_toAdd['family'] = tokenMap['family'];
        data_toAdd['uid'] = uid;
        data_toAdd['feedback'] = '';
        data_toAdd['time'] = Timestamp.now();
        data_signed['page'] = page;
        data_signed['uid'] = uid;
        data_signed['start'] = Timestamp.now();
        data_signed['signed'] = {number.toString(): data_toAdd};
        data_signed['group'] = tokenMap['group'];
        if (isComplete) {
          data_signed['end'] = Timestamp.now();
        }
        DocumentReference documentReference_add =
            await Firestore.instance.collection(type).add(data_signed);
      }
    });
  }

  Future<void> updateDocumentInfo_cancel(int number) async {
    FirebaseUser user = await auth.currentUser();
    Map<String, dynamic> data_signed = Map<String, dynamic>();
    Firestore.instance
        .collection(type)
        .where('group', isEqualTo: tokenMap['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .getDocuments()
        .then((data) async {
      if (data.documents.length != 0) {
        int count = 0;
        DocumentSnapshot snapshot = data.documents[0];
        if (snapshot['signed'].length - 1 != 0) {
          Map<String, dynamic> map = Map<String, dynamic>();
          Map<String, dynamic> data_toAdd = Map<String, dynamic>();
          map = snapshot['signed'];
          map.remove(number.toString());
          data_signed['signed'] = map;
          data_signed['end'] = FieldValue.delete();
          map.forEach((key, dynamic values) {
            Map<String, dynamic> partData = map[key.toString()];
            print(map);
            print(partData['phaze']);
            if (partData['phaze'] == 'signed') {
              count++;
            }
          });
          Firestore.instance
              .collection(type)
              .document(snapshot.documentID)
              .updateData(data_signed);
        } else {
          count = 0;
          Firestore.instance
              .collection(type)
              .document(snapshot.documentID)
              .delete();
        }
        updateUserInfo_cancel(page, count);
      }
    });
  }

  Future<void> updateUserInfo_cancel(int page, int count) async {
    FirebaseUser user = await auth.currentUser();
    Map<String, dynamic> data_signed = Map<String, dynamic>();
    Map<String, dynamic> data_toAdd = Map<String, dynamic>();
    Firestore.instance
        .collection('user')
        .where('group', isEqualTo: tokenMap['group'])
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then((data) async {
      if (data.documents.length != 0) {
        DocumentSnapshot snapshot = data.documents[0];
        Map<String, dynamic> map = Map<String, dynamic>();
        map = snapshot[type];
        if (count != 0) {
          map[page.toString()] = count;
        } else {
          map.remove(page.toString());
        }
        data_signed[type] = map;
        Firestore.instance
            .collection('user')
            .document(snapshot.documentID)
            .updateData(data_signed);
      }
    });
  }

  Future<void> recordEndTime() async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['end'] = Timestamp.now();
    Firestore.instance
        .collection(type)
        .document(documentID_exit)
        .updateData(data);
  }

  Future<void> onFinish() async {
    var task = new Task();
    var theme = new ThemeInfo();
    QuerySnapshot data = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
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
    map['page'] = page;
    Firestore.instance.collection('effort').add(map);
    Firestore.instance
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('group', isEqualTo: tokenMap['group'])
        .getDocuments();
  }

  void onTapSave(int number, BuildContext context) async {
    isLoading[number] = true;
    notifyListeners();
    FirebaseAuth.instance.currentUser().then((user) async {
      currentUser = user;
      currentUser.getIdToken().then((token) async {
        tokenMap = token.claims;
        await updateData(number, context);
        isLoading[number] = false;
        notifyListeners();
        //await updateDocumentInfo(number, isComplete);
      });
    });
  }

  Future<void> updateData(int number, BuildContext context) async {
    Map<String, dynamic> data_signed = Map<String, dynamic>();
    Firestore.instance
        .collection(type)
        .where('group', isEqualTo: tokenMap['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .getDocuments()
        .then((data) async {
      DocumentSnapshot snapshot = data.documents[0];
      Map<String, dynamic> map = Map<String, dynamic>();
      Map<String, dynamic> data_toAdd = Map<String, dynamic>();
      map = snapshot['signed'];
      data_toAdd = map[number.toString()];
      data_toAdd['family'] = textField_signature[number].text;
      data_toAdd['feedback'] = textField_feedback[number].text;
      data_toAdd['time'] = dateSelected[number];
      map[number.toString()] = data_toAdd;
      data_signed['signed'] = map;
      Firestore.instance
          .collection(type)
          .document(snapshot.documentID)
          .updateData(data_signed);
      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: const Duration(seconds: 1),
        content: new Text('変更を保存しました'),
      ));
      checkDate(snapshot, dateSelected[number], snapshot.documentID, quant);
    });
  }

  Future<void> checkDate(DocumentSnapshot snapshot, DateTime time,
      String documentID, int quant) async {
    bool isStart = true;
    bool isEnd = true;
    DateTime dateStart;
    if (snapshot['start'] is Timestamp) {
      dateStart = snapshot['start'].toDate();
    } else {
      dateStart = snapshot['start'];
    }
    Map map = snapshot['signed'];
    for (int i = 0; i < map.length; i++) {
      if (map[i.toString()] != null) {
        DateTime date_toComparison;
        if (map[i.toString()]['time'] is Timestamp) {
          date_toComparison = map[i.toString()]['time'].toDate();
        } else {
          date_toComparison = map[i.toString()]['time'];
        }
        if (time.isAfter(date_toComparison)) {
          isStart = false;
        }
        if (time.isBefore(date_toComparison)) {
          isEnd = false;
        }
      }
    }
    Map<String, dynamic> data_toChange = Map<String, dynamic>();
    if (isStart) {
      data_toChange['start'] = time;
    }
    if (isEnd && snapshot['end'] != null) {
      data_toChange['end'] = time;
    }
    if (quant == 1 && dateStart != time) {
      data_toChange['start'] = time;
      data_toChange['end'] = time;
    }
    Firestore.instance
        .collection(type)
        .document(documentID)
        .updateData(data_toChange);
  }
}
