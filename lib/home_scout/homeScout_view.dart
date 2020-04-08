import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_list_scout/taskListScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScoutView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();

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
        Consumer<HomeModel>(builder: (context, model, child) {
          return Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 180,
                child: Hero(
                    tag: 'card_step',
                    child: Card(
                      elevation: 8,
                      color: theme.getThemeColor(model.age),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<TaskView>(
                              builder: (BuildContext context) {
                            return TaskView(model.age);
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
                                              theme.getTitle(model.age),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            ),
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.all(20),
                                      child: model.userSnapshot['step'] != null
                                          ? LinearProgressIndicator(
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                              value: model.userSnapshot['step']
                                                      .length /
                                                  task
                                                      .getAllMap('usagi')
                                                      .length)
                                          : Container())
                                ])),
                      ),
                    )),
              ));
        }),
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
                            MaterialPageRoute<TaskView>(builder: (BuildContext context) {
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
                                          snapshot['challenge'] != null
                                              ? LinearProgressIndicator(
                                                  backgroundColor:
                                                      Colors.green[700],
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                  value: snapshot['challenge']
                                                          .length /
                                                      task
                                                          .getAllMap(
                                                              'challenge')
                                                          .length)
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
