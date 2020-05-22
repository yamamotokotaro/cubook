import 'package:cubook/addLump_ScoutList/addLumpScoutList_model.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/home/home_controller.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/invite/invite_model.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/list_scout/listScout_model.dart';
import 'package:cubook/select_book/selectBook_model.dart';
import 'package:cubook/signup/signup_model.dart';
import 'package:cubook/task_list_scout/taskListScout_model.dart';
import 'package:cubook/task_list_scout_confirm/taskListScoutConfirm_model.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final boyColor = Colors.orange;
  FirebaseAnalytics analytics = FirebaseAnalytics();

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
          ChangeNotifierProvider(create: (context) => SignupModel()),
          ChangeNotifierProvider(create: (context) => InviteModel()),
          ChangeNotifierProvider(create: (context) => ListScoutModel()),
          ChangeNotifierProvider(create: (context) => SelectBookModel()),
          ChangeNotifierProvider(create: (context) => TaskListScoutConfirmModel()),
          ChangeNotifierProvider(create: (context) => AddLumpScoutListModel()),
        ],
        child: MaterialApp(
          home: HomeController(),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
              fontFamily: 'NotoSansJP',
              brightness: Brightness.light,
              primaryColor: Colors.blue[900],
              accentColor: Colors.blue[900]),
          darkTheme: new ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blue[900],
            accentColor: Colors.white,
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale("en"),
            const Locale("ja"),
          ],
        ));
  }
}