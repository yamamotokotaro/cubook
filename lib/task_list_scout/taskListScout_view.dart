import 'package:cubook/task/task.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_model.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_view.dart';
import 'package:cubook/task_list_scout/taskListScout_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskView extends StatelessWidget {

  var task = new Task();
  Color themeColor;
  String type;
  String typeFireStore;
  String title = '';

  TaskView(String _type){
    if(_type == 'usagi'){
      themeColor = Colors.orange;
      title = 'ウサギのカブブック';
      typeFireStore = 'step';
    } else if(_type == 'sika') {
      themeColor = Colors.green;
      title = 'シカのカブブック';
      typeFireStore = 'step';
    } else if(_type == 'kuma'){
      themeColor = Colors.blue;
      title = 'クマのカブブック';
      typeFireStore = 'step';
    } else if(_type == 'challenge'){
      themeColor = Colors.green[900];
      title = 'チャレンジ章';
      typeFireStore = 'challenge';
    }
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
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
                        print(task.getAllMap(type));
                        if (!model.isGet) {
                          model.getSnapshot();
                        }
                        if (model.userSnapshot != null) {
                          var map_task = task.getAllMap(type);
                          var list_isCompleted =
                          new List.generate(map_task.length, (index) => false);
                          var list_percentage = new List.generate(
                              map_task.length, (index) => 0.0);
                          if(model.userSnapshot[typeFireStore] != null) {
                            final Map map = new Map<String, dynamic>.from(
                                model.userSnapshot[typeFireStore]);
                            for (int i = 0; i < map_task.length; i++) {
                              if (map.containsKey(i.toString())) {
                                list_percentage[i] =
                                (model.userSnapshot[typeFireStore]
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
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MyPageRoute(
                                                    page: _ModalPage(index, type, typeFireStore),
                                                    dismissible: true));
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(5),
                                                          bottomLeft:
                                                          const Radius
                                                              .circular(5)),
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
                                                                    backgroundColor:
                                                                    Colors.grey[300],
                                                                    valueColor:
                                                                    new AlwaysStoppedAnimation<
                                                                        Color>(themeColor),
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

class _ModalPage extends StatelessWidget {
  var task = new Task();
  PageController controller =
  PageController(initialPage: 0, viewportFraction: 0.8);
  int currentPage = 0;
  int numberPushed;
  String type;
  String typeFirestore;
  bool test = false;
  List<Widget> pages = <Widget>[
    /*StepSignView(),*/
//    StepAddView()
  ];

  _ModalPage(int number, String _type, String _typeFS) {
    numberPushed = number;
    type = _type;
    typeFirestore = _typeFS;
    pages.add(TaskScoutDetailView(type, number),);
    for (int i = 0; i < task.getPartMap(type, number)['hasItem']; i++) {
      pages.add(TaskScoutAddView(i, type));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double setHeight;
    if(height > 700.0){
      setHeight = height-200;
    } else {
      setHeight = height-60;
    }
    return ChangeNotifierProvider(
        create: (context) => TaskDetailScoutModel(numberPushed, task.getPartMap(type, numberPushed)['hasItem'], typeFirestore),
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