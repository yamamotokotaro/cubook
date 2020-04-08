import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/home/home_controller.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/task_list_scout/taskListScout_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final boyColor = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HomeModel()),
          ChangeNotifierProvider(create: (context) => ListEffortModel()),
          ChangeNotifierProvider(create: (context) => HomeLeaderModel()),
          ChangeNotifierProvider(create: (context) => TaskListScoutModel()),
          ChangeNotifierProvider(create: (context) => ListTaskWaitingModel()),
          ChangeNotifierProvider(create: (context) => DetailTaskWaitingModel()),
        ],
        child: MaterialApp(
          home: HomeController(),
          theme: new ThemeData(
              fontFamily: 'NotoSansJP',
              brightness: Brightness.light,
              primaryColor: Colors.blue[900],
              accentColor: Colors.blue[900]),
        ));
  }
}
