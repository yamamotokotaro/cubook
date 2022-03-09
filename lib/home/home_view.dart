import 'dart:math' as math;

import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_controller.dart';

class HomeView extends StatelessWidget {
  String? group;
  String? position;
  math.Random random = math.Random();

  HomeView(String? _group, String? _position) {
    group = _group;
    position = _position;
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
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: Semantics(
                        label: 'メニュー',
                        hint: 'ログアウトなどの操作を行います',
                        child: IconButton(
                          onPressed: () async {
                            late PackageInfo packageInfo;
                            if (!kIsWeb) {
                              packageInfo = await PackageInfo.fromPlatform();
                            }
                            await showDialog<int>(
                                context: context,
                                builder: (BuildContext context) {
                                  LicenseRegistry.addLicense(() async* {
                                    yield const LicenseEntryWithLineBreaks(
                                        ['令和2年版 諸規定'], '公財ボーイスカウト日本連盟');
                                  });
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    content: SingleChildScrollView(child:
                                        Consumer<HomeModel>(
                                            builder: (BuildContext context, HomeModel model, Widget? child) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          if (model.providerID == 'password') ListTile(
                                                  leading: const Icon(Icons.person),
                                                  title: const Text('アカウント設定'),
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            '/settingView');
                                                  },
                                                ) else Container(),
                                          ListTile(
                                            leading: const Icon(Icons.people),
                                            title: const Text('グループ設定'),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamed(
                                                  '/settingGroupView');
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.help_outline),
                                            title: const Text('ヘルプ'),
                                            onTap: () => launchURL(),
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.list),
                                            title: const Text('ライセンスを表示'),
                                            onTap: () => kIsWeb
                                                ? showLicensePage(
                                                    context: context,
                                                    applicationName: 'cubook',
                                                    applicationVersion:
                                                        'web',
                                                    applicationLegalese:
                                                        '©︎ 2020-2022 山本虎太郎',
                                                  )
                                                : showLicensePage(
                                                    context: context,
                                                    applicationName: 'cubook',
                                                    applicationVersion:
                                                        packageInfo.version,
                                                    applicationLegalese:
                                                        '©︎ 2020-2022 山本虎太郎',
                                                  ),
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.exit_to_app),
                                            title: const Text('ログアウト'),
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
                                        ],
                                      );
                                    })),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.dehaze,
                            size: 30,
                          ),
                        )))),
            const Spacer(),
            Selector<HomeModel, String?>(
              selector: (BuildContext context, HomeModel model) => model.groupName,
              builder: (BuildContext context, String? name, Widget? child) => Padding(
                padding: const EdgeInsets.only(top: 12, right: 15),
                child: Text(
                  name!,
                  style: GoogleFonts.notoSans(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )),
                ),
              ),
            ),
          ],
        ),
        Selector<HomeModel, String?>(
          selector: (BuildContext context, HomeModel model) => model.username,
          builder: (BuildContext context, String? name, Widget? child) => Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
            child: Text(
              name! + '、' + greet,
              style: GoogleFonts.notoSans(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              )),
            ),
          ),
        ),
        Consumer<HomeModel>(
          builder: (BuildContext context, HomeModel model, Widget? child) {
            if (model.currentUser == null) {
              model.login();
              return Center(
                child: Padding(padding: const EdgeInsets.all(5), child: Container()),
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
  const String url = 'https://sites.google.com/view/cubookinfo/qa';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
