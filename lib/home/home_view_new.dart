import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_view.dart';
import 'package:cubook/home_leader/homeLeader_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeViewNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Selector<HomeModel, String>(
          selector: (context, model) => model.username,
          builder: (context, name, child) => Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              name + '、こんにちは😀',
              style: GoogleFonts.notoSans(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              )),
            ),
          ),
        ),
        Consumer<HomeModel>(builder: (context, model, child) {
          return RaisedButton(child: Text('ログアウト'),onPressed:() {model.logout();});
        }),
        Consumer<HomeModel>(
          builder: (context, model, child) {
            if (model.currentUser == null) {
              model.login();
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return model.toShow;
            }
          },
        ),
        listEffort()
      ],
    );
  }
}
