import 'package:cubook/Analytics/analytics_model.dart';
import 'package:cubook/Analytics/analytics_view.dart';
import 'package:cubook/addLump_SelectItem/addLumpSelectItem_model.dart';
import 'package:cubook/addLump_SelectItem/addLumpSelectItem_view.dart';
import 'package:cubook/community/community_model.dart';
import 'package:cubook/community/community_view.dart';
import 'package:cubook/createActivity/createActivity_model.dart';
import 'package:cubook/createActivity/createActivity_view.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/detailActivity/detailActivity_view.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/editActivity/editActivity_model.dart';
import 'package:cubook/editActivity/editActivity_view.dart';
import 'package:cubook/home/home_controller.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/invite/invite_model.dart';
import 'package:cubook/invite/invite_view.dart';
import 'package:cubook/listAbsent/listAbsent_model.dart';
import 'package:cubook/listAbsent_scout/listAbsentScout_model.dart';
import 'package:cubook/listAbsent_scout/listAbsentScout_view.dart';
import 'package:cubook/listActivity/listActivity_model.dart';
import 'package:cubook/listActivity/listActivity_view.dart';
import 'package:cubook/listCitationAnalytics/listCitationAnalytics_model.dart';
import 'package:cubook/listCitationAnalytics/listCitationAnalytics_view.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_view.dart';
import 'package:cubook/list_member/listMember_model.dart';
import 'package:cubook/list_member/listMember_view.dart';
import 'package:cubook/notification/notification_model.dart';
import 'package:cubook/setting_account/settingAccount_model.dart';
import 'package:cubook/setting_account/settingAccount_view.dart';
import 'package:cubook/setting_account/widget/changeMailAddress.dart';
import 'package:cubook/setting_account/widget/changePassword.dart';
import 'package:cubook/setting_account_group/widget/accountMigration.dart';
import 'package:cubook/setting_account_group/widget/deleteGroupAccount.dart';
import 'package:cubook/setting_account_group/widget/editProfile.dart';
import 'package:cubook/setting_group/settingGroup_view.dart';
import 'package:cubook/task_detail_analytics/taskDetailAnalytics_model.dart';
import 'package:cubook/task_detail_analytics_member/taskDetailAnalyticsMember_model.dart';
import 'package:cubook/task_detail_analytics_member/taskDetailAnalyticsMember_view.dart';
import 'package:cubook/task_list_analytics/taskListAnalytics_model.dart';
import 'package:cubook/userDetail/userDetail_model.dart';
import 'package:cubook/setting_account_group/settingAccount_model.dart';
import 'package:cubook/setting_account_group/widget/changeAge.dart';
import 'package:cubook/setting_account_group/widget/changeName.dart';
import 'package:cubook/signup/signup_model.dart';
import 'package:cubook/task_list_scout/taskListScout_model.dart';
import 'package:cubook/task_list_scout_confirm/taskListScoutConfirm_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'community/comment_view.dart';
import 'task_detail_analytics/taskDetailAnalytics_view.dart';

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
  await Firebase.initializeApp();
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
  final boyColor = Colors.orange;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 通信関係
    /*_firebaseMessaging.configure(
      onMessage: (message) async {
        setState(() {
          title = message['notification']['title'];
          helper = 'You have recieved a new notification';
          print(title);
        });
      },
      onResume: (message) async {
        setState(() {
          title = message['data']['title'];
          helper = 'You have open the application from notification';
          print(message.toString());
        });
      },
    );*/
  }

  Future<PermissionStatus> permissionStatus =
  NotificationPermissions.getNotificationPermissionStatus();

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
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
          ChangeNotifierProvider(
              create: (context) => TaskListScoutConfirmModel()),
          ChangeNotifierProvider(create: (context) => AddLumpSelectItemModel()),
          ChangeNotifierProvider(
              create: (context) => SettingAccountGroupModel()),
          ChangeNotifierProvider(create: (context) => SettingAccountModel()),
          ChangeNotifierProvider(create: (context) => NotificationModel()),
          ChangeNotifierProvider(create: (context) => ListActivityModel()),
          ChangeNotifierProvider(create: (context) => CreateActivityModel()),
          ChangeNotifierProvider(create: (context) => DetailActivityModel()),
          ChangeNotifierProvider(create: (context) => EditActivityModel()),
          ChangeNotifierProvider(create: (context) => ListAbsentModel()),
          ChangeNotifierProvider(create: (context) => ListAbsentScoutModel()),
          ChangeNotifierProvider(create: (context) => AnalyticsModel()),
          ChangeNotifierProvider(create: (context) => TaskListAnalyticsModel()),
          ChangeNotifierProvider(create: (context) => SettingAccountModel()),
          ChangeNotifierProvider(
              create: (context) => TaskDetailAnalyticsModel()),
          ChangeNotifierProvider(
              create: (context) => TaskDetailAnalyticsMemberModel()),
          ChangeNotifierProvider(create: (context) => CommunityModel()),
          ChangeNotifierProvider(
              create: (context) => ListCitationAnalyticsModel()),
        ],
        child: MaterialApp(
          title: 'cubook',
          home: HomeController(),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'NotoSansJP',
              brightness: Brightness.light,
              primaryColor: Colors.blue[900],
              accentColor: Colors.blue[900]),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blue[900],
            accentColor: Colors.white,
          ),
          routes: <String, WidgetBuilder>{
            '/listTaskWaiting': (BuildContext context) => ListTaskWaitingView(),
            '/listMember': (BuildContext context) => ListMemberView(),
            '/addLumpSelectItem': (BuildContext context) =>
                AddLumpSelectItemView(),
            '/changeName': (BuildContext context) => ChangeNameView(),
            '/changeAge': (BuildContext context) => ChangeAgeView(),
            '/invite': (BuildContext context) => InviteView(),
            '/listActivity': (BuildContext context) => ListActivityView(),
            '/createActivity': (BuildContext context) => CreateActivityView(),
            '/detailActivity': (BuildContext context) => DetailActivityView(),
            '/editActivity': (BuildContext context) => EditActivityView(),
            '/listAbsentScout': (BuildContext context) => ListAbsentScoutView(),
            '/analytics': (BuildContext context) => AnalyticsView(),
            '/taskDetailAnalytics': (BuildContext context) =>
                TaskDetailAnalyticsView(),
            '/taskDetailAnalyticsMember': (BuildContext context) =>
                TaskDetailAnalyticsMemberView(),
            '/listCitationAnalyticsView': (BuildContext context) =>
                ListCitationAnalyticsView(),
            '/communityView': (BuildContext context) => CommunityView(),
            '/commentView': (BuildContext context) => CommentView(),
            '/settingView': (BuildContext context) => SettingAccountView(),
            '/settingGroupView': (BuildContext context) => SettingGroupView(),
            '/changeMailAddressView': (BuildContext context) => ChangeMailAddressView(),
            '/changePasswordView': (BuildContext context) => ChangePasswordView(),
            '/editProfile': (BuildContext context) => EditProfile(),
            '/deleteGroupAccount': (BuildContext context) => DeleteGroupAccount(),
            '/accountMigration': (BuildContext context) => AccountMigrationView()
          },
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('ja'),
          ],
        ));
  }
}
