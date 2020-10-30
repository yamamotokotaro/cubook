import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/userDetail/userDetail_model.dart';
import 'package:cubook/task_list_scout/taskListScout_view.dart';
import 'package:cubook/task_list_scout_confirm/taskListScoutConfirm_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabInfo {
  String label;
  Widget widget;

  TabInfo(this.label, this.widget);
}

class SelectBook extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();
  String uid;

  SelectBook(String uid) {
    this.uid = uid;
  }

  @override
  Widget build(BuildContext context) {
    var type = theme.type;
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Consumer<UserDetailModel>(builder: (context, model, child) {
          if (model.userSnapshot == null) {
            model.getSnapshot(uid);
          } else if (model.userSnapshot.data()['uid'] != uid) {
            model.getSnapshot(uid);
            model.userSnapshot = null;
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
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute<TaskView>(
                                        builder: (BuildContext context) {
                                  return TaskListScoutConfirmView(
                                      type[index], uid);
                                }));
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 15,
                                          bottom: 15,
                                          left: 12,
                                          right: 10),
                                      child: Selector<UserDetailModel,
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
                                                    style:
                                                        TextStyle(fontSize: 23,color: Colors.white),
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
