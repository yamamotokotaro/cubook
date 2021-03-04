import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home_leader/homeLeader_view.dart';
import 'package:cubook/home_scout/homeScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart' show FirebaseAuthUi;
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  QuerySnapshot effortSnapshot;
  TextEditingController mailAddressController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
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
  List<dynamic> _token_notification = new List<dynamic>();
  bool isSended = false;
  Future<PermissionStatus> permissionStatus =
      NotificationPermissions.getNotificationPermissionStatus();

  void login() async {
    isLoaded = false;
    userSnapshot = null;
    currentUser = null;
    User user = await FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      currentUser = user;
      providerID = currentUser.providerData[0].providerId;
      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: currentUser.uid)
          .snapshots()
          .listen((data) {
        if (data.docs.length != 0) {
          userSnapshot = data.docs[0];
          username = userSnapshot.data()['name'] + userSnapshot.data()['call'];
          usercall = userSnapshot.data()['call'];
          groupName = userSnapshot.data()['groupName'];
          teamPosition = userSnapshot.data()['teamPosition'];
          position = userSnapshot.data()['position'];
          grade = userSnapshot.data()['grade'];
          age = userSnapshot.data()['age'];
          if (userSnapshot.data()['token_notification'] != null) {
            _token_notification = userSnapshot.data()['token_notification'];
          }
          NotificationPermissions.getNotificationPermissionStatus()
              .then((status) {
            switch (status) {
              case PermissionStatus.denied:
                permission = 'denied';
                break;
              case PermissionStatus.granted:
                permission = 'granted';
                break;
              case PermissionStatus.unknown:
                permission = 'unknown';
                break;
              default:
                return null;
            }
          });
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
          if (!isSended) {
            /*FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
            _firebaseMessaging.getToken().then((String token_get) {
              assert(token_get != null);
              token = token_get;
            });*/
            isSended = true;
          }
          isLoaded = true;
          notifyListeners();
        } else {
          isLoaded = true;
        }
      });
    } else {
      isLoaded = true;
      FirebaseAuth.instance.authStateChanges().listen((user_get) {
        if (user_get != null) {
          currentUser = user_get;
          providerID = currentUser.providerData[0].providerId;
          FirebaseFirestore.instance
              .collection('user')
              .where('uid', isEqualTo: currentUser.uid)
              .snapshots()
              .listen((data) {
            if (data.docs.length != 0) {
              userSnapshot = data.docs[0];
              username =
                  userSnapshot.data()['name'] + userSnapshot.data()['call'];
              usercall = userSnapshot.data()['call'];
              groupName = userSnapshot.data()['groupName'];
              teamPosition = userSnapshot.data()['teamPosition'];
              position = userSnapshot.data()['position'];
              grade = userSnapshot.data()['grade'];
              age = userSnapshot.data()['age'];
              if (userSnapshot.data()['token_notification'] != null) {
                _token_notification = userSnapshot.data()['token_notification'];
              }
              NotificationPermissions.getNotificationPermissionStatus()
                  .then((status) {
                switch (status) {
                  case PermissionStatus.denied:
                    permission = 'denied';
                    break;
                  case PermissionStatus.granted:
                    permission = 'granted';
                    break;
                  case PermissionStatus.unknown:
                    permission = 'unknown';
                    break;
                  default:
                    return null;
                }
              });
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
              if (!isSended) {
                /*FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
                _firebaseMessaging.getToken().then((String token_get) {
                  assert(token_get != null);
                  token = token_get;
                });*/
                isSended = true;
              }
              isLoaded = true;
              notifyListeners();
            } else {
              isLoaded = true;
            }
          });
        }
      });
    }
    notifyListeners();
  }

  void logout() async {
    if (kIsWeb) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } else {
      await FirebaseAuthUi.instance().logout();
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
    User user = await FirebaseAuth.instance.currentUser;
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

  Future<void> getCheckNotificationPermStatus() {
    NotificationPermissions.getNotificationPermissionStatus().then((status) {
      switch (status) {
        case PermissionStatus.denied:
          permission = 'denied';
          break;
        case PermissionStatus.granted:
          permission = 'granted';
          break;
        case PermissionStatus.unknown:
          permission = 'unknown';
          break;
        default:
          return null;
      }
      notifyListeners();
    });
  }

  void onStatusChange(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
        permission = 'denied';
        break;
      case PermissionStatus.granted:
        permission = 'granted';
        break;
      case PermissionStatus.unknown:
        permission = 'unknown';
        break;
      default:
        return null;
    }
    notifyListeners();
  }
}
