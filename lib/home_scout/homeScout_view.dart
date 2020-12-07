import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/invite/invite_view.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/notification/notification_view.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_view.dart';
import 'package:cubook/task_list_scout/taskListScout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';

class HomeScoutView extends StatelessWidget {
  var task = new TaskContents();
  var theme = new ThemeInfo();
  Future<PermissionStatus> permissionStatus =
  NotificationPermissions.getNotificationPermissionStatus();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Selector<HomeModel, DocumentSnapshot>(
          selector: (context, model) => model.userSnapshot,
          builder: (context, userSnapshot, child) {
            DateTime timeChecked;
            if (userSnapshot.data()['time_notificationChecked'] != null) {
              timeChecked =
                  userSnapshot.data()['time_notificationChecked'].toDate();
            }
            return StreamBuilder<QuerySnapshot>(
                stream: timeChecked != null
                    ? FirebaseFirestore.instance
                    .collection('notification')
                    .where('uid', isEqualTo: userSnapshot.data()['uid'])
                    .where('time', isGreaterThan: timeChecked)
                    .snapshots()
                    : FirebaseFirestore.instance
                    .collection('notification')
                    .where('uid', isEqualTo: userSnapshot.data()['uid'])
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    int snapshotLength = snapshot.data.docs.length;
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 5, left: 10, right: 10, bottom: 5),
                      child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute<InviteView>(
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
                                        color: Theme.of(context).accentColor,
                                        size: 35,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: Text(
                                              snapshotLength != 0
                                                  ? 'お知らせ ' +
                                                  snapshotLength.toString() +
                                                  '件'
                                                  : 'お知らせ',
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
                    );
                  } else {
                    return Center(
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator()),
                    );
                  }
                });
          },
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
          List<String> type = new List<String>();
          String age = model.age;
          String grade = model.grade;
          type.add(age);
          if(age != 'risu' && model.grade == 'cub'){
            type.add('challenge');
          }
          if(grade == 'boy' || grade =='venture'){
            type.add('gino');
            type.add('syorei');
          }
          if(age == 'kuma'){
            type.add('tukinowa');
          }
          return Padding(
              padding: EdgeInsets.only(top: 20),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: type.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: Card(
                          color: theme.getThemeColor(type[index]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onTap: () {
                                if (task.getAllMap(type[index]).length != 1) {
                                  Navigator.push(context,
                                      MaterialPageRoute<TaskListScoutView>(
                                          builder: (BuildContext context) {
                                            return TaskListScoutView(
                                                type[index]);
                                          }));
                                } else {
                                  Navigator.of(context).push<dynamic>(
                                      MyPageRoute(
                                          page: showTaskView(
                                              0, type[index], 0),
                                          dismissible: true));
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 15,
                                          bottom: 15,
                                          left: 12,
                                          right: 10),
                                      child: Selector<HomeModel,
                                          DocumentSnapshot>(
                                          selector: (context, model) =>
                                          model.userSnapshot,
                                          builder: (context, snapshot, child) => snapshot !=
                                              null
                                              ? snapshot.data()[type[index]] !=
                                              null
                                              ? CircularProgressIndicator(
                                              backgroundColor: theme.getIndicatorColor(
                                                  type[index]),
                                              valueColor: new AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                              value: snapshot.data()[type[index]].length /
                                                  task
                                                      .getAllMap(
                                                      type[index])
                                                      .length)
                                              : CircularProgressIndicator(
                                              backgroundColor: theme.getIndicatorColor(type[index]),
                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                              value: 0)
                                              : CircularProgressIndicator(
                                            backgroundColor:
                                            theme.getIndicatorColor(
                                                type[index]),
                                            valueColor:
                                            new AlwaysStoppedAnimation<
                                                Color>(Colors.white),
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Align(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    theme.getTitle(type[index]),
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        color: Colors.white),
                                                  ))),
                                        ],
                                      )),
                                ],
                              )),
                        ));
                  }));
        }),
        /*Consumer<HomeModel>(builder: (context, model, child) {
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
                ))),*/
      ],
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
