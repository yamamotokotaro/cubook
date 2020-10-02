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

  var type = [
//    'beaver',
    'usagi',
    'sika',
    'kuma',
    'challenge',
    /*'syokyu',
    'nikyu',
    'ikkyu',
    'kiku',
    'hayabusa',
    'fuji',
    'gino'*/
  ];

  SelectBook(String uid) {
    this.uid = uid;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Consumer<UserDetailModel>(builder: (context, model, child) {if (model.userSnapshot == null) {
          model.getSnapshot(uid);
        } else if (model.userSnapshot.data()['uid'] != uid) {
          model.getSnapshot(uid);
          model.userSnapshot = null;
        }
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: type.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 180,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        color: theme.getThemeColor(type[index]),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute<TaskView>(
                                builder: (BuildContext context) {
                              return TaskListScoutConfirmView(type[index], uid);
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
                                              theme.getTitle(type[index]),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            )),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Selector<UserDetailModel,
                                              DocumentSnapshot>(
                                          selector: (context, model) =>
                                              model.userSnapshot,
                                          builder: (context, snapshot, child) => snapshot !=
                                                  null
                                              ? snapshot.data()[type[index]] != null
                                                  ? LinearProgressIndicator(
                                                      backgroundColor: theme
                                                          .getIndicatorColor(
                                                              type[index]),
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<Color>(
                                                              Colors.white),
                                                      value: snapshot.data()[type[index]]
                                                              .length/
                                                          task
                                                              .getAllMap(
                                                                  type[index])
                                                              .length)
                                                  : Container()
                                              : LinearProgressIndicator(
                                                  backgroundColor:
                                                      theme.getIndicatorColor(
                                                          type[index]),
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ))),
                                ]),
                          ),
                        ),
                      ),
                    ));
              });
        }),
      ],
    ));
  }
}
