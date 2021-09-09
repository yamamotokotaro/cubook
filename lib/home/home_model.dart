import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home_leader/homeLeader_view.dart';
import 'package:cubook/home_scout/homeScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  Map<String, dynamic> userData;
  QuerySnapshot effortSnapshot;
  TextEditingController mailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User currentUser;
  bool isGet = false;
  bool isLoaded = false;
  bool isLoading_join = false;
  bool isConsent = false;
  String position;
  String grade;
  Widget toShow;
  String username = '';
  String usercall = '';
  String groupName;
  String teamPosition;
  String age = '';
  String permission;
  String providerID;
  Map<dynamic, dynamic> tokenMap;
  String token;
  List<dynamic> _token_notification = <dynamic>[];
  bool isSended = false;

  void login() async {
    isLoaded = false;
    userSnapshot = null;
    currentUser = null;
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUser = user;
      providerID = currentUser.providerData[0].providerId;
      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: currentUser.uid)
          .snapshots()
          .listen((data) {
        if (data.docs.isNotEmpty) {
          userSnapshot = data.docs[0];
          userData = userSnapshot.data() as Map<String, dynamic>;
          username = userSnapshot.get('name') + userSnapshot.get('call');
          usercall = userSnapshot.get('call');
          groupName = userSnapshot.get('groupName');
          position = userSnapshot.get('position');
          grade = userSnapshot.get('grade');
          age = userSnapshot.get('age');
          if(position == "scout") {
            teamPosition = userData['teamPosition'];
          }
          // if (userSnapshot.get('token_notification') != null) {
          //   _token_notification = userSnapshot.get('token_notification');
          // }
          // NotificationPermissions.getNotificationPermissionStatus()
          //     .then((status) {
          //   switch (status) {
          //     case PermissionStatus.denied:
          //       permission = 'denied';
          //       break;
          //     case PermissionStatus.granted:
          //       permission = 'granted';
          //       break;
          //     case PermissionStatus.unknown:
          //       permission = 'unknown';
          //       break;
          //     default:
          //       return null;
          //   }
          // });
          if (position == 'scout') {
            if (grade != null) {
              if (grade == 'cub') {
                toShow = HomeScoutView();
              } else if (grade == 'boy') {
                if (teamPosition != null) {
                  if (teamPosition == 'teamLeader') {
                    toShow = Column(
                      children: <Widget>[HomeLeaderView(), HomeScoutView()],
                    );
                  } else {
                    toShow = Column(
                      children: <Widget>[HomeScoutView()],
                    );
                  }
                } else {
                  toShow = Column(
                    children: <Widget>[HomeScoutView()],
                  );
                }
              } else if (grade == 'venture') {
                toShow = Column(
                  children: <Widget>[
                    HomeScoutView(),
                  ],
                );
              }
            } else {
              toShow = HomeScoutView();
            }
            getSnapshot();
          } else if (position == 'boyscout') {
            toShow = HomeScoutView();
          } else if (position == 'groupleader') {
            toShow = Column(
              children: <Widget>[HomeLeaderView(), HomeScoutView()],
            );
          } else if (position == 'leader') {
            toShow = HomeLeaderView();
          } else {
            toShow = Center(
              child: Text('エラーが発生しました'),
            );
          }
          // 通知関係
          /*if (!isSended) {
            final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
            _firebaseMessaging.getToken().then((String tokenGet) {
              assert(tokenGet != null);
              token = tokenGet;
            });
            isSended = true;
          }*/
          isLoaded = true;
          notifyListeners();
        } else {
          isLoaded = true;
          notifyListeners();
        }
      });
    } else {
      isLoaded = true;
      FirebaseAuth.instance.authStateChanges().listen((userGet) {
        if (userGet != null) {
          currentUser = userGet;
          providerID = currentUser.providerData[0].providerId;
          FirebaseFirestore.instance
              .collection('user')
              .where('uid', isEqualTo: currentUser.uid)
              .snapshots()
              .listen((data) {
            if (data.docs.isNotEmpty) {
              userSnapshot = data.docs[0];
              userData = userSnapshot.data() as Map<String, dynamic>;
              username =
                  userSnapshot.get('name') + userSnapshot.get('call');
              usercall = userSnapshot.get('call');
              groupName = userSnapshot.get('groupName');
              teamPosition = userData['teamPosition'];
              position = userSnapshot.get('position');
              grade = userSnapshot.get('grade');
              age = userSnapshot.get('age');
              if (userData['token_notification'] != null) {
                _token_notification = userSnapshot.get('token_notification');
              }
              // NotificationPermissions.getNotificationPermissionStatus()
              //     .then((status) {
              //   switch (status) {
              //     case PermissionStatus.denied:
              //       permission = 'denied';
              //       break;
              //     case PermissionStatus.granted:
              //       permission = 'granted';
              //       break;
              //     case PermissionStatus.unknown:
              //       permission = 'unknown';
              //       break;
              //     default:
              //       return null;
              //   }
              // });
              if (position == 'scout') {
                if (grade != null) {
                  if (grade == 'cub') {
                    toShow = HomeScoutView();
                  } else if (grade == 'boy') {
                    if (teamPosition != null) {
                      if (teamPosition == 'teamLeader') {
                        toShow = Column(
                          children: <Widget>[HomeLeaderView(), HomeScoutView()],
                        );
                      } else {
                        toShow = Column(
                          children: <Widget>[HomeScoutView()],
                        );
                      }
                    } else {
                      toShow = Column(
                        children: <Widget>[HomeScoutView()],
                      );
                    }
                  } else if (grade == 'venture') {
                    toShow = Column(
                      children: <Widget>[
                        HomeScoutView(),
                      ],
                    );
                  }
                } else {
                  toShow = HomeScoutView();
                }
                getSnapshot();
              } else if (position == 'boyscout') {
                toShow = HomeScoutView();
              } else if (position == 'groupleader') {
                toShow = Column(
                  children: <Widget>[HomeLeaderView(), HomeScoutView()],
                );
              } else if (position == 'leader') {
                toShow = HomeLeaderView();
              } else {
                toShow = const Center(
                  child: Text('エラーが発生しました'),
                );
              }
              // 通知関係
              /*if (!isSended) {
                final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
                _firebaseMessaging.getToken().then((String tokenGet) {
                  assert(tokenGet != null);
                  token = tokenGet;
                });
                isSended = true;
              }*/
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
    // notifyListeners();
  }

  void logout() async {
    if (kIsWeb) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } else {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      // await FirebaseAuthUi.instance().logout();
    }
    currentUser = null;
    notifyListeners();
    login();
  }

  /*void logout() async {
    _token_notification.removeWhere((dynamic item) => item == token);
    Firestore.instance
        .collection('user')
        .document(userSnapshot.documentID)
        .updateData(<String, dynamic>{
      'token_notification': _token_notification
    }).then((value) async {
      final result = await FirebaseAuthUi.instance().logout();
      currentUser = null;
      login();
      notifyListeners();
      isSended = false;
    }).catchError(() async {
      final result = await FirebaseAuthUi.instance().logout();
      currentUser = null;
      login();
      notifyListeners();
      isSended = false;
    });
  }*/

  void getUserSnapshot() async {}

  void getSnapshot() async {
    final User user = FirebaseAuth.instance.currentUser;
    currentUser = user;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: currentUser.uid)
        .snapshots()
        .listen((data) {
      userSnapshot = data.docs[0];
      notifyListeners();
    });
    isGet = true;
    notifyListeners();
  }

  void increaseCount(String documentID) async {
    FirebaseFirestore.instance
        .collection('efforts')
        .doc(documentID)
        .update(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }

  // void onStatusChange(PermissionStatus status) {
  //   switch (status) {
  //     case PermissionStatus.denied:
  //       permission = 'denied';
  //       break;
  //     case PermissionStatus.granted:
  //       permission = 'granted';
  //       break;
  //     case PermissionStatus.unknown:
  //       permission = 'unknown';
  //       break;
  //     default:
  //       return null;
  //   }
  //   notifyListeners();
  // }
}
