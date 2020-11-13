import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_model.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class showTaskConfirmView extends StatelessWidget {
  var task = new Task();
  int currentPage = 0;
  int page;
  int number;
  String type;
  String typeFirestore;
  String uid;
  bool test = false;
  List<Widget> pages = <Widget>[
    /*StepSignView(),*/
//    StepAddView()
  ];

  showTaskConfirmView(int page, String _type, String _uid, int number) {
    this.page = page;
    this.number = number;
    type = _type;
    uid = _uid;
    pages.add(
      TaskScoutDetailConfirmView(type, page),
    );
    for (int i = 0; i < task.getPartMap(type, page)['hasItem']; i++) {
      pages.add(TaskScoutAddConfirmView(type, page, i));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double setHeight;
    double setFraction;
    if (height > 700.0) {
      setHeight = height - 200;
    } else {
      setHeight = height - 90;
    }
    if (width > 1000.0) {
      setFraction = 0.6;
    } else {
      setFraction = 0.8;
    }
    PageController controller =
        PageController(initialPage: number, viewportFraction: setFraction);

    return ChangeNotifierProvider(
        create: (context) => TaskDetailScoutConfirmModel(page,
            task.getPartMap(type, page)['hasItem'], type, uid, controller),
        child: Container(
            height: setHeight,
            child: PageView(
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
              },
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: pages,
            )));
  }
}

Future<void> signItem(String uid, String type, int page, int number,
    String feedback, bool checkCitation, bool isCommon) async {
  var task = new Task();
  String documentID;
  int count = 0;

  User user = await FirebaseAuth.instance.currentUser;
  Map<String, dynamic> data_signed = Map<String, dynamic>();
  FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: user.uid)
      .get()
      .then((data) async {
    Map<String, dynamic> userInfo = data.docs[0].data();
    FirebaseFirestore.instance
        .collection(type)
        .where('group', isEqualTo: userInfo['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .get()
        .then((data) async {
      if (data.docs.length != 0) {
        DocumentSnapshot snapshot = data.docs[0];
        Map<String, dynamic> map = Map<String, dynamic>();
        Map<String, dynamic> data_toAdd = Map<String, dynamic>();
        map = snapshot.data()['signed'];
        if (map[number.toString()] == null) {
          data_toAdd['phaze'] = 'signed';
          data_toAdd['family'] = userInfo['family'];
          data_toAdd['uid'] = uid;
          data_toAdd['feedback'] = feedback;
          data_toAdd['time'] = Timestamp.now();
          map[number.toString()] = data_toAdd;
        } else {
          map[number.toString()]['phaze'] = 'signed';
          map[number.toString()]['family'] = userInfo['family'];
          map[number.toString()]['uid'] = uid;
          map[number.toString()]['feedback'] = feedback;
          map[number.toString()]['time'] = Timestamp.now();
        }
        data_signed['signed'] = map;
        map.forEach((key, dynamic values) {
          Map<String, dynamic> partData = map[key.toString()];
          if (partData['phaze'] == 'signed') {
            count++;
          }
        });
        Map<String, dynamic> taskInfo = new Map<String, dynamic>();
        taskInfo = task.getPartMap(type, page);
        if (count == taskInfo['hasItem']) {
          data_signed['end'] = Timestamp.now();
          data_signed['isCitationed'] = checkCitation;
          if (type == 'gino') {
            if (taskInfo['examination']) {
              data_signed['phase'] = 'not examined';
            } else {
              data_signed['phase'] = 'complete';
            }
          }
        }
        FirebaseFirestore.instance
            .collection(type)
            .doc(snapshot.id)
            .update(data_signed);
      } else {
        Map<String, dynamic> data_toAdd = Map<String, dynamic>();
        data_toAdd['phaze'] = 'signed';
        data_toAdd['family'] = userInfo['family'];
        data_toAdd['uid'] = userInfo['uid'];
        data_toAdd['feedback'] = feedback;
        data_toAdd['time'] = Timestamp.now();
        data_signed['page'] = page;
        data_signed['uid'] = uid;
        data_signed['start'] = Timestamp.now();
        data_signed['signed'] = {number.toString(): data_toAdd};
        data_signed['group'] = userInfo['group'];
        count = 1;
        Map<String, dynamic> taskInfo = new Map<String, dynamic>();
        taskInfo = task.getPartMap(type, page);
        if (count == taskInfo['hasItem']) {
          data_signed['end'] = Timestamp.now();
          data_signed['isCitationed'] = checkCitation;
          if (type == 'gino') {
            if (taskInfo['examination']) {
              data_signed['phase'] = 'not examined';
            } else {
              data_signed['phase'] = 'complete';
            }
          }
        }
        DocumentReference documentReference_add =
            await FirebaseFirestore.instance.collection(type).add(data_signed);
        documentID = documentReference_add.id;
      }

      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid)
          .where('group', isEqualTo: userInfo['group'])
          .get()
          .then((data) {
        DocumentSnapshot snapshot = data.docs[0];
        Map<String, dynamic> map = Map<String, int>();
        if (snapshot.data()[type] != null) {
          map = snapshot.data()[type];
          map[page.toString()] = count;
        } else {
          map[page.toString()] = count;
        }
        var mapSend = {type: map};
        FirebaseFirestore.instance
            .collection('user')
            .doc(snapshot.id)
            .update(mapSend);

        if (map[page.toString()] == task.getPartMap(type, page)['hasItem'] &&
            !checkCitation) {
          onFinish(uid, type, page, documentID);
          Map<String, dynamic> finishCommon =
              task.getPartMap(type, page)['common'];
          if (finishCommon != null) {
            signItem(uid, finishCommon['type'], finishCommon['page'],
                finishCommon['number'], feedback, false, false);
          }
        }

        Map<String, dynamic> common =
            task.getContent(type, page, number)['common'];
        if (common != null && !isCommon) {
          signItem(uid, common['type'], common['page'], common['number'],
              feedback, false, true);
        }
      });
    });
  });
}

Future<void> cancelItem(
    String uid, String type, int page, int number, bool isCommon) async {
  Map<String, dynamic> data_signed = Map<String, dynamic>();
  var task = new Task();

  User user = await FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: user.uid)
      .get()
      .then((data) async {
    Map<String, dynamic> userInfo = data.docs[0].data();
    FirebaseFirestore.instance
        .collection(type)
        .where('group', isEqualTo: userInfo['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .get()
        .then((data) async {
      if (data.docs.length != 0) {
        int count = 0;
        DocumentSnapshot snapshot = data.docs[0];
        if (snapshot.data()['signed'].length - 1 != 0) {
          Map<String, dynamic> map = Map<String, dynamic>();
          map = snapshot.data()['signed'];
          map.remove(number.toString());
          data_signed['signed'] = map;
          data_signed['end'] = FieldValue.delete();
          map.forEach((key, dynamic values) {
            Map<String, dynamic> partData = map[key.toString()];
            if (partData['phaze'] == 'signed') {
              count++;
            }
          });
          FirebaseFirestore.instance
              .collection(type)
              .doc(snapshot.id)
              .update(data_signed);
        } else {
          count = 0;
          FirebaseFirestore.instance.collection(type).doc(snapshot.id).delete();
        }

        FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: uid)
            .where('group', isEqualTo: userInfo['group'])
            .get()
            .then((data) {
          DocumentSnapshot snapshot = data.docs[0];
          Map<String, dynamic> map = Map<String, int>();
          if (snapshot.data()[type] != null) {
            map = snapshot.data()[type];
            map[page.toString()] = count;
          } else {
            map[page.toString()] = count;
          }
          var mapSend = {type: map};
          FirebaseFirestore.instance
              .collection('user')
              .doc(snapshot.id)
              .update(mapSend);
        });

        Map<String, dynamic> finishCommon =
            task.getPartMap(type, page)['common'];
        if (count + 1 == task.getPartMap(type, page)['hasItem'] &&
            finishCommon != null) {
          cancelItem(uid, finishCommon['type'], finishCommon['page'],
              finishCommon['number'], false);
        }

        Map<String, dynamic> common =
            task.getContent(type, page, number)['common'];
        if (common != null && !isCommon) {
          cancelItem(
              uid, common['type'], common['page'], common['number'], true);
        }
      }
    });
  });
}

Future<void> onFinish(
    String uid, String type, int page, String documentID) async {
  var task = new Task();
  var theme = new ThemeInfo();
  User user = await FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: user.uid)
      .get()
      .then((userData) async {
    Map<String, dynamic> userInfo = userData.docs[0].data();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .where('group', isEqualTo: userInfo['group'])
        .get();
    DocumentSnapshot snapshot = data.docs[0];
    Map<String, dynamic> map = Map<String, dynamic>();
    Map<String, dynamic> taskMap = task.getPartMap(type, page);
    String body = theme.getTitle(type) +
        ' ' +
        taskMap['number'] +
        ' ' +
        taskMap['title'] +
        'を完修！';
    map['family'] = snapshot.data()['family'];
    map['first'] = snapshot.data()['first'];
    map['call'] = snapshot.data()['call'];
    map['uid'] = snapshot.data()['uid'];
    map['congrats'] = 0;
    map['body'] = body;
    map['type'] = type;
    map['group'] = snapshot.data()['group'];
    map['time'] = Timestamp.now();
    map['page'] = page;
    if (snapshot.data()['group'] == ' j27DETWHGYEfpyp2Y292' ||
        snapshot.data()['group'] == ' z4pkBhhgr0fUMN4evr5z') {
      map['taskID'] = documentID;
      map['enable_community'] = true;
    }
    FirebaseFirestore.instance.collection('effort').add(map);
    FirebaseFirestore.instance
        .collection(type)
        .where('uid', isEqualTo: uid)
        .where('group', isEqualTo: userInfo['group'])
        .get();
  });
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).canvasColor, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
