import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/invite/invite_view.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/notification/notification_view.dart';
import 'package:cubook/task_list_scout/taskListScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';

class HomeScoutView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();
  Future<PermissionStatus> permissionStatus =
  NotificationPermissions.getNotificationPermissionStatus();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /*Consumer<HomeModel>(builder: (context, model, child) {
          if (model.permission == 'unknown') {
            return Padding(
              padding:
              EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
              child: Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.notifications,
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      size: 28,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Text(
                                            '通知の設定',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 23,
                                            ),
                                          ),
                                        )),
                                  ]),
                              Padding(
                                  padding: EdgeInsets.only(left: 5, top: 10),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      '通知をオンにすることで、cubookからのお知らせ（サイン申請に関するサイン・やり直しのお知らせなど）を受け取ることができます',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                        onPressed: () async {
                                          NotificationPermissions
                                              .getNotificationPermissionStatus()
                                              .then((PermissionStatus status) {
                                            model.onStatusChange(status);
                                            *//*switch (status) {
                                              case PermissionStatus.denied:
                                                return permDenied;
                                              case PermissionStatus.granted:
                                                return permGranted;
                                              case PermissionStatus.unknown:
                                                return permUnknown;
                                              default:
                                                return null;
                                            }*//*
                                          });
                                        },
                                        *//*final Future<
                                          PermissionStatus> permissionStatus = await NotificationPermissions
                                          .requestNotificationPermissions();*//*
                                        child: Text('設定する'),
                                      ))),
                            ],
                          )),
                    ),
                  )),
            );
          } else {
            return Container(child: Text('通知は設定済みです'));
          }
        }),*/
        Padding(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
          child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute<InviteView>(
                        builder: (BuildContext context) {
                          return NotificationView();
                        }));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.notifications,
                            color: Theme
                                .of(context)
                                .accentColor,
                            size: 35,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  'お知らせ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 30,
                                  ),
                                ),
                              )),
                        ]),
                  ),
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
          child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/listAbsentScout');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.event,
                            color: Theme
                                .of(context)
                                .accentColor,
                            size: 35,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  '活動記録',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 30),
                                ),
                              )),
                        ]),
                  ),
                ),
              )),
        ),
        /*Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5, top: 4),
                child: Icon(
                  Icons.directions_run,
                  color: Theme.of(context).accentColor,
                  size: 32,
                ),
              ),
              Text(
                'もうすぐ完修！',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ])),
        Consumer<HomeModel>(builder: (context, model, child) {
          return Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {

                  }));
        }),*/
        Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5, top: 4),
                    child: Icon(
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                                      child: model.userSnapshot.data()[model.age] !=
                                          null
                                          ? LinearProgressIndicator(
                                          backgroundColor: theme
                                              .getIndicatorColor(model.age),
                                          valueColor:
                                          new AlwaysStoppedAnimation<
                                              Color>(Colors.white),
                                          value: model
                                              .userSnapshot.data()[model.age]
                                              .length /
                                              task
                                                  .getAllMap(model.age)
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute<TaskView>(
                            builder: (BuildContext context) {
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
                                          ? snapshot.data()['challenge'] != null
                                          ? LinearProgressIndicator(
                                          backgroundColor:
                                          Colors.green[700],
                                          valueColor:
                                          new AlwaysStoppedAnimation<
                                              Color>(
                                              Colors.white),
                                          value: snapshot.data()['challenge']
                                              .length /
                                              task
                                                  .getAllMap(
                                                  'challenge')
                                                  .length)
                                          : Container()
                                          : Container())),
                            ]),
                      ),
                    ),
                  ),
                ))),
        /*Padding(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
          child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/listAbsentScout');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.assignment,
                            color: Theme.of(context).accentColor,
                            size: 35,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  'スカウティングの履歴',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25,
                                  ),
                                ),
                              )),
                        ]),
                  ),
                ),
              )),
        ),*/
      ],
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
