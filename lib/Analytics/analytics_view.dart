import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_list_analytics/taskListAnalytics_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyticsView extends StatelessWidget {
  var theme = new ThemeInfo();

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

  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 10),
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
                          Navigator.of(context).pushNamed('/listCitationAnalyticsView');
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
                  Center(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 5, top: 4),
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
                          ])),
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
                                    Navigator.push(context, MaterialPageRoute<
                                            TaskListAnalyticsView>(
                                        builder: (BuildContext context) {
                                      return TaskListAnalyticsView(type[index]);
                                    }));
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
