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
  var task = TaskContents();
  var list_isSelected = List<bool>();
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
  List<dynamic> body = <dynamic>[];
  List<dynamic> dataMap;

  var list_snapshot = List<bool>();
  var list_attach = List<dynamic>();
  var map_attach = <dynamic>[];
  var isAdded = <dynamic>[];
  var list_toSend = <dynamic>[];
  var count_toSend = List<dynamic>();
  var isLoading = List<dynamic>();
  var dateSelected = List<dynamic>();
  var dataList = <dynamic>[];
  var textField_signature = <TextEditingController>[];
  var textField_feedback = <TextEditingController>[];
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
    currentUser = FirebaseAuth.instance.currentUser;

    list_snapshot = List<bool>.generate(page, (index) => false);

    list_attach =
        List<dynamic>.generate(quant, (index) => List<dynamic>());

    map_attach =
        List<dynamic>.generate(quant, (index) => <int, dynamic>{});

    isAdded = List<dynamic>.generate(quant, (index) => false);

    isLoading = List<dynamic>.generate(quant, (index) => false);
    dateSelected = List<dynamic>.generate(quant, (index) => null);
    dataList =
        List<dynamic>.generate(quant, (index) => <dynamic>[]);
    textField_signature =
        List<TextEditingController>.generate(quant, (index) => null);
    textField_feedback =
        List<TextEditingController>.generate(quant, (index) => null);

    list_toSend = List<dynamic>.generate(
        quant, (index) => <Map<String, dynamic>>[]);

    count_toSend = List<dynamic>.generate(quant, (index) => 0);

    final User user = FirebaseAuth.instance.currentUser;
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
        int countSigned = 0;
        if (data.docs.isNotEmpty) {
          stepSnapshot = data.docs[0];
          documentID_exit = data.docs[0].id;
          isExit = true;
          for (int i = 0; i < quant; i++) {
            if (stepSnapshot.get('signed')[i.toString()] != null) {
              final Map<String, dynamic> doc =
                  stepSnapshot.get('signed')[i.toString()];
              if (doc != null) {
                if (doc['phaze'] == 'signed') {
                  countSigned++;
                  dateSelected[i] = doc['time'].toDate();
                  textField_signature[i] =
                      TextEditingController(text: doc['family']);
                  textField_feedback[i] =
                      TextEditingController(text: doc['feedback']);
                  dataMap = doc['data'];
                  if (dataMap != null) {
                    final List<dynamic> body = <dynamic>[];
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
        if (countSigned == quant - 1 &&
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
    final DateTime date = await showDatePicker(
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
      String typeTime) async {
    final DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateTime,
    );
    if (date != null) {
      FirebaseFirestore.instance
          .collection(type)
          .doc(documentID)
          .update(<String, dynamic>{typeTime: date});
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
    final User user = FirebaseAuth.instance.currentUser;
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
    final User user = FirebaseAuth.instance.currentUser;
    currentUser = user;
    currentUser.getIdTokenResult().then((token) async {
      tokenMap = token.claims;
      await updateData(number, context);
      isLoading[number] = false;
      notifyListeners();
    });
  }

  Future<void> updateData(int number, BuildContext context) async {
    final Map<String, dynamic> dataSigned = <String, dynamic>{};
    FirebaseFirestore.instance
        .collection(type)
        .where('group', isEqualTo: tokenMap['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .get()
        .then((data) async {
      final DocumentSnapshot snapshot = data.docs[0];
      Map<String, dynamic> map = <String, dynamic>{};
      Map<String, dynamic> dataToAdd = <String, dynamic>{};
      map = snapshot.get('signed');
      dataToAdd = map[number.toString()];
      dataToAdd['family'] = textField_signature[number].text;
      dataToAdd['feedback'] = textField_feedback[number].text;
      dataToAdd['time'] = dateSelected[number];
      map[number.toString()] = dataToAdd;
      dataSigned['signed'] = map;
      FirebaseFirestore.instance
          .collection(type)
          .doc(snapshot.id)
          .update(dataSigned);
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text('変更を保存しました'),
      ));
      checkDate(snapshot, dateSelected[number], snapshot.id, quant);
    });
  }

  Future<void> checkDate(DocumentSnapshot snapshot, DateTime time,
      String documentID, int quant) async {
    bool isStart = true;
    bool isEnd = true;
    DateTime dateStart;
    if (snapshot.get('start') is Timestamp) {
      dateStart = snapshot.get('start').toDate();
    } else {
      dateStart = snapshot.get('start');
    }
    final Map map = snapshot.get('signed');
    for (int i = 0; i < map.length; i++) {
      if (map[i.toString()] != null) {
        DateTime dateToComparison;
        if (map[i.toString()]['time'] is Timestamp) {
          dateToComparison = map[i.toString()]['time'].toDate();
        } else {
          dateToComparison = map[i.toString()]['time'];
        }
        if (time.isAfter(dateToComparison)) {
          isStart = false;
        }
        if (time.isBefore(dateToComparison)) {
          isEnd = false;
        }
      }
    }
    final Map<String, dynamic> dataToChange = <String, dynamic>{};
    if (isStart) {
      dataToChange['start'] = time;
    }
    if (isEnd && snapshot.get('end') != null) {
      dataToChange['end'] = time;
    }
    if (quant == 1 && dateStart != time) {
      dataToChange['start'] = time;
      dataToChange['end'] = time;
    }
    FirebaseFirestore.instance
        .collection(type)
        .doc(documentID)
        .update(dataToChange);
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

  void sendFile(PickedFile file, int index, String typeFile) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String subDirectoryName = tokenMap['group'] + '/' + uid;
    final ref = FirebaseStorage.instance
        .ref()
        .child(subDirectoryName)
        .child('$timestamp');
    UploadTask uploadTask;
    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes());
    } else {
      uploadTask = ref.putFile(File(file.path));
    }
    final dynamic snapshot = await Future.value(uploadTask);
    final String path = await snapshot.ref.getPath();
    final Map<String, dynamic> data = <String, dynamic>{};
    data.putIfAbsent('body', () => path);
    data.putIfAbsent('type', () => typeFile);
    final Map<String, dynamic> signed = stepSnapshot.get('signed');
    if (signed[index.toString()]['data'] != null) {
      signed[index.toString()]['data'].add(data);
    } else {
      final List<dynamic> dataList = List<dynamic>();
      dataList.add(data);
      signed[index.toString()]['data'] = dataList;
    }
    FirebaseFirestore.instance
        .collection(type)
        .doc(stepSnapshot.id)
        .update(<String, dynamic>{'signed': signed});
  }

  Future<void> deleteFile(int number, int index) async {
    final Map<String, dynamic> signed = stepSnapshot.get('signed');
    final String path = signed[number.toString()]['data'][index]['body'];
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
