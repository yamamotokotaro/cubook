import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/widget/listEffort_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_controller.dart';

class HomeViewNew extends StatelessWidget {
  String group;
  HomeViewNew(String _group){
    group = _group;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Spacer(),
            Align(
                alignment: Alignment.bottomRight,
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child:
                        Consumer<HomeModel>(builder: (context, model, child) {
                      return FlatButton.icon(
                          icon: Icon(Icons.help),
                          label: Text('ヘルプ'),
                          onPressed: () {
                            launchURL();
                          });
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child:
                        Consumer<HomeModel>(builder: (context, model, child) {
                      return FlatButton.icon(
                          icon: Icon(Icons.exit_to_app),
                          label: Text('ログアウト'),
                          onPressed: () {
                            model.logout();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute<HomeController>(
                                    builder: (BuildContext context) {
                              return HomeController();
                            }));
                          });
                    }),
                  ),
                ])),
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
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container()),
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
