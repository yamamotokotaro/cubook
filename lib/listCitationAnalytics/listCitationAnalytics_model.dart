import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListCitationAnalyticsModel extends ChangeNotifier {
<<<<<<< HEAD
  DocumentSnapshot? userSnapshot;
  User? currentUser;
=======
  DocumentSnapshot userSnapshot;
  User currentUser;
>>>>>>> develop
  bool isGet = false;
  String? group;
  String group_before = '';
  String? group_claim;
  Map<String, dynamic> claims = <String, dynamic>{};

  Future<void> getGroup() async {
    final String? groupBefore = group;
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      group = snapshot.docs[0].get('group');
      if (group != groupBefore) {
        notifyListeners();
      }
      user.getIdTokenResult(true).then((IdTokenResult value) {
        final String? groupClaimBefore = group_claim;
        group_claim = value.claims!['group'];
        if (groupClaimBefore != group_claim) {
          notifyListeners();
        }
      });
    });
  }

  void onTapCititation(String documentID, BuildContext context, String? name,
      String? title, bool isDark) {
    FirebaseFirestore.instance
        .collection('challenge')
        .doc(documentID)
        .update(<String, dynamic>{'isCitationed': true}).then((value) {
      final SnackBar snackBar = SnackBar(
        content: Text(name! + ' の' + title! + 'を表彰済みにしました'),
        action: SnackBarAction(
          label: '取り消し',
          textColor: isDark ? Colors.blue[900] : Colors.blue[400],
          onPressed: () {
            FirebaseFirestore.instance
                .collection('challenge')
                .doc(documentID)
                .update(<String, dynamic>{'isCitationed': false});
          },
        ),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
