import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import 'homeLeader/leaderHomeView.dart';
import 'homeScout/scoutHomeView.dart';

class HomeModel extends ChangeNotifier {
  DocumentSnapshot? userSnapshot;
  Map<String, dynamic>? userData;
  TextEditingController mailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User? currentUser;
  bool isGet = false;
  bool isLoaded = false;
  bool isConsent = false;
  String? position;
  String? grade;
  late Widget toShow;
  String? username = '';
  String? usercall = '';
  String? groupName;
  String? teamPosition;
  String? age = '';
  String? permission;
  String? providerID;
  Map<dynamic, dynamic>? tokenMap;
  String? token;
  bool isSended = false;

  Future<void> login() async {
    isLoaded = false;
    userSnapshot = null;
    currentUser = null;
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUser = user;
      providerID = currentUser!.providerData[0].providerId;
      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: currentUser!.uid)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> data) {
        if (data.docs.isNotEmpty) {
          userSnapshot = data.docs[0];
          userData = userSnapshot!.data() as Map<String, dynamic>?;
          username = userSnapshot!.get('name') + userSnapshot!.get('call');
          usercall = userSnapshot!.get('call');
          groupName = userSnapshot!.get('groupName');
          position = userSnapshot!.get('position');
          grade = userSnapshot!.get('grade');
          age = userSnapshot!.get('age');
          if (position == 'scout') {
            teamPosition = userData!['teamPosition'];
          }
          if (position == 'scout') {
            if (grade != null) {
              if (grade == 'cub') {
                toShow = ScoutHomeView();
              } else if (grade == 'boy') {
                if (teamPosition != null) {
                  if (teamPosition == 'teamLeader') {
                    toShow = Column(
                      children: <Widget>[HomeLeaderView(), ScoutHomeView()],
                    );
                  } else {
                    toShow = Column(
                      children: <Widget>[ScoutHomeView()],
                    );
                  }
                } else {
                  toShow = Column(
                    children: <Widget>[ScoutHomeView()],
                  );
                }
              } else if (grade == 'venture') {
                toShow = Column(
                  children: <Widget>[
                    ScoutHomeView(),
                  ],
                );
              }
            } else {
              toShow = ScoutHomeView();
            }
            getSnapshot();
          } else if (position == 'boyscout') {
            toShow = ScoutHomeView();
          } else if (position == 'groupleader') {
            toShow = Column(
              children: <Widget>[HomeLeaderView(), ScoutHomeView()],
            );
          } else if (position == 'leader') {
            toShow = HomeLeaderView();
          } else {
            toShow = const Center(
              child: Text('エラーが発生しました'),
            );
          }
          isLoaded = true;
          notifyListeners();
        } else {
          isLoaded = true;
          notifyListeners();
        }
      });
    } else {
      isLoaded = true;
      FirebaseAuth.instance.authStateChanges().listen((User? userGet) {
        if (userGet != null) {
          currentUser = userGet;
          providerID = currentUser!.providerData[0].providerId;
          FirebaseFirestore.instance
              .collection('user')
              .where('uid', isEqualTo: currentUser!.uid)
              .snapshots()
              .listen((QuerySnapshot<Map<String, dynamic>> data) {
            if (data.docs.isNotEmpty) {
              userSnapshot = data.docs[0];
              userData = userSnapshot!.data() as Map<String, dynamic>?;
              username = userSnapshot!.get('name') + userSnapshot!.get('call');
              usercall = userSnapshot!.get('call');
              groupName = userSnapshot!.get('groupName');
              teamPosition = userData!['teamPosition'];
              position = userSnapshot!.get('position');
              grade = userSnapshot!.get('grade');
              age = userSnapshot!.get('age');
              if (userData!['token_notification'] != null) {}
              if (position == 'scout') {
                if (grade != null) {
                  if (grade == 'cub') {
                    toShow = ScoutHomeView();
                  } else if (grade == 'boy') {
                    if (teamPosition != null) {
                      if (teamPosition == 'teamLeader') {
                        toShow = Column(
                          children: <Widget>[HomeLeaderView(), ScoutHomeView()],
                        );
                      } else {
                        toShow = Column(
                          children: <Widget>[ScoutHomeView()],
                        );
                      }
                    } else {
                      toShow = Column(
                        children: <Widget>[ScoutHomeView()],
                      );
                    }
                  } else if (grade == 'venture') {
                    toShow = Column(
                      children: <Widget>[
                        ScoutHomeView(),
                      ],
                    );
                  }
                } else {
                  toShow = ScoutHomeView();
                }
                getSnapshot();
              } else if (position == 'boyscout') {
                toShow = ScoutHomeView();
              } else if (position == 'groupleader') {
                toShow = Column(
                  children: <Widget>[HomeLeaderView(), ScoutHomeView()],
                );
              } else if (position == 'leader') {
                toShow = HomeLeaderView();
              } else {
                toShow = const Center(
                  child: Text('エラーが発生しました'),
                );
              }
              isLoaded = true;
              notifyListeners();
            } else {
              isLoaded = true;
              notifyListeners();
            }
          });
        } else {
          isLoaded = true;
          notifyListeners();
        }
      });
    }
  }

  Future<void> logout() async {
    if (kIsWeb) {
      // await FlutterAuthUi.signOut();
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } else {
      // await FlutterAuthUi.signOut();
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }
    currentUser = null;
    notifyListeners();
    login();
  }

  Future<void> getUserSnapshot() async {}

  Future<void> getSnapshot() async {
    final User? user = FirebaseAuth.instance.currentUser;
    currentUser = user;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: currentUser!.uid)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> data) {
      userSnapshot = data.docs[0];
      notifyListeners();
    });
    isGet = true;
    notifyListeners();
  }

  Future<void> increaseCount(String documentID) async {
    FirebaseFirestore.instance
        .collection('efforts')
        .doc(documentID)
        .update(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }
}
