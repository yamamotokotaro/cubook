import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class InviteModel with ChangeNotifier {
  var isSelect_type = new List.generate(2, (index) => false);
  bool isLoading_join = false;
  bool isConsent = false;
  String joinCode = '';
  String mes_join = '';
  String dropdown_text;
  String dropdown_call;

  TextEditingController addressController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController teamController = TextEditingController();

  void onDropdownChanged(String value) {
    dropdown_text = value;
    notifyListeners();
  }

  void onDropdownCallChanged(String value) {
    dropdown_call = value;
    notifyListeners();
  }

  void inviteRequest(BuildContext context) async {
    String age;
    String position;
    String team;
    switch (dropdown_text) {
      case 'りす':
        age = 'risu';
        position = 'scout';
        team = teamController.text;
        break;
      case 'うさぎ':
        age = 'usagi';
        position = 'scout';
        team = teamController.text;
        break;
      case 'しか':
        age = 'sika';
        position = 'scout';
        team = teamController.text;
        break;
      case 'くま':
        age = 'kuma';
        position = 'scout';
        team = teamController.text;
        break;
      case 'ボーイスカウトバッジ':
        age = 'syokyu';
        position = 'scout';
        team = teamController.text;
        break;
      case '初級スカウト':
        age = 'nikyu';
        position = 'scout';
        team = teamController.text;
        break;
      case '2級スカウト':
        age = 'ikkyu';
        position = 'scout';
        team = teamController.text;
        break;
      case '1級スカウト':
        age = 'kiku';
        position = 'scout';
        team = teamController.text;
        break;
      case '菊スカウト':
        age = 'hayabusa';
        position = 'scout';
        team = teamController.text;
        break;
      case '隼スカウト':
        age = 'fuji';
        position = 'scout';
        team = teamController.text;
        break;
      case 'リーダー':
        age = 'leader';
        position = 'leader';
        dropdown_call = 'さん';
        team = '100';
        break;
    }
    if (addressController != '' &&
        familyController.text != '' &&
        firstController.text != '' &&
        age != '' &&
        dropdown_text != null &&
        dropdown_call != null) {
      isLoading_join = true;
      notifyListeners();
      User user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.getIdToken().then((token) async {
          HttpsCallable callable = FirebaseFunctions.instanceFor(
                  region: 'asia-northeast1')
              .httpsCallable('inviteGroupCall',
                  options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

          await callable(<String, String>{
            'idToken': token,
            'address': addressController.text,
            'family': familyController.text,
            'first': firstController.text,
            'call': dropdown_call,
            'age': age,
            'position': position,
            'team': team
          }).then((v) {
            mes_join = '';
            addressController.clear();
            familyController.clear();
            firstController.clear();
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              content: new Text('送信リクエストが完了しました'),
            ));
          }).catchError((dynamic e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('ERROR: $e'),
            ));
          });
          isLoading_join = false;
          notifyListeners();
        });
      }
    } else {
      notifyListeners();
    }
  }
}
