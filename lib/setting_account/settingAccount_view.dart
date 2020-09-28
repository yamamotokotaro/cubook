import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/notification/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingAccountView extends StatelessWidget {
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
                                .collection('user')
                                .where('group', isEqualTo: model.group)
                                .where('uid', isEqualTo: model.uid)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                DocumentSnapshot userSnapshot =
                                    snapshot.data.documents[0];
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 16, bottom: 10),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            color: theme.getUserColor(
                                                userSnapshot.data()['age']),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          userSnapshot.data()['name'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        )),
                                  ],
                                );
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
