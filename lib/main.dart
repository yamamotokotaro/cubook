import 'dart:async';

import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/home_view.dart';
import 'package:cubook/home/home_view_new.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:cubook/login/login_view.dart';
import 'package:cubook/step/step_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        ChangeNotifierProvider(create: (context) => StepModel()),
      ],
        child: MaterialApp(
      home: HomeViewNew(),
      theme: new ThemeData(
          fontFamily: 'NotoSansJP',
          brightness: Brightness.light,
          primaryColor: Colors.orange,
          accentColor: Colors.orange),
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
