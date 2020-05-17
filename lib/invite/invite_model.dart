import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    switch (dropdown_text) {
      case 'うさぎ':
        age = 'usagi';
        position = 'scout';
        break;
      case 'しか':
        age = 'sika';
        position = 'scout';
        break;
      case 'くま':
        age = 'kuma';
        position = 'scout';
        break;
      case 'リーダー':
        age = 'leader';
        position = 'leader';
        dropdown_call = 'さん';
        break;
    }
    if(addressController != '' && familyController.text != '' && firstController.text != '' && dropdown_text != null && dropdown_call != null) {
      isLoading_join = true;
      notifyListeners();
      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) {
          user.getIdToken().then((token) async {
            print(token.claims);
            String url =
                "https://asia-northeast1-cubook-3c960.cloudfunctions.net/inviteGroup";
            Map<String, String> headers = {
              'content-type': 'application/json'
            };
            String body =
            json.encode({
              'idToken': token.token,
              'address': addressController.text,
              'family': familyController.text,
              'first': firstController.text,
              'call': dropdown_call,
              'age': age,
              'position': position
            });

            http.Response resp =
            await http.post(url, headers: headers, body: body);
            print(resp.body);
            print(token.claims);
            isLoading_join = false;
            if (resp.body == 'success') {
              mes_join = '';
              addressController.clear();
              familyController.clear();
              firstController.clear();
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text('送信リクエストが完了しました'),
              ));
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
      });
    } else {
      notifyListeners();
    }
  }

}