import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/challenge/challenge_view.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/step/step_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/providers.dart';

class Home extends StatelessWidget {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final challengeColor = const Color(0xFF1B5E20);

  var list_title = ['山本くんが国際章を完修！', '田中さんがしか完修！'];

  var list_color = [Colors.green[900], Colors.green];

  var list_count = [3, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Selector<HomeModel, DocumentSnapshot>(
              selector: (context, model) => model.userSnapshot,
              builder: (context, snapshot, child) =>
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      snapshot['family'] +
                          snapshot['name'] +
                          snapshot['call'] +
                          '、こんにちは😀',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
            ),
            Padding(
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
            ),
            Center(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5, top: 4),
                        child: Icon(
                          //ああああ
                          Icons.book,
                          color: Theme
                              .of(context)
                              .accentColor,
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
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return StepView();
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
                                      child: LinearProgressIndicator(
                                          backgroundColor: Colors.orangeAccent,
                                          valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                          value: 0.6)),
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
                        color: challengeColor,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ChallengeView();
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
                                      child: LinearProgressIndicator(
                                          backgroundColor: Color(0xFF388E3C),
                                          valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                          value: 0.4)),
                                ]),
                          ),
                        ),
                      ),
                    ))),
            Center(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5, top: 4),
                        child: Icon(
                          //ああああ
                          Icons.assignment,
                          color: Theme
                              .of(context)
                              .accentColor,
                          size: 32,
                        ),
                      ),
                      Text(
                        'みんなの取り組み',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none),
                      ),
                    ])),
            Consumer<HomeModel>(builder: (context, model, child) {
              if (!model.isGet) {
                model.getSnapshot();
              }
              List<DocumentSnapshot> listSnapshot = model.effortSnapshot
                  .documents;

              return Padding(
                padding: EdgeInsets.all(0),
                child: ListView.builder(
                    itemCount: listSnapshot.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot documentSnapshot = listSnapshot[index];
                      String body = documentSnapshot['family'] +
                          documentSnapshot['call'] + documentSnapshot['body'];
                      int congrats = documentSnapshot['congrats'];
                      String documentID = documentSnapshot.documentID;
                      Color color;
                      if (documentSnapshot['type'] == 'usagi') {
                        color = Colors.orange;
                      } else if (documentSnapshot['type'] == 'sika') {
                        color = Colors.green;
                      } else if (documentSnapshot['type'] == 'kuma') {
                        color = Colors.blue;
                      } else if (documentSnapshot['type'] == 'challenge') {
                        color = Colors.green[900];
                      }
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: 220,
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 120,
                                  color: color,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    body,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                                FlatButton.icon(
                                    onPressed: () {
                                      model.increaseCount(documentID);
                                    },
                                    icon: Icon(Icons.favorite_border),
                                    label: Text('おめでとう！' +
                                        congrats.toString()))
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            })
          ],
        ))));
  }

  void logout() async {
    await auth.signOut();
    // ...
  }
}
