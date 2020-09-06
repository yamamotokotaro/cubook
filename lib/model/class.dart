import 'package:cubook/model/task.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_model.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class showTaskConfirmView extends StatelessWidget {
  var task = new Task();
  int currentPage = 0;
  int page;
  int number;
  String type;
  String typeFirestore;
  String uid;
  bool test = false;
  List<Widget> pages = <Widget>[
    /*StepSignView(),*/
//    StepAddView()
  ];

  showTaskConfirmView(int page, String _type, String _uid,int number) {
    this.page = page;
    this.number = number;
    type = _type;
    uid = _uid;
    pages.add(
      TaskScoutDetailConfirmView(type, page),
    );
    for (int i = 0; i < task.getPartMap(type, page)['hasItem']; i++) {
      pages.add(TaskScoutAddConfirmView(i, type));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double setHeight;
    double setFraction;
    if (height > 700.0) {
      setHeight = height - 200;
    } else {
      setHeight = height - 90;
    }
    if (width > 1000.0) {
      setFraction = 0.6;
    } else {
      setFraction = 0.8;
    }
    PageController controller =
    PageController(initialPage: number, viewportFraction: setFraction);

    return ChangeNotifierProvider(
        create: (context) => TaskDetailScoutConfirmModel(
            page, task.getPartMap(type, page)['hasItem'], type, uid,controller),
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