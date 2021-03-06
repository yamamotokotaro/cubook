import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SignupModel with ChangeNotifier {
  List<bool> isSelect_type = [false, false];
  bool isLoading_join = false;
  bool isConsent = false;
  String joinCode = '';
  String mes_join = '';
  String dropdown_text;

  TextEditingController groupController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController firstController = TextEditingController();

  void joinRequest() async {
    if (isConsent && joinCode != '') {
      isLoading_join = true;
      notifyListeners();

      User user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.getIdTokenResult().then((token) async {
          String url =
              "https://asia-northeast1-cubook-3c960.cloudfunctions.net/joinGroup";
          Map<String, String> headers = {'content-type': 'application/json'};
          String body =
              json.encode({'idToken': token.token, 'joinCode': joinCode});

          http.Response resp =
              await http.post(url, headers: headers, body: body);
          Map<dynamic, dynamic> tokenMap = token.claims;
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

  void createRequest() async {
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
    if (isConsent && joinCode != '' && grade != '') {
      isLoading_join = true;
      notifyListeners();

      User user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.getIdTokenResult().then((token) async {
          print(token.claims);
          String url =
              "https://asia-northeast1-cubook-3c960.cloudfunctions.net/createGroup";
          Map<String, String> headers = {'content-type': 'application/json'};
          String body = json.encode({
            'idToken': token.token,
            'groupName': groupController.text,
            'family': familyController.text,
            'first': firstController.text,
            'grade': grade
          });

          http.Response resp =
              await http.post(url, headers: headers, body: body);
          print(resp.body);
          print(token.claims);
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

  void onDropdownChanged(String value) {
    dropdown_text = value;
    notifyListeners();
  }

  void launchTermURL() async {
    const url =
        'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onPressedCheckConsent(bool e) {
    isConsent = e;
    notifyListeners();
  }
}
