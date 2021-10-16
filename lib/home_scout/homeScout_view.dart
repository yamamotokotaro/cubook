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
import 'package:provider/provider.dart';

class HomeScoutView extends StatelessWidget {
  var task = TaskContents();
  var theme = ThemeInfo();
  // Future<PermissionStatus> permissionStatus =
  // NotificationPermissions.getNotificationPermissionStatus();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Selector<HomeModel, DocumentSnapshot>(
          selector: (context, model) => model.userSnapshot,
          builder: (context, userSnapshot, child) {
            DateTime timeChecked;
            Map<String, dynamic> userData;
            userData = userSnapshot.data() as Map<String, dynamic>;
            if (userData['time_notificationChecked'] != null) {
              timeChecked =
                  userSnapshot.get('time_notificationChecked').toDate();
            }
            return StreamBuilder<QuerySnapshot>(
                stream: timeChecked != null
                    ? FirebaseFirestore.instance
                    .collection('notification')
                    .where('uid', isEqualTo: userSnapshot.get('uid'))
                    .where('time', isGreaterThan: timeChecked)
                    .snapshots()
                    : FirebaseFirestore.instance
                    .collection('notification')
                    .where('uid', isEqualTo: userSnapshot.get('uid'))
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final int snapshotLength = snapshot.data.docs.length;
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
                                        color: Theme.of(context).colorScheme.secondary,
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
                            color: Theme.of(context).colorScheme.secondary,
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
                      color: Theme.of(context).colorScheme.secondary,
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
          final List<String> type = List<String>();
          final String age = model.age;
          final String grade = model.grade;
          type.add(age);
          if (age != 'risu' && model.grade == 'cub') {
            type.add('challenge');
          }
          if (grade == 'boy' || grade == 'venture') {
            type.add('gino');
            type.add('syorei');
          }
          if (age == 'kuma') {
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
                                if (task
                                    .getAllMap(type[index])
                                    .length != 1) {
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
                                          builder: (context, snapshot, child) {
                                            final stepData = snapshot.data() as Map<String, dynamic>;
                                          return snapshot !=
                                              null
                                              ? stepData[type[index]] !=
                                              null
                                              ? CircularProgressIndicator(
                                              backgroundColor: theme
                                                  .getIndicatorColor(
                                                  type[index]),
                                              valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                                  Colors.white),
                                              value: snapshot
                                                  .get(type[index]).length /
                                                  task
                                                      .getAllMap(
                                                      type[index])
                                                      .length)
                                              : CircularProgressIndicator(
                                              backgroundColor: theme
                                                  .getIndicatorColor(
                                                  type[index]),
                                              valueColor: AlwaysStoppedAnimation<
                                                  Color>(Colors.white),
                                              value: 0)
                                              : CircularProgressIndicator(
                                            backgroundColor:
                                            theme.getIndicatorColor(
                                                type[index]),
                                            valueColor:
                                            AlwaysStoppedAnimation<
                                                Color>(Colors.white),
                                          );})),
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
      ],
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
