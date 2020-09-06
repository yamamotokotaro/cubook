import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home_leader/homeLeader_view.dart';
import 'package:cubook/home_scout/homeBS_view.dart';
import 'package:cubook/home_scout/homeScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart' show FirebaseAuthUi;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notification_permissions/notification_permissions.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleAuthProvider _authProvider = GoogleAuthProvider();
  DocumentSnapshot userSnapshot;
  QuerySnapshot effortSnapshot;
  FirebaseUser currentUser;
  StreamSubscription<FirebaseUser> _listener;
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
  String age = '';
  String permission;
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
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        currentUser = user;
        Firestore.instance
            .collection('user')
            .where('uid', isEqualTo: currentUser.uid)
            .snapshots()
            .listen((data) {
          if (data.documents.length != 0) {
            userSnapshot = data.documents[0];
            username = userSnapshot['name'] + userSnapshot['call'];
            usercall = userSnapshot['call'];
            groupName = userSnapshot['groupName'];
            position = userSnapshot['position'];
            grade = userSnapshot['grade'];
            age = userSnapshot['age'];
            if (userSnapshot['token_notification'] != null) {
              _token_notification = userSnapshot['token_notification'];
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
              print(permission);
            });
            if (position == 'scout') {
              if (grade != null) {
                if (grade == 'cub') {
                  toShow = HomeScoutView();
                } else if (grade == 'boy') {
                  toShow = Column(
                    children: <Widget>[HomeBSView()],
                  );
                } else if (grade == 'venture') {
                  toShow = Column(
                    children: <Widget>[
                      HomeBSView(),
                    ],
                  );
                }
              } else {
                toShow = HomeScoutView();
              }
              getSnapshot();
            } else if (position == 'boyscout') {
              toShow = HomeBSView();
            } else if (position == 'groupleader') {
              toShow = Column(
                children: <Widget>[HomeBSView(), HomeLeaderView()],
              );
            } else if (position == 'leader') {
              toShow = HomeLeaderView();
            } else {
              toShow = Center(
                child: Text('エラーが発生しました'),
              );
            }
            if (!isSended) {
              FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
              _firebaseMessaging.getToken().then((String token_get) {
                assert(token_get != null);
                token = token_get;
                if (_token_notification.length != 0) {
                  if (!_token_notification.contains(token_get)) {
                    _token_notification.add(token_get);
                    Firestore.instance
                        .collection('user')
                        .document(userSnapshot.documentID)
                        .updateData(
                            {'token_notification': _token_notification});
                  }
                } else {
                  _token_notification.add(token_get);
                  Firestore.instance
                      .collection('user')
                      .document(userSnapshot.documentID)
                      .updateData({'token_notification': _token_notification});
                }
              });
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
      }
      notifyListeners();
    });
  }

  void logout() async {
    _token_notification.removeWhere((dynamic item) => item == token);
    Firestore.instance
        .collection('user')
        .document(userSnapshot.documentID)
        .updateData({'token_notification': _token_notification}).then(
            (value) async {
      final result = await FirebaseAuthUi.instance().logout();
      currentUser = null;
      login();
      notifyListeners();
      isSended = false;
    });
  }

  void getUserSnapshot() async {}

  void getSnapshot() async {
    currentUser = await _auth.currentUser();
    currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      currentUser = user;
      Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: currentUser.uid)
          .snapshots()
          .listen((data) {
        userSnapshot = data.documents[0];
        notifyListeners();
      });
      isGet = true;
      notifyListeners();
    });
  }

  void increaseCount(String documentID) async {
    Firestore.instance
        .collection('efforts')
        .document(documentID)
        .updateData(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }

  Future<void> getCheckNotificationPermStatus() {
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
      notifyListeners();
    });
  }

  void onStatusChange(PermissionStatus status){
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
