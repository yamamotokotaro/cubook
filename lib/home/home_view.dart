import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_controller.dart';

class HomeViewNew extends StatelessWidget {
  String group;

  HomeViewNew(String _group) {
    group = _group;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: IconButton(
                      onPressed: () async {
                        PackageInfo packageInfo =
                            await PackageInfo.fromPlatform();
                        await showDialog<int>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "cubook",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                content: SingleChildScrollView(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    /*ListTile(
                                      leading: Icon(Icons.favorite_border),
                                      title: Text('広告を見る'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/support');
                                      },
                                    ),*/
                                    ListTile(
                                      leading: Icon(Icons.help_outline),
                                      title: Text('ヘルプ'),
                                      onTap: () => launchURL(),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.list),
                                      title: Text('ライセンスを表示'),
                                      onTap: () => showLicensePage(
                                        context: context,
                                        applicationName: 'cubook',
                                        applicationVersion: packageInfo.version,
                                        applicationLegalese: '©︎ 2020 山本虎太郎',
                                      ),
                                    ),
                                    Consumer<HomeModel>(
                                        builder: (context, model, child) {
                                      return ListTile(
                                        leading: Icon(Icons.exit_to_app),
                                        title: Text('ログアウト'),
                                        onTap: () {
                                          model.logout();
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute<HomeController>(
                                                  builder:
                                                      (BuildContext context) {
                                            return HomeController();
                                          }));
                                        },
                                      );
                                    })
                                  ],
                                )),
                              );
                            });
                      },
                      icon: Icon(
                        Icons.dehaze,
                        size: 30,
                      ),
                    ))),
            Spacer(),
            Selector<HomeModel, String>(
              selector: (context, model) => model.groupName,
              builder: (context, name, child) =>
                  Padding(
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
              name + '、こんにちは😀',
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
