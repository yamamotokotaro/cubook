import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListCitationAnalyticsModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  FirebaseUser currentUser;
  bool isGet = false;
  String group;
  String group_before = '';
  String group_claim;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getGroup() async {
    String group_before = group;
    FirebaseAuth.instance.currentUser().then((user) {
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

  void onTapCititation(String documentID, BuildContext context, String name, String title, bool isDark) {
    Firestore.instance
        .collection('challenge')
        .document(documentID)
        .updateData(<String, dynamic>{'isCitationed': true}).then((value) {
      final snackBar = SnackBar(
        content: Text(name + ' の'+title+'を表彰済みにしました'),
        action: SnackBarAction(
          label: '取り消し',
          textColor: isDark ? Colors.blue[900] : Colors.blue[400],
          onPressed: () {
            Firestore.instance
                .collection('challenge')
                .document(documentID)
                .updateData(<String, dynamic>{'isCitationed': false});
          },
        ),
        duration: Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}