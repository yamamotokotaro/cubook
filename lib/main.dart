import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/home/home_controller.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/task_list_scout/taskListScout_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp2());

/*class MyApp extends StatelessWidget {
  final boyColor = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new HomePage(),
      theme: new ThemeData(
          fontFamily: 'NotoSansJP',
          brightness: Brightness.light,
          primaryColor: Colors.orange,
          accentColor: Colors.orange),
    );
  }
}*/

class MyApp2 extends StatelessWidget {
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

/*class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;

  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();

    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return LoginView();
    } else {
      return Home();
    }
  }

  void _checkCurrentUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }
}*/
