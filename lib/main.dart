import 'package:cubook/analytics/analyticsModel.dart';
import 'package:cubook/analytics/analyticsView.dart';
import 'package:cubook/analyticsScoutCompletion/analyticsScoutCompletionModel.dart';
import 'package:cubook/analyticsScoutCompletion/analyticsScoutCompletionView.dart';
import 'package:cubook/analyticsTaskDetail/taskDetailAnalytics_model.dart';
import 'package:cubook/analyticsTaskList/analyticsTaskListModel.dart';
import 'package:cubook/checkScoutTaskList/taskListScoutConfirm_model.dart';
import 'package:cubook/createActivity/addLumpSelectItem/addLumpSelectItem_model.dart';
import 'package:cubook/createActivity/addLumpSelectItem/addLumpSelectItem_view.dart';
import 'package:cubook/createActivity/createActivity_model.dart';
import 'package:cubook/createActivity/createActivity_view.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/detailActivity/detailActivity_view.dart';
import 'package:cubook/detailMigrationWaiting/detailMigrationWaiting_model.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/editActivity/editActivity_model.dart';
import 'package:cubook/editActivity/editActivity_view.dart';
import 'package:cubook/firebase_options.dart';
import 'package:cubook/home/homeController.dart';
import 'package:cubook/home/homeLeader/leaderHomeModel.dart';
import 'package:cubook/home/homeModel.dart';
import 'package:cubook/home/listEffort/listEffortModel.dart';
import 'package:cubook/invite/invite_model.dart';
import 'package:cubook/invite/invite_view.dart';
import 'package:cubook/listAbsent/listAbsent_model.dart';
import 'package:cubook/listActivity/listActivityModel.dart';
import 'package:cubook/listActivity/listActivityView.dart';
import 'package:cubook/listActivityScout/listActivityScoutModel.dart';
import 'package:cubook/listActivityScout/listActivityScoutView.dart';
import 'package:cubook/listCitationAnalytics/listCitationAnalytics_model.dart';
import 'package:cubook/listCitationAnalytics/listCitationAnalytics_view.dart';
import 'package:cubook/listMember/listMember_model.dart';
import 'package:cubook/listMember/listMember_view.dart';
import 'package:cubook/listMigrationWaiting/listMigrationWaiting_model.dart';
import 'package:cubook/listMigrationWaiting/listMigrationWaiting_view.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_view.dart';
import 'package:cubook/notification/notification_model.dart';
import 'package:cubook/scoutTaskList/scoutTaskListModel.dart';
import 'package:cubook/settingAccount/settingAccount_model.dart';
import 'package:cubook/settingAccount/settingAccount_view.dart';
import 'package:cubook/settingAccount/widget/changeMailAddress.dart';
import 'package:cubook/settingAccount/widget/changePassword.dart';
import 'package:cubook/settingGroup/settingGroup_model.dart';
import 'package:cubook/settingGroup/settingGroup_view.dart';
import 'package:cubook/settingGroupAccount/settingAccount_model.dart';
import 'package:cubook/settingGroupAccount/widget/accountMigration.dart';
import 'package:cubook/settingGroupAccount/widget/changeAge.dart';
import 'package:cubook/settingGroupAccount/widget/changeName.dart';
import 'package:cubook/settingGroupAccount/widget/deleteGroupAccount.dart';
import 'package:cubook/settingGroupAccount/widget/editProfile.dart';
import 'package:cubook/signup/signup_model.dart';
import 'package:cubook/userDetail/userDetail_model.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'analyticsTaskDetail/taskDetailAnalytics_view.dart';

void main() async {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  //FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

  // Pass all uncaught errors from the framework to Crashlytics.

  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  // Firebaseの各サービスを使う前に初期化を済ませておく必要がある
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String title = 'Title';
  String helper = 'helper';
  final MaterialColor boyColor = Colors.orange;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => HomeModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ListEffortModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => LeaderHomeModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ScoutTaskModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ListTaskWaitingModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => DetailTaskWaitingModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => UserDetailModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SignupModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => InviteModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ListMemberModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => TaskListScoutConfirmModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => AddLumpSelectItemModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SettingAccountGroupModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SettingAccountModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => NotificationModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ListActivityModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => CreateActivityModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => DetailActivityModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => EditActivityModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ListAbsentModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ListAbsentScoutModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => AnalyticsModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => AnalyticsTaskListModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SettingAccountModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => AnalyticsTaskDetailModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) =>
                  AnalyticsScoutCompletionModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SettingGroupModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ListMigrationWaitingModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => DetailMigrationWaitingModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ListCitationAnalyticsModel()),
        ],
        child: DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            return MaterialApp(
              title: 'cubook',
              home: HomeController(),
              navigatorObservers: <NavigatorObserver>[observer],
              debugShowCheckedModeBanner: false,
              theme: lightDynamic == null
                  ? ThemeData(
                      fontFamily: 'NotoSansJP',
                      colorSchemeSeed: Colors.blue,
                      useMaterial3: true)
                  : ThemeData(
                      fontFamily: 'NotoSansJP',
                      useMaterial3: true,
                      colorScheme: lightDynamic),
              darkTheme: darkDynamic == null
                  ? ThemeData(
                      fontFamily: 'NotoSansJP',
                      brightness: Brightness.dark,
                      colorSchemeSeed: Colors.blue,
                      useMaterial3: true)
                  : ThemeData(
                      useMaterial3: true,
                      fontFamily: 'NotoSansJP',
                      brightness: Brightness.dark,
                      colorScheme: darkDynamic),
              routes: <String, WidgetBuilder>{
                '/listTaskWaiting': (BuildContext context) =>
                    ListTaskWaitingView(),
                '/listMember': (BuildContext context) => ListMemberView(),
                '/addLumpSelectItem': (BuildContext context) =>
                    AddLumpSelectItemView(),
                '/changeName': (BuildContext context) => ChangeNameView(),
                '/changeAge': (BuildContext context) => ChangeAgeView(),
                '/invite': (BuildContext context) => InviteView(),
                '/listActivity': (BuildContext context) => ListActivityView(),
                '/createActivity': (BuildContext context) =>
                    CreateActivityView(),
                '/detailActivity': (BuildContext context) =>
                    DetailActivityView(),
                '/editActivity': (BuildContext context) => EditActivityView(),
                '/listAbsentScout': (BuildContext context) =>
                    ListAbsentScoutView(),
                '/analytics': (BuildContext context) => AnalyticsView(),
                '/taskDetailAnalytics': (BuildContext context) =>
                    AnalyticsTaskDetailView(),
                '/taskDetailAnalyticsMember': (BuildContext context) =>
                    AnalyticsScoutCompletionView(),
                '/listCitationAnalyticsView': (BuildContext context) =>
                    ListCitationAnalyticsView(),
                '/settingView': (BuildContext context) => SettingAccountView(),
                '/settingGroupView': (BuildContext context) =>
                    SettingGroupView(),
                '/changeMailAddressView': (BuildContext context) =>
                    ChangeMailAddressView(),
                '/changePasswordView': (BuildContext context) =>
                    ChangePasswordView(),
                '/editProfile': (BuildContext context) => EditProfile(),
                '/deleteGroupAccount': (BuildContext context) =>
                    DeleteGroupAccount(),
                '/accountMigration': (BuildContext context) =>
                    AccountMigrationView(),
                '/listMigrationWaiting': (BuildContext context) =>
                    ListMigrationWaitingView(),
              },
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ja'),
              ],
            );
          });
        }));
  }
}
