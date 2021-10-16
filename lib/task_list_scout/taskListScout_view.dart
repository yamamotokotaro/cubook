import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_view.dart';
import 'package:cubook/task_list_scout/taskListScout_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListScoutView extends StatelessWidget {

  var task = TaskContents();
  var theme = ThemeInfo();
  Color themeColor;
  String type;
  String typeFireStore;
  String title = '';

  TaskListScoutView(String _type){
    themeColor = theme.getThemeColor(_type);
    title = theme.getTitle(_type);
    if(_type == 'usagi'){
      typeFireStore = 'step';
    } else if(_type == 'challenge'){
      typeFireStore = 'challenge';
    }
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark;
    if(Theme.of(context).colorScheme.secondary == Colors.white){
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 5,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        brightness: Brightness.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child:
                      Consumer<TaskListScoutModel>(builder: (context, model, child) {
                        if (!model.isGet) {
                          model.getSnapshot();
                        }
                        if (model.userSnapshot != null) {
                          final mapTask = task.getAllMap(type);
                          final list_isCompleted =
                          List.generate(mapTask.length, (index) => false);
                          final list_percentage = List.generate(
                              mapTask.length, (index) => 0.0);
                          if(model.userData[type] != null) {
                            final Map map = Map<String, dynamic>.from(
                                model.userSnapshot.get(type));
                            for (int i = 0; i < mapTask.length; i++) {
                              if (map.containsKey(i.toString())) {
                                list_percentage[i] =
                                model.userSnapshot.get(type)
                                [i.toString()] /
                                    mapTask[i]['hasItem'].toDouble();
                              }
                            }
                          }
                          for (int i = 0; i < list_percentage.length; i++) {
                            if (list_percentage[i] == 1.0) {
                              list_isCompleted[i] = true;
                            }
                          }
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: mapTask.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push<dynamic>(
                                                MyPageRoute(
                                                    page: showTaskView(index, type, 0),
                                                    dismissible: true));
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(10),
                                                          bottomLeft:
                                                          const Radius
                                                              .circular(10)),
                                                      color: themeColor),
                                                  height: 120,
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        minWidth: 76),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.all(20),
                                                        child: Text(
                                                          mapTask[index]['number'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 30,
                                                              color:
                                                              Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              top: 10),
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                mapTask[
                                                                index]['title'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize:
                                                                    25),
                                                              ))),
                                                      if (list_isCompleted[index]) Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 20),
                                                        child: Align(
                                                            alignment:
                                                            Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                              'かんしゅう🎉',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                                  fontSize:
                                                                  20),
                                                            )),
                                                      ) else Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Row(
                                                            children: <
                                                                Widget>[
                                                              Text('達成度'),
                                                              Padding(
                                                                  padding:
                                                                  EdgeInsets.all(
                                                                      10),
                                                                  child:
                                                                  CircularProgressIndicator(
                                                                    backgroundColor: isDark ? Colors.grey[700]: Colors.grey[300],
                                                                    valueColor: new AlwaysStoppedAnimation<Color>(isDark ?Colors.white: theme.getThemeColor(type)),
                                                                    value:
                                                                    list_percentage[index],
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}