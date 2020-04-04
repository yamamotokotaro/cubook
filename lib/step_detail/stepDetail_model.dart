import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class StepDetailModel extends ChangeNotifier{
  final FirebaseAuth auth = FirebaseAuth.instance;
  var list_isSelected = new List();
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
  bool isAdded = false;
  var list_snapshot = new List();
  var list_attach = new List();
  var map_attach = new List();

  StepDetailModel(int number, int quant) {
    numberPushed = number;
    this.quant = quant;
  }

  void getSnapshot() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    list_snapshot =
    new List.generate(numberPushed, (index) => false);

    list_attach =
    new List<dynamic>.generate(quant, (index) => new List<dynamic>());

    map_attach =
    new List<dynamic>.generate(quant, (index) => new Map<int, dynamic>());

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      Firestore.instance.collection('steps').where('number', isEqualTo: 0).snapshots().listen((data) {
        stepSnapshot = data.documents[0];
        notifyListeners();
      });
      isGet = true;
      notifyListeners();
    });
  }

  void getSnapshot_() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    list_snapshot =
    new List.generate(numberPushed, (index) => false);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      Firestore.instance.collection('steps').where('number', isEqualTo: 0).snapshots().listen((data) {
        stepSnapshot = data.documents[0];
        notifyListeners();
      });
      isGet = true;
      notifyListeners();
    });
  }

  void onClickSend(int number) async {
    Map<int, dynamic> MapDatas = map_attach[number];
    for(int i=0; i<MapDatas.length; i++){
      if(MapDatas[i].type == String){
      }
    }
  }

  /*void firestoreController(Map data) {
    print(data);
    if (isAdded) {
      updateDocument(data);
    } else {
      addDocument(data);
    }
  }

  Future addDocument(Map data) async {
    FirebaseUser user = await auth.currentUser();
    data["uid"] = user.uid;
    data["location"] = GeoPoint(position.latitude, position.longitude);
    data["date"] = Timestamp.now();
    isAdded = true;
    documentReference =
    await Firestore.instance.collection('posts').add(data);
    documentID = documentReference.documentID;
  }

  Future updateDocument(Map data) async {
    Firestore.instance
        .collection('posts')
        .document(documentReference.documentID)
        .updateData(data);
  }*/

  void onImagePressPick(int number, int index) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    map_attach[number][index] = image;
  }

  void onImagePressCamera(int number, int index) async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    map_attach[number][index] = image;
  }

  void onVideoPressPick(int number, int index) async {
    File image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    map_attach[number][index] = image;
  }

  void onVideoPressCamera(int number, int index) async {
    File image = await ImagePicker.pickVideo(source: ImageSource.camera);
    map_attach[number][index] = image;
  }

  void onTextChanged(int number, int index, String text) async {
    map_attach[number][index] = text;
    print(map_attach);
  }

  void onPressAdd() {
    list_isSelected.add(false);
    notifyListeners();
  }

  void onPressAdd_new(int index, String type) {
    list_attach[index].add(type);
    notifyListeners();
  }

  void onPressedCheckParent(bool e) {
    checkParent = e;
    notifyListeners();
  }
}