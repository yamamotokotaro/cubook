import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/Analytics/analytics_model.dart';
import 'package:cubook/Analytics/analytics_view.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/listActivity/listActivity_view.dart';
import 'package:cubook/list_member/listMember_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeLeaderView extends StatelessWidget {
  String group;
  bool isDark;

  @override
  Widget build(BuildContext context) {
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Column(children: <Widget>[
      Consumer<HomeLeaderModel>(builder: (context, model, child) {
        model.getSnapshot(context);
        if (model.group != null) {
          return StreamBuilder<QuerySnapshot>(
              stream: model.getTaskSnapshot(model.group),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length != 0) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        color: Colors.blue[900],
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/listTaskWaiting');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Material(
                                          type: MaterialType.transparency,
                                          child: Text(
                                            'サイン待ち' +
                                                snapshot.data.docs.length
                                                    .toString() +
                                                '件',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 30,
                                                color: Colors.white),
                                          ))),
                                ]),
                          ),
                        ),
                      )),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Center(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator()),
                  );
                }
              });
        } else {
          return const Center(
            child: Padding(
                padding: EdgeInsets.all(5), child: CircularProgressIndicator()),
          );
        }
      }),
      Selector<HomeLeaderModel, String>(
          selector: (context, model) => model.teamPosition,
          builder: (context, teamPosition, child) {
            return Column(children: <Widget>[

              Padding(
                padding: EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 0),
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
                              .pushNamed('/analytics');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.insert_chart,
                                  color: Theme.of(context).accentColor,
                                  size: 35,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                        'アナリティクス',
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
                                top: 10, left: 10, right: 10, bottom: 0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                top: 10, left: 10, right: 10, bottom: 20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.call_made,
                                          color: Theme.of(context).accentColor,
                                          size: 35,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Material(
                                              type: MaterialType.transparency,
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
                              top: 10, left: 10, right: 10, bottom: 0),
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
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 20),
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
                                        content: SingleChildScrollView(child:
                                            Consumer<AnalyticsModel>(builder:
                                                (context, model, child) {
                                          model.export();
                                          if (model.isExporting) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text('エクセルに出力中'),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15, bottom: 12),
                                                    child: Container(
                                                        width: 200,
                                                        child:
                                                            LinearProgressIndicator(
                                                          backgroundColor:
                                                              isDark
                                                                  ? Colors
                                                                      .grey[700]
                                                                  : Colors.grey[
                                                                      300],
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
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
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text('出力が完了しました'),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: FlatButton(
                                                        onPressed: () {
                                                          model.openFile();
                                                        },
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        child: Text(
                                                          'アプリで開く',
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? Colors.black
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.call_made,
                                        color: Theme.of(context).accentColor,
                                        size: 35,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: Text(
                                              'エクセルに出力',
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
            ]);
          }),
    ]);
  }

  void launchURL() async {
    const url =
        'https://sites.google.com/view/cubookinfo/qa/%E9%87%8D%E8%A6%81%E3%82%A2%E3%83%83%E3%83%97%E3%83%87%E3%83%BC%E3%83%88%E3%81%AE%E3%81%8A%E9%A1%98%E3%81%84';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
