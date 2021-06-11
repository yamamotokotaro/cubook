import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class CommunityModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  bool isLoading_comment = false;
  String documentID;
  bool isGet = false;
  String documentID_exit;
  List<dynamic> dataMap;
  TextEditingController commentController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var dateSelected = List<dynamic>();
  var dataList = <dynamic>[];

  QuerySnapshot userSnapshot;
  String group;
  String group_claim;
  Map<String, dynamic> claims = <String, dynamic>{};

  void getGroup() async {
    final String groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser;
    this.user = user;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      group = snapshot.docs[0].get('group');
      if (group != groupBefore) {
        notifyListeners();
      }
      /*user.getIdToken(refresh: true).then((value) {
        String group_claim_before = group_claim;
        group_claim = value.claims['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });*/
    });
  }

  void getData(DocumentSnapshot snapshot, int quant) async {
    final String documentIDBefore = snapshot.id;
    if (documentID != documentIDBefore) {
      isGet = false;
      dataList =
          List<dynamic>.generate(quant, (index) => List<dynamic>());
      dateSelected = List<dynamic>.generate(quant, (index) => null);

      for (int i = 0; i < quant; i++) {
        if (snapshot.get('signed')[i.toString()] != null) {
          final Map<String, dynamic> doc = snapshot.get('signed')[i.toString()];
          if (doc != null) {
            if (doc['phaze'] == 'signed') {
              dateSelected[i] = doc['time'].toDate();
              dataMap = doc['data'];
              if (dataMap != null) {
                final List<dynamic> body = <dynamic>[];
                for (int j = 0; j < dataMap.length; j++) {
                  if (dataMap[j]['type'] == 'text') {
                    body.add(dataMap[j]['body']);
                  } else if (dataMap[j]['type'] == 'image') {
                    final ref =
                        FirebaseStorage.instance.ref().child(dataMap[j]['body']);
                    final String url = await ref.getDownloadURL();
                    body.add(url);
                  } else {
                    final ref =
                        FirebaseStorage.instance.ref().child(dataMap[j]['body']);
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
      documentID = snapshot.id;
      notifyListeners();
    }
  }

  void sendComment(String effortID, BuildContext context) async {
    if (commentController.text != '') {
      isLoading_comment = true;
      notifyListeners();
      final User user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: user.uid)
            .where('group', isEqualTo: group)
            .get()
            .then((data) {
          final DocumentSnapshot snapshot = data.docs[0];
          FirebaseFirestore.instance
              .collection('comment')
              .add(<String, dynamic>{
            'group': group,
            'uid': user.uid,
            'body': commentController.text,
            'effortID': effortID,
            'name': snapshot.get('name'),
            'age': snapshot.get('age'),
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
    } else {
      notifyListeners();
    }
  }

  void deleteComent(String documentID) {
    FirebaseFirestore.instance.collection('comment').doc(documentID).delete();
  }
}
