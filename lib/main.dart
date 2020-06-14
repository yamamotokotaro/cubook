import 'package:cubook/Support/Support_view.dart';
import 'package:cubook/Support/Support_model.dart';
import 'package:cubook/addLump_ScoutList/addLumpScoutList_model.dart';
import 'package:cubook/addLump_ScoutList/addLumpScoutList_view.dart';
import 'package:cubook/addLump_SelectItem/addLumpSelectItem_model.dart';
import 'package:cubook/addLump_SelectItem/addLumpSelectItem_view.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/home/home_controller.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/home_lump/homeLump_view.dart';
import 'package:cubook/invite/invite_model.dart';
import 'package:cubook/invite/invite_view.dart';
import 'package:cubook/listCitationWaiting/listCitationWaiting_model.dart';
import 'package:cubook/listCitationWaiting/listCitationWaiting_view.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/list_member/listMember_model.dart';
import 'package:cubook/list_member/listMember_view.dart';
import 'package:cubook/notification/notification_model.dart';
import 'package:cubook/userDetail/userDetail_model.dart';
import 'package:cubook/setting_account_group/settingAccount_model.dart';
import 'package:cubook/setting_account_group/settingAccount_view.dart';
import 'package:cubook/setting_account_group/widget/changeAge.dart';
import 'package:cubook/setting_account_group/widget/changeName.dart';
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
import 'package:package_info/package_info.dart';

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = false;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String title = "Title";
  String helper = "helper";
  final boyColor = Colors.orange;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  /*FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          title = message["notification"]["title"];
          helper = "You have recieved a new notification";
        });

      },
      onResume: (message) async{
        setState(() {
          title = message["data"]["title"];
          helper = "You have open the application from notification";
        });

      },

    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
  }*/

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
          ChangeNotifierProvider(create: (context) => UserDetailModel()),
          ChangeNotifierProvider(create: (context) => SignupModel()),
          ChangeNotifierProvider(create: (context) => InviteModel()),
          ChangeNotifierProvider(create: (context) => ListMemberModel()),
          ChangeNotifierProvider(create: (context) => TaskListScoutConfirmModel()),
          ChangeNotifierProvider(create: (context) => AddLumpScoutListModel()),
          ChangeNotifierProvider(create: (context) => AddLumpSelectItemModel()),
          ChangeNotifierProvider(create: (context) => SettingAccountModel()),
          ChangeNotifierProvider(create: (context) => NotificationModel()),
          ChangeNotifierProvider(create: (context) => SupportModel()),
          ChangeNotifierProvider(create: (context) => ListCitationWaitingModel()),
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
          routes: <String, WidgetBuilder> {
            '/listMember': (BuildContext context) => ListMemberView(),
            '/listCitationWaiting': (BuildContext context) => ListCitationWaitingView(),
            '/homeLump': (BuildContext context) => HomeLumpView(),
            '/addLumpScoutList': (BuildContext context) => AddLumpScoutListView(),
            '/addLumpSelectItem': (BuildContext context) => AddLumpSelectItemView(),
            //'/settingAccount': (BuildContext context) => SettingAccountView(),
            '/changeName': (BuildContext context) => ChangeNameView(),
            '/changeAge': (BuildContext context) => ChangeAgeView(),
            '/support': (BuildContext context) => SupportView(),
            '/invite': (BuildContext context) => InviteView(),
          },
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