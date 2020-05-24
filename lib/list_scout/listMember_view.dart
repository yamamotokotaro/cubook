import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/select_book/selectBook_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'listMember_model.dart';

class ListScoutView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('確認するスカウトを選択'),
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
                      child: Consumer<ListMemberModel>(
                          builder: (context, model, child) {
                        if (!model.isGet) {
                          model.getSnapshot();
                        }
                        if (model.userSnapshot != null) {
                          if (model.userSnapshot.documents.length != 0) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: model.userSnapshot.documents.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot snapshot =
                                      model.userSnapshot.documents[index];
                                  return Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute<
                                                          SelectBookView>(
                                                      builder: (BuildContext
                                                          context) {
                                                return SelectBookView(
                                                    snapshot['uid']);
                                              }));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            theme.getThemeColor(
                                                                snapshot[
                                                                    'age']),
                                                        shape: BoxShape.circle),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        snapshot['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                                });
                          } else {
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: 5, left: 10, right: 10),
                              child: Container(
                                  child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.bubble_chart,
                                          color: Theme.of(context).accentColor,
                                          size: 35,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: Text(
                                                'スカウトを招待しよう',
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
                          return Center(
                            child: CircularProgressIndicator(),
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

class ListMemberView2 extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('確認するスカウトを選択'),
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
                      child: Consumer<ListMemberModel>(
                          builder: (context, model, child) {
                        model.getGroup();
                        if (model.group != null) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('user')
                                .where('group', isEqualTo: model.group)
                                .where('position', isEqualTo: 'scout')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.documents.length != 0) {
                                  QuerySnapshot querySnapshot = snapshot.data;
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          querySnapshot.documents.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DocumentSnapshot snapshot =
                                           querySnapshot.documents[index];
                                        return Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Container(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute<
                                                                SelectBookView>(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return SelectBookView(
                                                          snapshot['uid']);
                                                    }));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              color: theme
                                                                  .getThemeColor(
                                                                      snapshot[
                                                                          'age']),
                                                              shape: BoxShape
                                                                  .circle),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Text(
                                                              snapshot['name'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ));
                                      });
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10, right: 10),
                                    child: Container(
                                        child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.bubble_chart,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                size: 35,
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Material(
                                                    type: MaterialType
                                                        .transparency,
                                                    child: Text(
                                                      'スカウトを招待しよう',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                      padding: EdgeInsets.all(5),
                                      child: CircularProgressIndicator()),
                                );
                              }
                            },
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
