import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class TaskDetailScoutModel extends ChangeNotifier {

  TaskDetailScoutModel(int? number, int? quant, String? _type) {
    page = number;
    this.quant = quant;
    type = _type;
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<bool> list_isSelected = <bool>[];
  String? documentID;
  String? group;
  bool? checkParent = false;
  late DocumentSnapshot stepSnapshot;
  late DocumentReference documentReference;
  QuerySnapshot? effortSnapshot;
  User? currentUser;
  StreamSubscription<User>? _listener;
  bool isGet = false;
  int? page = 0;
  int? quant = 0;
  int countToSend = 0;
  String? documentID_exit;
  late DocumentSnapshot userSnapshot;
  Map<String, dynamic>? stepData = <String, dynamic>{};

  bool isLoaded = false;
  bool isExit = false;

  List<bool> list_snapshot = <bool>[];
  List list_attach = <dynamic>[];
  List map_attach = <dynamic>[];
  List map_show = <dynamic>[];
  List isAdded = <dynamic>[];
  List list_toSend = <dynamic>[];
  List count_toSend = <dynamic>[];
  List isLoading = <dynamic>[];
  List<dynamic>? dataMap;
  List dataList = <dynamic>[];
  String? type;

  Future<void> getSnapshot() async {
    currentUser = FirebaseAuth.instance.currentUser;

    list_snapshot = List<bool>.generate(page!, (int index) => false);

    list_attach =
    List<dynamic>.generate(quant!, (int index) => <dynamic>[]);

    map_attach =
    List<dynamic>.generate(quant!, (int index) => <int, dynamic>{});

    map_show =
    List<dynamic>.generate(quant!, (int index) => <int, dynamic>{});

    isAdded = List<dynamic>.generate(quant!, (int index) => false);
    dataList =
    List<dynamic>.generate(quant!, (int index) => <dynamic>[]);

    isLoading = List<dynamic>.generate(quant!, (int index) => false);

    list_toSend = List<dynamic>.generate(
        quant!, (int index) => <Map<String, dynamic>>[]);

    count_toSend = List<dynamic>.generate(quant!, (int index) => 0);

    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: currentUser!.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> userDatas) async {
      group = userDatas.docs[0].get('group');
      FirebaseFirestore.instance
          .collection(type!)
          .where('page', isEqualTo: page)
          .where('uid', isEqualTo: currentUser!.uid)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> data) async {
        if (data.docs.isNotEmpty) {
          stepSnapshot = data.docs[0];
          documentID_exit = data.docs[0].id;
          stepData = stepSnapshot.data() as Map<String, dynamic>?;
          isExit = true;
          for (int i = 0; i < quant!; i++) {
            if (stepSnapshot.get('signed')[i.toString()] != null) {
              final Map<String, dynamic>? doc =
              stepSnapshot.get('signed')[i.toString()];
              if (doc != null) {
                if (doc['phaze'] == 'signed' || doc['phaze'] == 'wait') {
                  dataMap = doc['data'];
                  if (dataMap != null) {
                    final List<dynamic> body = <dynamic>[];
                    for (int j = 0; j < dataMap!.length; j++) {
                      if (dataMap![j]['type'] == 'text') {
                        body.add(dataMap![j]['body']);
                      } else if (dataMap![j]['type'] == 'image') {
                        final Reference ref = FirebaseStorage.instance
                            .ref()
                            .child(dataMap![j]['body']);
                        final String url = await ref.getDownloadURL();
                        body.add(url);
                      } else {
                        final Reference ref = FirebaseStorage.instance
                            .ref()
                            .child(dataMap![j]['body']);
                        final String url = await ref.getDownloadURL();
                        final VideoPlayerController videoPlayerController =
                        VideoPlayerController.network(url);
                        await videoPlayerController.initialize();
                        final ChewieController chewieController = ChewieController(
                            videoPlayerController: videoPlayerController,
                            aspectRatio:
                            videoPlayerController.value.aspectRatio,
                            allowPlaybackSpeedChanging: false,
                            allowFullScreen: false,
                            autoPlay: false,
                            looping: false);
                        body.add(chewieController);
                      }
                      dataList[i] = body;
                    }
                  }
                } else if (doc['phaze'] == 'reject' ||
                    doc['phaze'] == 'withdraw') {
                  dataMap = doc['data'];
                  if (dataMap != null) {
                    final List<dynamic> body = <dynamic>[];
                    for (int j = 0; j < dataMap!.length; j++) {
                      list_attach[i].add(dataMap![j]['type']);
                      if (dataMap![j]['type'] == 'text') {
                        map_attach[i][j] =
                            TextEditingController(text: dataMap![j]['body']);
                      } else if (dataMap![j]['type'] == 'image') {
                        final Reference ref = FirebaseStorage.instance
                            .ref()
                            .child(dataMap![j]['body']);
                        final String url = await ref.getDownloadURL();
                        map_attach[i][j] = dataMap![j]['body'];
                        map_show[i][j] = url;
                      } else {
                        final Reference ref = FirebaseStorage.instance
                            .ref()
                            .child(dataMap![j]['body']);
                        final String url = await ref.getDownloadURL();
                        final VideoPlayerController videoPlayerController =
                        VideoPlayerController.network(url);
                        await videoPlayerController.initialize();
                        final ChewieController chewieController = ChewieController(
                            videoPlayerController: videoPlayerController,
                            aspectRatio:
                            videoPlayerController.value.aspectRatio,
                            autoPlay: false,
                            allowPlaybackSpeedChanging: false,
                            allowFullScreen: false,
                            looping: false);
                        map_attach[i][j] = dataMap![j]['body'];
                        map_show[i][j] = chewieController;
                      }
//                      dataList[i] = body;
                    }
                  }
                }
              }
            }
          }
          isExit = true;
        } else {
          isExit = false;
        }
        isLoaded = true;
        notifyListeners();
      });
      isGet = true;
      notifyListeners();
    });
  }

  Future<void> onTapSend(int? number) async {
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> userDatas) async {
      userSnapshot = userDatas.docs[0];
      if (((type != 'usagi' &&
          type != 'sika' &&
          type != 'kuma' &&
          type != 'challenge') ||
          checkParent!) &&
          map_attach[number!].length != 0) {
        isLoading[number] = true;
        notifyListeners();
        print(map_attach);
        final Map<int, dynamic> MapDatas = map_attach[number];
        list_toSend[number] =
        List<dynamic>.generate(MapDatas.length, (int index) => null);
        count_toSend[number] = MapDatas.length;
        for (int i = 0; i < MapDatas.length; i++) {
          if (MapDatas[i] is TextEditingController) {
            textSend(i, MapDatas[i].text, number);
          } else if (MapDatas[i] is String) {
            textSend(i, MapDatas[i], number);
          } else if (MapDatas[i] is XFile) {
            await fileSend(i, MapDatas[i], number);
          }
        }
      }
    });
  }

  void textSend(int index, String? text, int number) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data.putIfAbsent('body', () => text);
    firestoreController(data, number, index);
  }

  Future<dynamic> fileSend(int index, XFile file, int number) async {
    final int timestamp = DateTime
        .now()
        .millisecondsSinceEpoch;
    final String subDirectoryName =
        userSnapshot.get('group') + '/' + currentUser!.uid;
    final Reference ref = FirebaseStorage.instance
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
    final String? path = await snapshot.ref.fullPath;
    final Map<String, dynamic> data = <String, dynamic>{};
    data.putIfAbsent('body', () => path);
    firestoreController(data, number, index);
  }

  void firestoreController(Map data, int number, int index) {
    data['type'] = list_attach[number][index];
    list_toSend[number][index] = data;
    count_toSend[number]--;
    if (count_toSend[number] == 0) {
      isAdded[number] = true;
      map_attach[number] = <int, dynamic>{};
      addDocument(list_toSend[number], number);
    }
  }

  Future addDocument(List list, int number) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    final User user = FirebaseAuth.instance.currentUser!;
    data['uid'] = user.uid;
    data['date'] = Timestamp.now();
    data['type'] = type;
    data['page'] = page;
    data['number'] = number;
    data['data'] = list;
    data['family'] = userSnapshot.get('family');
    data['first'] = userSnapshot.get('first');
    data['call'] = userSnapshot.get('call');
    data['group'] = userSnapshot.get('group');
    data['team'] = userSnapshot.get('team');
    data['phase'] = 'wait';
    isAdded[number] = true;
    documentReference =
    await FirebaseFirestore.instance.collection('task').add(data);
    documentID = documentReference.id;
    final Map<String, dynamic> dataSigned = <String, dynamic>{};
    if (isExit) {
      Map<String, dynamic>? dataToAdd = <String, dynamic>{};
      dataToAdd = stepSnapshot.get('signed');
      dataToAdd![number.toString()] = {'phaze': 'wait', 'data': list};
      dataSigned['signed'] = dataToAdd;
      FirebaseFirestore.instance
          .collection(type!)
          .doc(documentID_exit)
          .update(dataSigned);
    } else {
      final Map<String, dynamic> dataToAdd = <String, dynamic>{};
      dataToAdd['phaze'] = 'wait';
      dataToAdd['data'] = list;
      dataSigned['page'] = page;
      dataSigned['uid'] = user.uid;
      dataSigned['start'] = Timestamp.now();
      dataSigned['signed'] = {number.toString(): dataToAdd};
      dataSigned['group'] = userSnapshot.get('group');
      final DocumentReference documentReferenceAdd =
      await FirebaseFirestore.instance.collection(type!).add(dataSigned);
      documentID_exit = documentReferenceAdd.id;
    }

    list_attach =
    List<dynamic>.generate(quant!, (int index) => <dynamic>[]);

    map_attach =
    List<dynamic>.generate(quant!, (int index) => <int, dynamic>{});

    map_show =
    List<dynamic>.generate(quant!, (int index) => <int, dynamic>{});
    isLoading[number] = false;
  }

  Future updateDocument(Map data) async {
    FirebaseFirestore.instance
        .collection('task')
        .doc(documentReference.id)
        .update(data as Map<String, Object?>);
  }

  Future withdraw(int? number) async {
    FirebaseFirestore.instance
        .collection('task')
        .where('uid', isEqualTo: currentUser!.uid)
        .where('page', isEqualTo: page)
        .where('number', isEqualTo: number)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> documents) {
      for (int i = 0; i < documents.docs.length; i++) {
        final DocumentSnapshot snapshot = documents.docs[i];
        FirebaseFirestore.instance.collection('task').doc(snapshot.id).delete();
      }
      FirebaseFirestore.instance
          .collection(type!)
          .doc(stepSnapshot.id)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> document) {
        final Map<String, dynamic> signGet = document.get('signed');
        signGet[number.toString()]['phaze'] = 'withdraw';
        FirebaseFirestore.instance
            .collection(type!)
            .doc(stepSnapshot.id)
            .update(<String, dynamic>{'signed': signGet});
      });
    });
  }

  Future<void> onImagePressPick(int number, int index) async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    map_attach[number][index] = image;
    map_show[number][index] = await image?.readAsBytes();
    notifyListeners();
  }

  Future<void> onImagePressCamera(int number, int index) async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    map_attach[number][index] = image;
    map_show[number][index] = await image!.readAsBytes();
    notifyListeners();
  }

  Future<void> onVideoPressPick(int number, int index) async {
    final XFile? image = await ImagePicker().pickVideo(source: ImageSource.gallery);
    map_attach[number][index] = image;
    final VideoPlayerController videoPlayerController = VideoPlayerController.file(File(image!.path));
    await videoPlayerController.initialize();
    map_show[number][index] = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false);
    notifyListeners();
  }

  Future<void> onVideoPressCamera(int number, int index) async {
    final XFile? image = await ImagePicker().pickVideo(source: ImageSource.camera);
    map_attach[number][index] = image;
    final VideoPlayerController videoPlayerController = VideoPlayerController.file(File(image!.path));
    await videoPlayerController.initialize();
    map_show[number][index] = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false);
    notifyListeners();
  }

  void onPressAdd() {
    list_isSelected.add(false);
    notifyListeners();
  }

  void onPressAdd_new(int index, String type) {
    if (type == 'text') {
      map_attach[index][list_attach[index].length] = TextEditingController();
    }
    list_attach[index].add(type);
    notifyListeners();
  }

  void onPressDelete(int number, int index) {
    map_attach[number].remove(index);
    list_attach[number].remove(index);
    if (map_show[number][index] != null) {
      map_show[number].remove(index);
    }
    notifyListeners();
  }

  void onPressedCheckParent(bool? e) {
    checkParent = e;
    notifyListeners();
  }
}
