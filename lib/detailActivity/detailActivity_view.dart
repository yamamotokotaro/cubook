import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailActivityView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    String documentID = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('記録詳細'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () async {
              var result = await showModalBottomSheet<int>(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Consumer<DetailActivityModel>(
                              builder: (context, model, child) {
                            return ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('記録を削除する'),
                              onTap: () {
                                model.deleteActivity(documentID);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          })
                        ],
                      ));
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Consumer<DetailActivityModel>(
                          builder: (context, model, child) {
                        model.getGroup();
                        if (model.group != null) {
                          return Column(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection('activity_personal')
                                    .where('group', isEqualTo: model.group)
                                    .where('activity', isEqualTo: documentID)
                                    .orderBy('team')
                                    .orderBy('age_turn', descending: true)
                                    .orderBy('name')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.documents.length != 0) {
                                      QuerySnapshot querySnapshot =
                                          snapshot.data;
                                      DocumentSnapshot documentSnapshot =
                                          querySnapshot.documents[0];
                                      String team_last = '';
                                      return Column(children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(17),
                                            child: Container(
                                                width: double.infinity,
                                                child: Text(
                                                  documentSnapshot['title'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 32,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ))),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, bottom: 15, left: 17),
                                            child: Container(
                                                width: double.infinity,
                                                child: Text(
                                                  DateFormat('yyyy年MM月dd日')
                                                      .format(documentSnapshot[
                                                              'date']
                                                          .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ))),
                                        ListView.builder(
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            itemCount:
                                            querySnapshot.documents.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              String uid;
                                              DocumentSnapshot snapshot =
                                              querySnapshot.documents[index];
                                              uid = snapshot['uid'];
                                              bool isCheck = true;
                                              if (model.uid_check[uid] != null) {
                                                isCheck = model.uid_check[uid];
                                              }
                                              String team = '';
                                              if(snapshot['team'] != null) {
                                                if (snapshot['team'] is int) {
                                                  team = snapshot['team']
                                                      .toString();
                                                } else {
                                                  team = snapshot['team'];
                                                }
                                              } else {
                                                team = 'null';
                                              }
                                              bool isFirst;
                                              if (team_last != team) {
                                                isFirst = true;
                                                team_last = team;
                                              } else {
                                                isFirst = false;
                                              }
                                              String grade = snapshot['grade'];
                                              String team_call;
                                              if(grade == 'cub'){
                                                team_call = '組';
                                              } else {
                                                team_call = '班';
                                              }
                                              print(model.uid_check);
                                              return Column(children: <Widget>[
                                                isFirst && team != ''
                                                    ? Padding(
                                                    padding:
                                                    EdgeInsets.all(10),
                                                    child: Container(
                                                        width:
                                                        double.infinity,
                                                        child: Text(
                                                          team +
                                                              team_call,
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 23,
                                                          ),
                                                          textAlign:
                                                          TextAlign.left,
                                                        )))
                                                    : Container(),
                                                Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Container(
                                                      child: Card(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () {
                                                          },
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                10),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color: theme.getUserColor(
                                                                          snapshot[
                                                                          'age']),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: Icon(
                                                                    Icons.person,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        left:
                                                                        10),
                                                                    child: Text(
                                                                      snapshot[
                                                                      'name'],
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                          25),
                                                                    )),
                                                                Spacer(),
                                                                Checkbox(
                                                                  value: isCheck,
                                                                  onChanged:
                                                                      (bool e) {
                                                                  },
                                                                  activeColor:
                                                                  Colors.blue[
                                                                  600],
                                                                )
                                                                /*Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                snapshot['team']
                                                                        .toString() +
                                                                    '組',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                              ))*/
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ]);
                                            })
                                      ]);
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return const Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: CircularProgressIndicator()),
                          );
                        }
                      }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
