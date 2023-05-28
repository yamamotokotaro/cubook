import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/checkScoutTaskDetail/taskDetailScoutConfirm_view.dart';
import 'package:cubook/checkScoutTaskList/taskListScoutConfirm_view.dart';
import 'package:cubook/userDetail/userDetail_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabInfo {
  TabInfo(this.label, this.widget);
  String label;
  Widget widget;
}

class SelectBook extends StatelessWidget {
  SelectBook(String? uid) {
    this.uid = uid;
  }
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  String? uid;

  @override
  Widget build(BuildContext context) {
    final List<String> type = theme.type;
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Consumer<UserDetailModel>(builder:
            (BuildContext context, UserDetailModel model, Widget? child) {
          if (model.userSnapshot == null) {
            model.getSnapshot(uid);
          } else if (model.userSnapshot!.get('uid') != uid) {
            model.getSnapshot(uid);
            model.userSnapshot = null;
          }
          return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: type.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.all(5),
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
                                if (task.getAllMap(type[index])!.length != 1) {
                                  Navigator.push(context, MaterialPageRoute<
                                          TaskListScoutConfirmView>(
                                      builder: (BuildContext context) {
                                    return TaskListScoutConfirmView(
                                        type[index], uid);
                                  }));
                                } else {
                                  Navigator.of(context).push<dynamic>(
                                      MyPageRoute(
                                          page: showTaskConfirmView(
                                              0, type[index], uid, 0),
                                          dismissible: true));
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 15,
                                          left: 12,
                                          right: 10),
                                      child: Selector<UserDetailModel,
                                              DocumentSnapshot?>(
                                          selector: (BuildContext context,
                                                  UserDetailModel model) =>
                                              model.userSnapshot,
                                          builder: (BuildContext context,
                                                  DocumentSnapshot<Object?>?
                                                      snapshot,
                                                  Widget? child) =>
                                              snapshot != null
                                                  ? model.userData![type[index]] !=
                                                          null
                                                      ? CircularProgressIndicator(
                                                          backgroundColor: theme
                                                              .getIndicatorColor(type[index]),
                                                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                                          value: model.userData![type[index]].length / task.getAllMap(type[index])!.length)
                                                      : CircularProgressIndicator(backgroundColor: theme.getIndicatorColor(type[index]), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), value: 0)
                                                  : CircularProgressIndicator(
                                                      backgroundColor: theme
                                                          .getIndicatorColor(
                                                              type[index]),
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ))),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    theme
                                                        .getTitle(type[index])!,
                                                    style: const TextStyle(
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
    ));
  }
}
