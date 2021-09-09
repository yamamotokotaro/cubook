import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_model.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_view.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_model.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class showTaskView extends StatelessWidget {
  var task = TaskContents();
  int currentPage = 0;
  int numberPushed;
  int initialPage;
  String type;
  String typeFirestore;
  bool test = false;
  List<Widget> pages = <Widget>[
    /*StepSignView(),*/
//    StepAddView()
  ];

  showTaskView(int _number, String _type, int _initialPage) {
    numberPushed = _number;
    type = _type;
    initialPage = _initialPage;
    pages.add(TaskScoutDetailView(type, _number),);
    for (int i = 0; i < task.getPartMap(type, _number)['hasItem']; i++) {
      pages.add(TaskScoutAddView(type, _number, i));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    double setHeight;
    double setFraction;
    if(height > 700.0){
      setHeight = height-200;
    } else {
      setHeight = height-90;
    }
    if(width > 1000.0){
      setFraction = 0.6;
    } else {
      setFraction = 0.8;
    }
    final PageController controller =
    PageController(initialPage: initialPage, viewportFraction: setFraction);

    return ChangeNotifierProvider(
        create: (context) => TaskDetailScoutModel(numberPushed, task.getPartMap(type, numberPushed)['hasItem'], type),
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

class showTaskConfirmView extends StatelessWidget {
  var task = TaskContents();
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
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
    final PageController controller =
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
  final task = TaskContents();
  String documentID;
  int count = 0;

  final User user = FirebaseAuth.instance.currentUser;
  final Map<String, dynamic> dataSigned = <String, dynamic>{};
  FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: user.uid)
      .get()
      .then((data) async {
    final Map<String, dynamic> userInfo = data.docs[0].data();
    FirebaseFirestore.instance
        .collection(type)
        .where('group', isEqualTo: userInfo['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .get()
        .then((data) async {
      if (data.docs.isNotEmpty) {
        final DocumentSnapshot snapshot = data.docs[0];
        Map<String, dynamic> map = <String, dynamic>{};
        final Map<String, dynamic> dataToAdd = <String, dynamic>{};
        map = snapshot.get('signed');
        if (map[number.toString()] == null) {
          dataToAdd['phaze'] = 'signed';
          dataToAdd['family'] = userInfo['family'];
          dataToAdd['uid'] = uid;
          dataToAdd['feedback'] = feedback;
          dataToAdd['time'] = Timestamp.now();
          map[number.toString()] = dataToAdd;
        } else {
          map[number.toString()]['phaze'] = 'signed';
          map[number.toString()]['family'] = userInfo['family'];
          map[number.toString()]['uid'] = uid;
          map[number.toString()]['feedback'] = feedback;
          map[number.toString()]['time'] = Timestamp.now();
        }
        dataSigned['signed'] = map;
        map.forEach((key, dynamic values) {
          final Map<String, dynamic> partData = map[key.toString()];
          if (partData['phaze'] == 'signed') {
            count++;
          }
        });
        Map<String, dynamic> taskInfo = Map<String, dynamic>();
        taskInfo = task.getPartMap(type, page);
        if (count == taskInfo['hasItem']) {
          dataSigned['end'] = Timestamp.now();
          dataSigned['isCitationed'] = checkCitation;
          if (type == 'gino') {
            if (taskInfo['examination']) {
              dataSigned['phase'] = 'not examined';
            } else {
              dataSigned['phase'] = 'complete';
            }
          }
        }
        FirebaseFirestore.instance
            .collection(type)
            .doc(snapshot.id)
            .update(dataSigned);
        documentID = snapshot.id;
      } else {
        final Map<String, dynamic> dataToAdd = <String, dynamic>{};
        dataToAdd['phaze'] = 'signed';
        dataToAdd['family'] = userInfo['family'];
        dataToAdd['uid'] = userInfo['uid'];
        dataToAdd['feedback'] = feedback;
        dataToAdd['time'] = Timestamp.now();
        dataSigned['page'] = page;
        dataSigned['uid'] = uid;
        dataSigned['start'] = Timestamp.now();
        dataSigned['signed'] = {number.toString(): dataToAdd};
        dataSigned['group'] = userInfo['group'];
        count = 1;
        Map<String, dynamic> taskInfo = <String, dynamic>{};
        taskInfo = task.getPartMap(type, page);
        if (count == taskInfo['hasItem']) {
          dataSigned['end'] = Timestamp.now();
          dataSigned['isCitationed'] = checkCitation;
          if (type == 'gino') {
            if (taskInfo['examination']) {
              dataSigned['phase'] = 'not examined';
            } else {
              dataSigned['phase'] = 'complete';
            }
          }
        }
        final DocumentReference documentReferenceAdd =
            await FirebaseFirestore.instance.collection(type).add(dataSigned);
        documentID = documentReferenceAdd.id;
      }

      FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid)
          .where('group', isEqualTo: userInfo['group'])
          .get()
          .then((data) {
        final DocumentSnapshot snapshot = data.docs[0];
        Map<String, dynamic> documentData = snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> map = <String, int>{};
        if (documentData['type'] != null) {
          map = snapshot.get(type);
          map[page.toString()] = count;
        } else {
          map[page.toString()] = count;
        }
        final mapSend = {type: map};
        FirebaseFirestore.instance
            .collection('user')
            .doc(snapshot.id)
            .update(mapSend);

        if (map[page.toString()] == task.getPartMap(type, page)['hasItem']) {
          if (!checkCitation) {
            onFinish(uid, type, page, documentID);
          }
          final Map<String, dynamic> finishCommon =
              task.getPartMap(type, page)['common'];
          if (finishCommon != null) {
            signItem(uid, finishCommon['type'], finishCommon['page'],
                finishCommon['number'], feedback, false, false);
          }
        }

        final Map<String, dynamic> common =
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
  final Map<String, dynamic> dataSigned = <String, dynamic>{};
  final task = TaskContents();

  final User user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: user.uid)
      .get()
      .then((data) async {
    final Map<String, dynamic> userInfo = data.docs[0].data();
    FirebaseFirestore.instance
        .collection(type)
        .where('group', isEqualTo: userInfo['group'])
        .where('uid', isEqualTo: uid)
        .where('page', isEqualTo: page)
        .get()
        .then((data) async {
      if (data.docs.isNotEmpty) {
        int count = 0;
        final DocumentSnapshot snapshot = data.docs[0];
        if (snapshot.get('signed').length - 1 != 0) {
          Map<String, dynamic> map = <String, dynamic>{};
          map = snapshot.get('signed');
          map.remove(number.toString());
          dataSigned['signed'] = map;
          dataSigned['end'] = FieldValue.delete();
          map.forEach((key, dynamic values) {
            final Map<String, dynamic> partData = map[key.toString()];
            if (partData['phaze'] == 'signed') {
              count++;
            }
          });
          FirebaseFirestore.instance
              .collection(type)
              .doc(snapshot.id)
              .update(dataSigned);
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
          final DocumentSnapshot snapshot = data.docs[0];
          Map<String, dynamic> map = <String, int>{};
          if (snapshot.get(type) != null) {
            map = snapshot.get(type);
            map[page.toString()] = count;
          } else {
            map[page.toString()] = count;
          }
          final mapSend = {type: map};
          FirebaseFirestore.instance
              .collection('user')
              .doc(snapshot.id)
              .update(mapSend);
        });

        final Map<String, dynamic> finishCommon =
            task.getPartMap(type, page)['common'];
        if (count + 1 == task.getPartMap(type, page)['hasItem'] &&
            finishCommon != null) {
          cancelItem(uid, finishCommon['type'], finishCommon['page'],
              finishCommon['number'], false);
        }

        final Map<String, dynamic> common =
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
  final task = TaskContents();
  final theme = ThemeInfo();
  final User user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: user.uid)
      .get()
      .then((userData) async {
    final Map<String, dynamic> userInfo = userData.docs[0].data();
    final QuerySnapshot data = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .where('group', isEqualTo: userInfo['group'])
        .get();
    final DocumentSnapshot snapshot = data.docs[0];
    final Map<String, dynamic> map = <String, dynamic>{};
    final Map<String, dynamic> taskMap = task.getPartMap(type, page);
    final String body = theme.getTitle(type) +
        ' ' +
        taskMap['number'] +
        ' ' +
        taskMap['title'] +
        'を完修！';
    map['family'] = snapshot.get('family');
    map['first'] = snapshot.get('first');
    map['call'] = snapshot.get('call');
    map['uid'] = snapshot.get('uid');
    map['congrats'] = 0;
    map['body'] = body;
    map['type'] = type;
    map['group'] = snapshot.get('group');
    map['time'] = Timestamp.now();
    map['page'] = page;
    if (snapshot.get('group') == ' j27DETWHGYEfpyp2Y292' ||
        snapshot.get('group') == ' z4pkBhhgr0fUMN4evr5z') {
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

bool isCub(String type){
  if(type == "usagi" || type == "sika" || type == "kuma" || type == "tukinowa" || type == "challenge"){
    return true;
  } else {
    return false;
  }
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
