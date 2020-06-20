import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class TaskDetailScoutModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var list_isSelected = new List<bool>();
  String documentID;
  bool checkParent = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot stepSnapshot;
  DocumentReference documentReference;
  QuerySnapshot effortSnapshot;
  FirebaseUser currentUser;
  StreamSubscription<FirebaseUser> _listener;
  bool isGet = false;
  int numberPushed = 0;
  int quant = 0;
  int countToSend = 0;
  String documentID_exit;

  //bool isAdded = false;
  bool isLoaded = false;
  bool isExit = false;

  var list_snapshot = new List<bool>();
  var list_attach = new List<dynamic>();
  var map_attach = new List<dynamic>();
  var map_chewie = new List<dynamic>();
  var isAdded = new List<dynamic>();
  var list_toSend = new List<dynamic>();
  var count_toSend = new List<dynamic>();
  var isLoading = new List<dynamic>();
  List<dynamic> dataMap;
  var dataList = new List<dynamic>();
  Map<dynamic, dynamic> tokenMap;
  String type;

  TaskDetailScoutModel(int number, int quant, String _type) {
    numberPushed = number;
    this.quant = quant;
    type = _type;
  }

  void getSnapshot() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    list_snapshot = new List<bool>.generate(numberPushed, (index) => false);

    list_attach =
        new List<dynamic>.generate(quant, (index) => new List<dynamic>());

    map_attach =
        new List<dynamic>.generate(quant, (index) => new Map<int, dynamic>());

    map_chewie =
    new List<dynamic>.generate(quant, (index) => new Map<int, dynamic>());

    isAdded = new List<dynamic>.generate(quant, (index) => false);
    dataList =
    new List<dynamic>.generate(quant, (index) => new List<dynamic>());

    isLoading = new List<dynamic>.generate(quant, (index) => false);

    list_toSend = new List<dynamic>.generate(
        quant, (index) => new List<Map<String, dynamic>>());

    count_toSend = new List<dynamic>.generate(quant, (index) => 0);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      Firestore.instance
          .collection(type)
          .where('page', isEqualTo: numberPushed)
          .where('uid', isEqualTo: currentUser.uid)
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

  void getSnapshot_() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    list_snapshot = new List<bool>.generate(numberPushed, (index) => false);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      Firestore.instance
          .collection('steps')
          .where('page', isEqualTo: 0)
          .snapshots()
          .listen((data) {
        stepSnapshot = data.documents[0];
        notifyListeners();
      });
      isGet = true;
      notifyListeners();
    });
  }

  void onTapSend(int number) async {
    if (checkParent && map_attach[number].length != 0) {
      isLoading[number] = true;
      notifyListeners();

      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) {
          currentUser = user;
          user.getIdToken().then((token) async {
            tokenMap = token.claims;
            Map<int, dynamic> MapDatas = map_attach[number];
            list_toSend[number] =
                new List<dynamic>.generate(MapDatas.length, (index) => null);
            count_toSend[number] = MapDatas.length;
            for (int i = 0; i < MapDatas.length; i++) {
              if (MapDatas[i] is String) {
                await textSend(i, MapDatas[i], number);
              } else if (MapDatas[i] is File) {
                await fileSend(i, MapDatas[i], number);
              }
            }
          });
        }
      });
    }
  }

  void textSend(int index, String text, int number) {
    Map<String, dynamic> data = Map<String, dynamic>();
    data.putIfAbsent('body', () => text);
    firestoreController(data, number, index);
  }

  Future<dynamic> fileSend(int index, File file, int number) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String subDirectoryName = tokenMap['group'] + '/' + currentUser.uid;
    final StorageReference ref =
        FirebaseStorage().ref().child(subDirectoryName).child('${timestamp}');
    final StorageUploadTask uploadTask = ref.putFile(file);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    if (snapshot.error == null) {
      //String url = await snapshot.ref.getDownloadURL();
      String path = await snapshot.ref.getPath();
      Map<String, dynamic> data = Map<String, dynamic>();
      data.putIfAbsent('body', () => path);
      firestoreController(data, number, index);
    } else {
      //return 'Something goes wrong';
    }
  }

  void firestoreController(Map data, int number, int index) {
    data['type'] = list_attach[number][index];
    list_toSend[number][index] = data;
    count_toSend[number]--;
    if (count_toSend[number] == 0) {
      isAdded[number] = true;
      map_attach[number] = new Map<int, dynamic>();
      addDocument(list_toSend[number], number);
    }
  }

  Future addDocument(List list, int number) async {
    Map<String, dynamic> data = Map<String, dynamic>();
    FirebaseUser user = await auth.currentUser();
    Firestore.instance.collection('user').where('uid', isEqualTo: user.uid).getDocuments().then((userDatas) async {
      DocumentSnapshot userData = userDatas.documents[0];
      data["uid"] = user.uid;
      data["date"] = Timestamp.now();
      data["type"] = type;
      data['page'] = numberPushed;
      data['number'] = number;
      data['data'] = list;
      data['family'] = userData['family'];
      data['first'] = userData['first'];
      data['call'] = userData['call'];
      data['group'] = tokenMap['group'];
      data['phase'] = 'wait';
      isAdded[number] = true;
      documentReference = await Firestore.instance.collection('task').add(data);
      documentID = documentReference.documentID;
      Map<String, dynamic> data_signed = Map<String, dynamic>();
      if (isExit) {
        Map<String, dynamic> data_toAdd = Map<String, dynamic>();
        data_toAdd = stepSnapshot['signed'];
        data_toAdd[number.toString()] = {'phaze': 'wait', 'data': list};
        data_signed['signed'] = data_toAdd;
        Firestore.instance
            .collection(type)
            .document(documentID_exit)
            .updateData(data_signed);
      } else {
        Map<String, dynamic> data_toAdd = Map<String, dynamic>();
        data_toAdd['phaze'] = 'wait';
        data_toAdd['data'] = list;
        data_signed['page'] = numberPushed;
        data_signed['uid'] = user.uid;
        data_signed['start'] = Timestamp.now();
        data_signed['signed'] = {number.toString(): data_toAdd};
        data_signed['group'] = tokenMap['group'];
        DocumentReference documentReference_add =
            await Firestore.instance.collection(type).add(data_signed);
        documentID_exit = documentReference_add.documentID;
      }
      isLoading[number] = false;
    });
  }

  Future updateDocument(Map data) async {
    Firestore.instance
        .collection('task')
        .document(documentReference.documentID)
        .updateData(data);
  }

  void onImagePressPick(int number, int index) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    map_attach[number][index] = image;
    notifyListeners();
  }

  void onImagePressCamera(int number, int index) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    map_attach[number][index] = image;
    notifyListeners();
  }

  void onVideoPressPick(int number, int index) async {
    File image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    map_attach[number][index] = image;
    final videoPlayerController =
    VideoPlayerController.file(image);
    await videoPlayerController.initialize();
    map_chewie[number][index] = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio:
        videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false);
    notifyListeners();
  }

  void onVideoPressCamera(int number, int index) async {
    File image = await ImagePicker.pickVideo(
      source: ImageSource.camera,
    );
    map_attach[number][index] = image;
    final videoPlayerController =
    VideoPlayerController.file(image);
    await videoPlayerController.initialize();
    map_chewie[number][index] = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio:
        videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false);
    notifyListeners();
  }

  void onTextChanged(int number, int index, String text) async {
    map_attach[number][index] = text;
  }

  void onPressAdd() {
    list_isSelected.add(false);
    notifyListeners();
  }

  void onPressAdd_new(int index, String type) {
    list_attach[index].add(type);
    notifyListeners();
  }

  void onPressDelete(int number, int index) {
    map_attach[number].remove(index);
    list_attach[number].remove(index);
    if(map_chewie[number][index] != null){
      map_chewie[number].remove(index);
    }
    notifyListeners();
  }

  void onPressedCheckParent(bool e) {
    checkParent = e;
    notifyListeners();
  }
}
