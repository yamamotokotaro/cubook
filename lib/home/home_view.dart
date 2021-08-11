import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:math' as math;

import 'home_controller.dart';

class HomeView extends StatelessWidget {
  String group;
  String position;
  var random = math.Random();

  HomeView(String _group, String _position) {
    group = _group;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    String greet = '';
    String emoji = '';
    List<String> emojis;
    if (now.hour < 4) {
      if (position == 'scout') {
        greet = '夜更かしは良くないですよ😾';
      } else {
        greet = 'こんばんは💤';
      }
    } else if (4 <= now.hour && now.hour < 10) {
      if (position == 'scout') {
        emoji = '☀️';
      } else {
        emoji = '☀️';
      }
      greet = 'おはようございます️' + emoji;
    } else if (10 <= now.hour && now.hour < 14) {
      if (position == 'scout') {
        emoji = '😀️';
      } else {
        emoji = '😀️';
      }
      greet = 'こんにちは️' + emoji;
    } else if (14 <= now.hour && now.hour < 17) {
      if (position == 'scout') {
        emoji = '🍵';
      } else {
        emoji = '☕️️';
      }
      greet = 'こんにちは' + emoji;
    } else if (17 <= now.hour && now.hour < 20) {
      if (position == 'scout') {
        emoji = '🌙';
      } else {
        emoji = '🌙';
      }
      greet = 'こんばんは' + emoji;
    } else if (20 <= now.hour && now.hour <= 23) {
      if (position == 'scout') {
        emoji = '💤';
      } else {
        emoji = '🌙';
      }
      greet = 'こんばんは' + emoji;
    }
    return Column(
      children: <Widget>[
        Row(
          children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: Semantics(
                        label: 'メニュー',
                        hint: 'ログアウトなどの操作を行います',
                        child: IconButton(
                          onPressed: () async {
                            PackageInfo packageInfo;
                            if (!kIsWeb) {
                              packageInfo = await PackageInfo.fromPlatform();
                            }
                            await showDialog<int>(
                                context: context,
                                builder: (context) {
                                  LicenseRegistry.addLicense(() async* {
                                    yield LicenseEntryWithLineBreaks(
                                        ['令和2年版 諸規定'], '公財ボーイスカウト日本連盟');
                                  });
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    content: SingleChildScrollView(child:
                                        Consumer<HomeModel>(
                                            builder: (context, model, child) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          if (model.providerID == 'password') ListTile(
                                                  leading: Icon(Icons.person),
                                                  title: Text('アカウント設定'),
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            '/settingView');
                                                  },
                                                ) else Container(),
                                          ListTile(
                                            leading: Icon(Icons.people),
                                            title: Text('グループ設定'),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamed(
                                                  '/settingGroupView');
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.help_outline),
                                            title: Text('ヘルプ'),
                                            onTap: () => launchURL(),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('ライセンスを表示'),
                                            onTap: () => kIsWeb
                                                ? showLicensePage(
                                                    context: context,
                                                    applicationName: 'cubook',
                                                    applicationVersion:
                                                        'web',
                                                    applicationLegalese:
                                                        '©︎ 2020-2021 山本虎太郎',
                                                  )
                                                : showLicensePage(
                                                    context: context,
                                                    applicationName: 'cubook',
                                                    applicationVersion:
                                                        packageInfo.version,
                                                    applicationLegalese:
                                                        '©︎ 2020-2021 山本虎太郎',
                                                  ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.exit_to_app),
                                            title: Text('ログアウト'),
                                            onTap: () {
                                              model.logout();
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute<
                                                          HomeController>(
                                                      builder: (BuildContext
                                                          context) {
                                                return HomeController();
                                              }));
                                            },
                                          ),
                                          /*Divider(color: Colors.grey),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FlatButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'プライバシーポリシー',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              FlatButton(
                                                onPressed: () {},
                                                child: Text(
                                                  '利用規約',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),*/
                                        ],
                                      );
                                    })),
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.dehaze,
                            size: 30,
                          ),
                        )))),
            Spacer(),
            Selector<HomeModel, String>(
              selector: (context, model) => model.groupName,
              builder: (context, name, child) => Padding(
                padding: EdgeInsets.only(top: 12, right: 15),
                child: Text(
                  name,
                  style: GoogleFonts.notoSans(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )),
                ),
              ),
            ),
          ],
        ),
        Selector<HomeModel, String>(
          selector: (context, model) => model.username,
          builder: (context, name, child) => Padding(
            padding: EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
            child: Text(
              name + '、' + greet,
              style: GoogleFonts.notoSans(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              )),
            ),
          ),
        ),
        Consumer<HomeModel>(
          builder: (context, model, child) {
            if (model.currentUser == null) {
              model.login();
              return Center(
                child: Padding(padding: EdgeInsets.all(5), child: Container()),
              );
            } else {
              return model.toShow;
            }
          },
        ),
        listEffort()
      ],
    );
  }
}

void launchURL() async {
  const url = 'https://sites.google.com/view/cubookinfo/qa';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
