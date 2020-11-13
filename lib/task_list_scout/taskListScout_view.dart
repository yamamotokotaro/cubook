import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_model.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_view.dart';
import 'package:cubook/task_list_scout/taskListScout_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskView extends StatelessWidget {

  var task = new Task();
  var theme = new ThemeInfo();
  Color themeColor;
  String type;
  String typeFireStore;
  String title = '';

  TaskView(String _type){
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
    if(Theme.of(context).accentColor == Colors.white){
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
                          var map_task = task.getAllMap(type);
                          var list_isCompleted =
                          new List.generate(map_task.length, (index) => false);
                          var list_percentage = new List.generate(
                              map_task.length, (index) => 0.0);
                          if(model.userSnapshot.data()[type] != null) {
                            final Map map = new Map<String, dynamic>.from(
                                model.userSnapshot.data()[type]);
                            for (int i = 0; i < map_task.length; i++) {
                              if (map.containsKey(i.toString())) {
                                list_percentage[i] =
                                (model.userSnapshot.data()[type]
                                [i.toString()] /
                                    map_task[i]['hasItem'].toDouble());
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
                              itemCount: map_task.length,
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
                                                          map_task[index]['number'],
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
                                                                map_task[
                                                                index]['title'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize:
                                                                    25),
                                                              ))),
                                                      list_isCompleted[index]
                                                          ? Padding(
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
                                                      )
                                                          : Padding(
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

class showTaskView extends StatelessWidget {
  var task = new Task();
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
    PageController controller =
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