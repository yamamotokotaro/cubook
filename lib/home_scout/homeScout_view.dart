import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/step/step_view.dart';
import 'package:cubook/task/task.dart';
import 'package:cubook/task_list_scout/taskListScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScoutView extends StatelessWidget {

  var task = new Task();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        /*Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Card(
              child: FlatButton(
                onPressed: () {
                  logout();
                },
                child: Text('ログアウト'),
              ),
            ),
          ),
        ),*/
        Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5, top: 4),
                child: Icon(
                  Icons.book,
                  color: Theme.of(context).accentColor,
                  size: 32,
                ),
              ),
              Text(
                'やってみよう！',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ])),
        Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 180,
              child: Hero(
                  tag: 'card_step',
                  child: Card(
                    elevation: 8,
                    color: Colors.orange,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return TaskView('usagi');
                        }));
                      },
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 13),
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          'うさぎのカブブック',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                      ))),
                              Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Selector<HomeModel, DocumentSnapshot>(
                                      selector: (context, model) =>
                                          model.userSnapshot,
                                      builder: (context, snapshot, child) =>
                                          snapshot != null
                                              ? LinearProgressIndicator(
                                                  backgroundColor:
                                                      Colors.orangeAccent,
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                  value: snapshot['step']
                                                          .length /
                                                      task.getAllMap('usagi').length)
                                              : Container()))
                            ]),
                      ),
                    ),
                  )),
            )),
        Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                height: 180,
                child: Hero(
                  tag: 'card_challenge',
                  child: Card(
                    elevation: 8,
                    color: Colors.green[900],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return TaskView('challenge');
                        }));
                      },
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 13),
                                    child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          'チャレンジ章',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 30,
                                              color: Colors.white),
                                        )),
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Selector<HomeModel, DocumentSnapshot>(
                                      selector: (context, model) =>
                                      model.userSnapshot,
                                      builder: (context, snapshot, child) =>
                                      snapshot != null
                                          ? LinearProgressIndicator(
                                          backgroundColor:
                                          Colors.green[700],
                                          valueColor:
                                          new AlwaysStoppedAnimation<
                                              Color>(Colors.white),
                                          value: snapshot['challenge']
                                              .length /
                                              task.getAllMap('challenge').length)
                                          : Container())),
                            ]),
                      ),
                    ),
                  ),
                ))),
      ],
    )));
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
