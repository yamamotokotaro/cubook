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
