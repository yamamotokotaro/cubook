import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/Support/Support_model.dart';
import 'package:cubook/invite/invite_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SupportView extends StatelessWidget {
  var list_type = ['red', 'yellow', 'blue', 'green'];
  var list_name = ['赤', '黄色', '青', '緑'];
  var list_color = [Colors.red, Colors.yellow[700], Colors.blue, Colors.green];
  List<int> count_color = new List<int>.generate(4, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('スペシャルコンテンツ'),
        ),
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                  child: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child:
                        Consumer<InviteModel>(builder: (context, model, child) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Material(
                                                    type: MaterialType
                                                        .transparency,
                                                    child: Text(
                                                      '広告を見てコンテンツをみよう！',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    )))),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                top: 7,
                                                bottom: 10,
                                                right: 10),
                                            child: Material(
                                                type: MaterialType.transparency,
                                                child: Text(
                                                  '広告視聴後にお礼としてアプリ内でロープを差し上げます。ロープの色はランダムで決まります。ロープを消費することでスペシャルコンテンツを見ることができます。',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 17,
                                                  ),
                                                ))),
                                      ],
                                    ))),
                          ),
                          Consumer<SupportModel>(
                              builder: (context, model, child) {
                            model.getUser();
                            model.getAdmob(context);
                            return !model.isLoaded
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                        child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 8,
                                      color: Colors.blue[900],
                                      child: InkWell(
                                        onTap: () {
                                          model.videoAd.show();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          '広告を再生',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white),
                                                        ))),
                                              ]),
                                        ),
                                      ),
                                    )),
                                  );
                          }),
                          Selector<SupportModel, String>(
                              selector: (context, model) => model.uid,
                              builder: (context, uid, child) => uid != null
                                  ? StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('user')
                                          .where('uid', isEqualTo: uid)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        DocumentSnapshot userSnapshot =
                                            snapshot.data.documents[0];
                                        return Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Container(
                                                  height: 70,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: list_type.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      int count = 0;
                                                      if (userSnapshot[
                                                              list_type[
                                                                  index]] !=
                                                          null) {
                                                        count = userSnapshot[
                                                            list_type[index]];
                                                      }
                                                      count_color[index] = count;
                                                      return Container(
                                                        height: 70,
                                                        width: 100,
                                                        child: Card(
                                                            color: list_color[
                                                                index],
                                                            child: Center(
                                                                child: Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        SvgPicture
                                                                            .asset(
                                                                          'assets/svg/rope.svg',
                                                                          semanticsLabel:
                                                                              'shopping',
                                                                          color:
                                                                              Colors.white,
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                        ),
                                                                        Text(
                                                                          count
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 20,
                                                                              color: Colors.white),
                                                                        )
                                                                      ],
                                                                    )))),
                                                      );
                                                    },
                                                  ),
                                                )));
                                      })
                                  : Container()),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: list_type.length,
                              shrinkWrap: true,
                              itemBuilder:
                                  (BuildContext context, int index_color) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Center(
                                          child: Text(
                                            list_name[index_color] + 'のコンテンツ',
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        )),
                                    Selector<SupportModel, String>(
                                        selector: (context, model) => model.uid,
                                        builder: (context, uid, child) => uid !=
                                                null
                                            ? StreamBuilder<QuerySnapshot>(
                                                stream: Firestore.instance
                                                    .collection(
                                                        'specialcontents')
                                                    .where('type',
                                                        isEqualTo: list_type[
                                                            index_color])
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                        snapshot_contents) {
                                                  if (snapshot_contents
                                                      .hasData) {
                                                    return StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: Firestore.instance
                                                          .collection(
                                                              'contents_unlocked')
                                                          .where('uid',
                                                              isEqualTo: uid)
                                                          .snapshots(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasData) {
                                                          if (snapshot_contents
                                                                  .data
                                                                  .documents
                                                                  .length !=
                                                              0) {
                                                            List<dynamic>
                                                                unlocked =
                                                                new List<
                                                                    String>();
                                                            if (snapshot
                                                                    .data
                                                                    .documents
                                                                    .length !=
                                                                0) {
                                                              DocumentSnapshot
                                                                  userSnapshot =
                                                                  snapshot.data
                                                                      .documents[0];
                                                              unlocked =
                                                                  userSnapshot[
                                                                      'unlocked'];
                                                              print('kita');
                                                            }
                                                            return ListView
                                                                .builder(
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemCount: snapshot_contents
                                                                        .data
                                                                        .documents
                                                                        .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      DocumentSnapshot
                                                                          snapshot =
                                                                          snapshot_contents
                                                                              .data
                                                                              .documents[index];
                                                                      return Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                                padding: EdgeInsets.all(3),
                                                                                child: Container(
                                                                                  child: Card(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: InkWell(
                                                                                      onTap: () async {
                                                                                        if (unlocked.contains(snapshot.documentID)) {
                                                                                          Navigator.of(context).pushNamed('/contentsView', arguments: snapshot.documentID);
                                                                                        } else {
                                                                                          await showDialog<int>(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                if (count_color[index_color] >= 1) {
                                                                                                  return AlertDialog(
                                                                                                    title: Text(
                                                                                                      "アンロック",
                                                                                                      style: TextStyle(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                      ),
                                                                                                    ),
                                                                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                                                    content: Text(list_name[index_color] + 'のロープを消費してコンテンツをアンロックします'),
                                                                                                    actions: <Widget>[
                                                                                                      // ボタン領域
                                                                                                      FlatButton(
                                                                                                        child: Text("キャンセル"),
                                                                                                        onPressed: () => Navigator.pop(context),
                                                                                                      ),
                                                                                                      Consumer<SupportModel>(builder: (context, model, child) {
                                                                                                        return FlatButton(
                                                                                                          child: Text("OK"),
                                                                                                          onPressed: () {
                                                                                                            model.unlock(list_type[index_color], snapshot.documentID);
                                                                                                            Navigator.pop(context);
                                                                                                            Navigator.of(context).pushNamed('/contentsView', arguments: snapshot.documentID);
                                                                                                          },
                                                                                                        );
                                                                                                      })
                                                                                                    ],
                                                                                                  );
                                                                                                } else {
                                                                                                  return AlertDialog(
                                                                                                    title: Text(
                                                                                                      "ロープの数が足りません",
                                                                                                      style: TextStyle(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                      ),
                                                                                                    ),
                                                                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                                                    content: Text('広告を見て' + list_name[index_color] + 'のロープを獲得するとアンロックすることができます。'),
                                                                                                    actions: <Widget>[
                                                                                                      // ボタン領域
                                                                                                      FlatButton(
                                                                                                        child: Text("OK"),
                                                                                                        onPressed: () => Navigator.pop(context),
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                }
                                                                                              });
                                                                                        }
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(10),
                                                                                        child: Row(
                                                                                          children: <Widget>[
                                                                                            Padding(
                                                                                                padding: EdgeInsets.only(left: 0),
                                                                                                child: Text(
                                                                                                  snapshot['title'],
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                                )),
                                                                                            Spacer(),
                                                                                            unlocked.contains(snapshot.documentID) ? Container() : Icon(Icons.https)
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                          ]);
                                                                    });
                                                          } else {
                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Container(
                                                                  child:
                                                                      InkWell(
                                                                onTap: () {},
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                          Icons
                                                                              .bubble_chart,
                                                                          color:
                                                                              Theme.of(context).accentColor,
                                                                          size:
                                                                              35,
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 10),
                                                                            child: Material(
                                                                              type: MaterialType.transparency,
                                                                              child: Text(
                                                                                'Coming Soon..',
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontSize: 20,
                                                                                ),
                                                                              ),
                                                                            )),
                                                                      ]),
                                                                ),
                                                              )),
                                                            );
                                                          }
                                                        } else {
                                                          return const Center(
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          );
                                                        }
                                                      },
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                })
                                            : Container())
                                  ],
                                );
                              })
                        ],
                      );
                    })),
              )));
        }));
  }
}
