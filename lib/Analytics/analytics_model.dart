import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class AnalyticsModel extends ChangeNotifier{
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String group_before = '';
  String group_claim;
  String teamPosition;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getGroup() async {
    String group_before = group;
    String teamPosition_before = teamPosition;
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((snapshot) {
        userSnapshot = snapshot.documents[0];
        group = userSnapshot['group'];
        teamPosition = userSnapshot['teamPosition'];
        if (group != group_before || teamPosition != teamPosition_before) {
          notifyListeners();
        }
        user.getIdToken(refresh: true).then((value) {
          String group_claim_before = group_claim;
          group_claim = value.claims['group'];
          if (group_claim_before != group_claim) {
            notifyListeners();
          }
        });
      });
    });
  }

  void getSnapshot() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var list_isSelected = new List<bool>();
    String documentID;
    bool checkCitation = false;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    DocumentSnapshot stepSnapshot;
    DocumentReference documentReference;
    QuerySnapshot effortSnapshot;
    FirebaseUser currentUser;
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
    PageController controller;
    Map<dynamic, dynamic> tokenMap;
    String type;
    String uid;

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
}