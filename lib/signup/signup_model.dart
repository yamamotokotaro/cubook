import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SignupModel with ChangeNotifier {
  List<bool> isSelect_type = [false, false];
  bool isLoading_join = false;
  bool? isConsent = false;
  String joinCode = '';
  String mes_join = '';
  String? dropdown_text;

  TextEditingController groupController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController firstController = TextEditingController();

  Future<void> joinRequest() async {
    if (isConsent! && joinCode != '') {
      isLoading_join = true;
      notifyListeners();

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.getIdTokenResult().then((IdTokenResult token) async {
          const String url =
              'https://asia-northeast1-cubook-3c960.cloudfunctions.net/joinGroup';
          final Map<String, String> headers = {
            'content-type': 'application/json'
          };
          final String body =
              json.encode({'idToken': token.token, 'joinCode': joinCode});

          final http.Response resp =
              await http.post(Uri.parse(url), headers: headers, body: body);
          final Map<dynamic, dynamic>? tokenMap = token.claims;
          isLoading_join = false;
          if (resp.body == 'success') {
            mes_join = '';
            Timer _timer;
          } else if (resp.body == 'No such document!' ||
              resp.body == 'not found') {
            isLoading_join = false;
            mes_join = 'コードが見つかりませんでした';
          } else {
            isLoading_join = false;
            mes_join = 'エラーが発生しました';
          }
          notifyListeners();
        });
      }
    }
  }

  Future<void> createRequest() async {
    String grade = '';
    switch (dropdown_text) {
      case 'ビーバー隊':
        grade = 'beaver';
        break;
      case 'カブ隊':
        grade = 'cub';
        break;
      case 'ボーイ隊':
        grade = 'boy';
        break;
      case 'ベンチャー隊':
        grade = 'venture';
        break;
    }
    if (isConsent! && joinCode != '' && grade != '') {
      isLoading_join = true;
      notifyListeners();

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.getIdTokenResult().then((IdTokenResult token) async {
          const String url =
              'https://asia-northeast1-cubook-3c960.cloudfunctions.net/createGroup';
          final Map<String, String> headers = {
            'content-type': 'application/json'
          };
          final String body = json.encode({
            'idToken': token.token,
            'groupName': groupController.text,
            'family': familyController.text,
            'first': firstController.text,
            'grade': grade
          });

          final http.Response resp =
              await http.post(Uri.parse(url), headers: headers, body: body);
          isLoading_join = false;
          if (resp.body == 'success') {
            mes_join = '';
            Timer _timer;
          } else if (resp.body == 'No such document!' ||
              resp.body == 'not found') {
            isLoading_join = false;
            mes_join = 'コードが見つかりませんでした';
          } else {
            isLoading_join = false;
            mes_join = 'エラーが発生しました';
          }
          notifyListeners();
        });
      }
    }
  }

  // void joinRequest() async {
  //   if (isConsent && joinCode != '') {
  //     isLoading_join = true;
  //     notifyListeners();
  //
  //     User user = await FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       user.getIdTokenResult().then((token) async {
  //         HttpsCallable callable = FirebaseFunctions.instanceFor(
  //             region: 'asia-northeast1')
  //             .httpsCallable('joinGroupCall',
  //             options: HttpsCallableOptions(timeout: Duration(seconds: 5)));
  //
  //         await callable(<String, String>{
  //           'idToken': token.token,
  //           'joinCode': joinCode
  //         }).then((v) {
  //           mes_join = '';
  //         }).catchError((dynamic e) {
  //           mes_join = 'エラーが発生しました';
  //         });
  //         isLoading_join = false;
  //         notifyListeners();
  //       });
  //     }
  //   }
  // }
  //
  // void createRequest() async {
  //   String grade = '';
  //   switch (dropdown_text) {
  //     case 'ビーバー隊':
  //       grade = 'beaver';
  //       break;
  //     case 'カブ隊':
  //       grade = 'cub';
  //       break;
  //     case 'ボーイ隊':
  //       grade = 'boy';
  //       break;
  //     case 'ベンチャー隊':
  //       grade = 'venture';
  //       break;
  //   }
  //   if (isConsent && joinCode != '' && grade != '') {
  //     isLoading_join = true;
  //     notifyListeners();
  //
  //     User user = await FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       user.getIdTokenResult().then((token) async {
  //         HttpsCallable callable = FirebaseFunctions.instanceFor(
  //             region: 'asia-northeast1')
  //             .httpsCallable('createGroupCall',
  //             options: HttpsCallableOptions(timeout: Duration(seconds: 5)));
  //
  //         await callable(<String, String>{
  //           'idToken': token.token,
  //           'groupName': groupController.text,
  //           'family': familyController.text,
  //           'first': firstController.text,
  //           'grade': grade
  //         }).then((v) {
  //           mes_join = '';
  //         }).catchError((dynamic e) {
  //           mes_join = 'エラーが発生しました';
  //         });
  //         isLoading_join = false;
  //         notifyListeners();
  //       });
  //     }
  //   }
  // }

  void clickPublicButton(int index) {
    if (isSelect_type[0] == false && isSelect_type[1] == false) {
      isSelect_type[index] = true;
    } else if (isSelect_type[index] == false && isSelect_type[1] != false) {
      isSelect_type[0] = true;
      isSelect_type[1] = false;
    } else if (isSelect_type[index] == false && isSelect_type[0] != false) {
      isSelect_type[1] = true;
      isSelect_type[0] = false;
    }
    notifyListeners();
  }

  void onDropdownChanged(String? value) {
    dropdown_text = value;
    notifyListeners();
  }

  Future<void> launchTermURL() async {
    const String url =
        'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onPressedCheckConsent(bool? e) {
    isConsent = e;
    notifyListeners();
  }
}
