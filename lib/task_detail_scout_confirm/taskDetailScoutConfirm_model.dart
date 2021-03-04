import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TaskDetailScoutConfirmModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var task = new TaskContents();
  var list_isSelected = new List<bool>();
  String documentID;
  String group;
  bool checkCitation = false;
  DocumentSnapshot stepSnapshot;
  DocumentReference documentReference;
  QuerySnapshot effortSnapshot;
  User currentUser;
  bool isGet = false;
  int page = 0;
  int quant = 0;
  int countToSend = 0;
  String documentID_exit;
  String documentID_task;
  bool isLast = false;
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
  PageController controller;
  Map<dynamic, dynamic> tokenMap;
  String type;
  String uid;

  TaskDetailScoutConfirmModel(int number, int quant, String _type, String _uid,
      PageController _controller) {
    page = number;
    this.quant = quant;
    type = _type;
    uid = _uid;
    controller = _controller;
  }

  void getSnapshot() async {
    currentUser = await FirebaseAuth.instance.currentUser;

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

    User user = await FirebaseAuth.instance.currentUser;
    currentUser = user;
    user.getIdTokenResult().then((token) async {
      tokenMap = token.claims;
      group = tokenMap['group'];
      FirebaseFirestore.instance
          .collection(type)
          .where('group', isEqualTo: tokenMap['group'])
          .where('page', isEqualTo: page)
          .where('uid', isEqualTo: uid)
          .snapshots()
          .listen((data) async {
        int count_signed = 0;
        if (data.docs.length != 0) {
          stepSnapshot = data.docs[0];
          documentID_exit = data.docs[0].id;
          isExit = true;
          for (int i = 0; i < quant; i++) {
            if (stepSnapshot.data()['signed'][i.toString()] != null) {
              Map<String, dynamic> doc =
                  stepSnapshot.data()['signed'][i.toString()];
              if (doc != null) {
                if (doc['phaze'] == 'signed') {
                  count_signed++;
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
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child(dataMap[j]['body']);
                        final String url = await ref.getDownloadURL();
                        body.add(url);
                      } else {
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child(dataMap[j]['body']);
                        final String url = await ref.getDownloadURL();
                        final videoPlayerController =
                            VideoPlayerController.network(url);
                        await videoPlayerController.initialize();
                        final chewieController = ChewieController(
                            videoPlayerController: videoPlayerController,
                            aspectRatio:
                                videoPlayerController.value.aspectRatio,
                            autoPlay: false,
                            allowPlaybackSpeedChanging: false,
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
        if (count_signed == quant - 1 &&
            (type == 'challenge' || type == 'gino')) {
          isLast = true;
        } else {
          isLast = false;
        }
        isLoaded = true;
        notifyListeners();
      });
      isGet = true;
      notifyListeners();
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

  void changeTime(DateTime dateTime, BuildContext context, String documentID,
      String type_time) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
    );
    if (date != null) {
      FirebaseFirestore.instance
          .collection(type)
          .doc(documentID)
          .update(<String, dynamic>{type_time: date});
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
    await signItem(uid, type, page, number, '', checkCitation, false);
    isLoading[number] = false;
  }

  void onTapCancel(int number) async {
    isLoading[number] = true;
    notifyListeners();
    User user = await FirebaseAuth.instance.currentUser;
    currentUser = user;
    currentUser.getIdTokenResult().then((token) async {
      tokenMap = token.claims;
      await cancelItem(uid, type, page, number, false);
      isLoading[number] = false;
    });
  }

  void onTapExamination(String documentID) async {
    FirebaseFirestore.instance
        .collection('gino')
        .doc(documentID)
        .update(<String, dynamic>{
      'phase': 'complete',
      'date_examination': DateTime.now()
    });
  }

  void onTapNotExamination(String documentID) async {
    FirebaseFirestore.instance
        .collection('gino')
        .doc(documentID)
        .update(<String, dynamic>{
      'phase': 'not examined',
      'date_examination': FieldValue.delete(),
      'date_interview': FieldValue.delete()
    });
  }

  void onTapSave(int number, BuildContext context) async {
    isLoading[number] = true;
    notifyListeners();
    User user = await FirebaseAuth.instance.currentUser;
    currentUser = user;
    currentUser.getIdTokenResult().then((token) async {
      tokenMap = token.claims;
      await updateData(number, context);
      isLoading[number] = false;
      notifyListeners();
    });
  }

  Future<void> updateData(int number, BuildContext context) async {
    Map<String, dynamic> data_signed = Map<String, dynamic>();
    FirebaseFirestore.instance
        .collection(type)
        .where('group', isEqualTo: tokenMap['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .get()
        .then((data) async {
      DocumentSnapshot snapshot = data.docs[0];
      Map<String, dynamic> map = Map<String, dynamic>();
      Map<String, dynamic> data_toAdd = Map<String, dynamic>();
      map = snapshot.data()['signed'];
      data_toAdd = map[number.toString()];
      data_toAdd['family'] = textField_signature[number].text;
      data_toAdd['feedback'] = textField_feedback[number].text;
      data_toAdd['time'] = dateSelected[number];
      map[number.toString()] = data_toAdd;
      data_signed['signed'] = map;
      FirebaseFirestore.instance
          .collection(type)
          .doc(snapshot.id)
          .update(data_signed);
      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: const Duration(seconds: 1),
        content: new Text('変更を保存しました'),
      ));
      checkDate(snapshot, dateSelected[number], snapshot.id, quant);
    });
  }

  Future<void> checkDate(DocumentSnapshot snapshot, DateTime time,
      String documentID, int quant) async {
    bool isStart = true;
    bool isEnd = true;
    DateTime dateStart;
    if (snapshot.data()['start'] is Timestamp) {
      dateStart = snapshot.data()['start'].toDate();
    } else {
      dateStart = snapshot.data()['start'];
    }
    Map map = snapshot.data()['signed'];
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
    if (isEnd && snapshot.data()['end'] != null) {
      data_toChange['end'] = time;
    }
    if (quant == 1 && dateStart != time) {
      data_toChange['start'] = time;
      data_toChange['end'] = time;
    }
    FirebaseFirestore.instance
        .collection(type)
        .doc(documentID)
        .update(data_toChange);
  }

  void onImagePressPick(int number, int index) async {
    final file = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    sendFile(file, index, 'image');
    // notifyListeners();
  }

  void onImagePressCamera(int number, int index) async {
    final file = await ImagePicker().getImage(
        source: ImageSource.camera, imageQuality: 50);
    sendFile(file, index, 'image');
    // notifyListeners();
  }

  void onVideoPressPick(int number, int index) async {
    final file = await ImagePicker().getVideo(source: ImageSource.gallery);
    sendFile(file, index, 'video');
    // notifyListeners();
  }

  void onVideoPressCamera(int number, int index) async {
    final file = await ImagePicker().getVideo(source: ImageSource.camera);
    sendFile(file, index, 'video');
    // notifyListeners();
  }

  void sendFile(PickedFile file, int index, String type_file) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String subDirectoryName = tokenMap['group'] + '/' + uid;
    final ref = FirebaseStorage.instance
        .ref()
        .child(subDirectoryName)
        .child('${timestamp}');
    UploadTask uploadTask;
    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes());
    } else {
      uploadTask = ref.putFile(File(file.path));
    }
    dynamic snapshot = await Future.value(uploadTask);
    String path = await snapshot.ref.getPath();
    Map<String, dynamic> data = Map<String, dynamic>();
    data.putIfAbsent('body', () => path);
    data.putIfAbsent('type', () => type_file);
    Map<String, dynamic> signed = stepSnapshot.data()['signed'];
    if (signed[index.toString()]['data'] != null) {
      signed[index.toString()]['data'].add(data);
    } else {
      List<dynamic> dataList = new List<dynamic>();
      dataList.add(data);
      signed[index.toString()]['data'] = dataList;
    }
    FirebaseFirestore.instance
        .collection(type)
        .doc(stepSnapshot.id)
        .update(<String, dynamic>{'signed': signed});
  }

  Future<void> deleteFile(int number, int index) async {
    Map<String, dynamic> signed = stepSnapshot.data()['signed'];
    String path = signed[number.toString()]['data'][index]['body'];
    signed[number.toString()]['data'].removeAt(index);
    FirebaseFirestore.instance
        .collection(type)
        .doc(stepSnapshot.id)
        .update(<String, dynamic>{'signed': signed}).then((value) {
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.delete();
    });
  }
}
