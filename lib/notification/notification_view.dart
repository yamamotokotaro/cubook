import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/notification/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お知らせ'),
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
                      child: Consumer<NotificationModel>(
                          builder: (context, model, child) {
                        if (model.uid == null) {
                          model.getUser();
                        }
                        if (model.uid != null) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('notification')
                                .where('uid', isEqualTo: model.uid)
                                .orderBy('time', descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.documents.length != 0) {
                                  QuerySnapshot querySnapshot = snapshot.data;
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: querySnapshot.documents.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DocumentSnapshot snapshot =
                                            querySnapshot.documents[index];
                                        return Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            child: Card(
                                              child: InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 3, bottom: 8),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                              child:Text(
                                                                snapshot[
                                                                    'body'],
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ))),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 3,
                                                                  top: 5),
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                DateFormat(
                                                                        'yyyy/MM/dd hh:mm')
                                                                    .format(snapshot[
                                                                            'time']
                                                                        .toDate())
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                              ))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
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
                                                      'お知らせはまだありません',
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
