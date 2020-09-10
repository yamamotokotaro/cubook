import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class CommunityModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isLoading_comment = false;
  String documentID;
  bool isGet = false;
  String documentID_exit;
  List<dynamic> dataMap;
  TextEditingController commentController = TextEditingController();
  ScrollController scrollController = new ScrollController();

  var dateSelected = new List<dynamic>();
  var dataList = new List<dynamic>();

  QuerySnapshot userSnapshot;
  String group;
  String group_claim;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
      this.user = user;
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((snapshot) {
        group = snapshot.documents[0]['group'];
        if (group != group_before) {
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

  void getData(DocumentSnapshot snapshot, int quant) async {
    String documentID_before = snapshot.documentID;
    if (documentID != documentID_before) {
      dataList =
          new List<dynamic>.generate(quant, (index) => new List<dynamic>());
      dateSelected = new List<dynamic>.generate(quant, (index) => null);

      for (int i = 0; i < quant; i++) {
        if (snapshot['signed'][i.toString()] != null) {
          Map<String, dynamic> doc = snapshot['signed'][i.toString()];
          if (doc != null) {
            if (doc['phaze'] == 'signed') {
              dateSelected[i] = doc['time'].toDate();
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
                        aspectRatio: videoPlayerController.value.aspectRatio,
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
      isGet = true;
      documentID = snapshot.documentID;
      notifyListeners();
    }
  }

  void sendComment(String effortID, BuildContext context) {
    scrollController.animateTo(20 /*scrollController.position.maxScrollExtent*/,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    if (commentController.text != '') {
      isLoading_comment = true;
      notifyListeners();
      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) {
          Firestore.instance
              .collection('user')
              .where('uid', isEqualTo: user.uid)
              .where('group', isEqualTo: group)
              .getDocuments()
              .then((data) {
            DocumentSnapshot snapshot = data.documents[0];
            Firestore.instance.collection('comment').add({
              'group': group,
              'uid': user.uid,
              'body': commentController.text,
              'effortID': effortID,
              'name': snapshot['name'],
              'age': snapshot['age'],
              'time': Timestamp.now()
            }).then((value) {
              commentController.clear();
              FocusScope.of(context).unfocus();
              isLoading_comment = false;
              scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut);
              notifyListeners();
            });
          });
        }
      });
    } else {
      notifyListeners();
    }
  }

  void deleteComent(String documentID) {
    Firestore.instance.collection('comment').document(documentID).delete();
  }
}
