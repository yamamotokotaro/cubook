import 'package:cubook/Analytics/analytics_model.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_list_analytics/taskListAnalytics_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsView extends StatelessWidget {
  var task = new TaskContents();
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    var type = theme.type;
    return Scaffold(
      appBar: AppBar(
        title: Text('アナリティクス'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Consumer<AnalyticsModel>(builder: (context, model, child) {
                    model.getGroup();
                    if (model.group != null) {
                      if (model.teamPosition != null) {
                        if (model.teamPosition == 'teamLeader') {
                          return Container();
                        } else {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 10, right: 10, bottom: 0),
                                child: Container(
                                    child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onTap: () async {
                                      // final Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions();
                                      Navigator.of(context).pushNamed(
                                          '/listCitationAnalyticsView');
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.menu,
                                              color:
                                                  Theme.of(context).accentColor,
                                              size: 35,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: Text(
                                                    '表彰待ちリスト',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 30),
                                                  ),
                                                )),
                                          ]),
                                    ),
                                  ),
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 10, right: 10, bottom: 0),
                                child: Container(
                                    child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onTap: () async {
                                      // final Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions();
                                      Navigator.of(context).pushNamed(
                                          '/listCitationAnalyticsView');
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.call_made,
                                              color:
                                                  Theme.of(context).accentColor,
                                              size: 35,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: Text(
                                                    'Excel出力',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 30),
                                                  ),
                                                )),
                                          ]),
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          );
                        }
                      } else {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20, left: 10, right: 10, bottom: 0),
                              child: Container(
                                  child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  onTap: () async {
                                    // final Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions();
                                    Navigator.of(context).pushNamed(
                                        '/listCitationAnalyticsView');
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.menu,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: 35,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: Text(
                                                  '表彰待ちリスト',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 30),
                                                ),
                                              )),
                                        ]),
                                  ),
                                ),
                              )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20, left: 10, right: 10, bottom: 0),
                              child: Container(
                                  child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  onTap: () async {
                                    // final Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions();
                                    // model.export();
                                    await showDialog<int>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0))),
                                            content: SingleChildScrollView(
                                                child: Consumer<AnalyticsModel>(
                                                    builder: (context, model,
                                                        child) {
                                              model.export();
                                              if (model.isExporting) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text('エクセルに出力中'),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15,
                                                                bottom: 12),
                                                        child: Container(
                                                            width: 200,
                                                            child:
                                                                LinearProgressIndicator(
                                                              backgroundColor: isDark
                                                                  ? Colors
                                                                      .grey[700]
                                                                  : Colors.grey[
                                                                      300],
                                                              valueColor: new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  isDark
                                                                      ? Colors
                                                                          .white
                                                                      : Colors.blue[
                                                                          900]),
                                                              value: model.count_userAll ==
                                                                      0
                                                                  ? 0
                                                                  : model.count_userProgress /
                                                                      model
                                                                          .count_userAll,
                                                            )))
                                                  ],
                                                );
                                              } else {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text('出力が完了しました'),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20),
                                                        child: FlatButton(
                                                            onPressed: () {
                                                              model.openFile();
                                                            },
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            child: Text(
                                                              'アプリで開く',
                                                              style: TextStyle(
                                                                  color: isDark
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white),
                                                            ))),
                                                    FlatButton(
                                                        onPressed: () {
                                                          model.reExport();
                                                        },
                                                        child: Text('再出力'))
                                                  ],
                                                );
                                              }
                                            })),
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.call_made,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: 35,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: Text(
                                                  'エクセルに出力',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 30),
                                                ),
                                              )),
                                        ]),
                                  ),
                                ),
                              )),
                            ),
                          ],
                        );
                      }
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 0),
                        child: Container(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onTap: () async {
                              // final Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions();
                              Navigator.of(context)
                                  .pushNamed('/listCitationAnalyticsView');
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.menu,
                                      color: Theme.of(context).accentColor,
                                      size: 35,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Text(
                                            '表彰待ちリスト',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 30),
                                          ),
                                        )),
                                  ]),
                            ),
                          ),
                        )),
                      );
                    }
                  }),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5, top: 4),
                                  child: Icon(
                                    Icons.assignment,
                                    color: Theme.of(context).accentColor,
                                    size: 32,
                                  ),
                                ),
                                Text(
                                  '進歩の記録',
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                              ]))),
                  ListView.builder(
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
                                    if (task.getAllMap(type[index]).length !=
                                        1) {
                                      Navigator.push(context, MaterialPageRoute<
                                              TaskListAnalyticsView>(
                                          builder: (BuildContext context) {
                                        return TaskListAnalyticsView(
                                            type[index]);
                                      }));
                                    } else {
                                      Navigator.of(context)
                                          .pushNamed(
                                          '/taskDetailAnalytics',
                                          arguments: TaskDetail(
                                              type: type[index],
                                              page: 0));
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 13),
                                                child: Material(
                                                    type: MaterialType
                                                        .transparency,
                                                    child: Text(
                                                      theme.getTitle(
                                                          type[index]),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 30,
                                                          color: Colors.white),
                                                    )),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Container()),
                                        ]),
                                  ),
                                ),
                              ),
                            ));
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
