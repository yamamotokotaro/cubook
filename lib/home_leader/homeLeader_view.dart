import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeLeaderView extends StatelessWidget {
  String group;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[

      Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0),
        child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  launchURL();
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).accentColor,
                          size: 30,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                ' 上進について',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal, fontSize: 25),
                              ),
                            )),
                      ]),
                ),
              ),
            )),
      ),
      Consumer<HomeLeaderModel>(builder: (context, model, child) {
        model.getSnapshot(context);
        if (model.group != null) {
          return StreamBuilder<QuerySnapshot>(
              stream: model.getTaskSnapshot(model.group),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length != 0) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        color: Colors.blue[900],
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/listTaskWaiting');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Material(
                                          type: MaterialType.transparency,
                                          child: Text(
                                            'サイン待ち' +
                                                snapshot.data.docs.length
                                                    .toString() +
                                                '件',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 30,
                                                color: Colors.white),
                                          ))),
                                ]),
                          ),
                        ),
                      )),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Center(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator()),
                  );
                }
              });
        } else {
          return const Center(
            child: Padding(
                padding: EdgeInsets.all(5), child: CircularProgressIndicator()),
          );
        }
      }),
      Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: Container(
            child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/listMember');
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      color: Theme.of(context).accentColor,
                      size: 35,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            ' メンバーリスト',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 30),
                          ),
                        )),
                  ]),
            ),
          ),
        )),
      ),
      Selector<HomeLeaderModel, String>(
          selector: (context, model) => model.teamPosition,
          builder: (context, teamPosition, child) {
            if (teamPosition == null) {
              return Padding(
                padding:
                    EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                child: Container(
                    child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/listActivity');
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.event,
                              color: Theme.of(context).accentColor,
                              size: 35,
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    '活動記録',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 30),
                                  ),
                                )),
                          ]),
                    ),
                  ),
                )),
              );
            } else {
              return Container();
            }
          }),
      Selector<HomeLeaderModel, String>(
          selector: (context, model) => model.teamPosition,
          builder: (context, teamPosition, child) {
            return Padding(
              padding: teamPosition != null
                  ? EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5)
                  : EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 20),
              child: Container(
                  child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onTap: () async {
                    // final Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions();
                    Navigator.of(context).pushNamed('/analytics');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.insert_chart,
                            color: Theme.of(context).accentColor,
                            size: 35,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  'アナリティクス',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 30),
                                ),
                              )),
                        ]),
                  ),
                ),
              )),
            );
          }),
    ]);
  }

  void launchURL() async {
    const url =
        'https://sites.google.com/view/cubookinfo/%E4%BD%BF%E3%81%84%E6%96%B9/%E4%B8%8A%E9%80%B2%E3%81%99%E3%82%8B%E3%81%A8%E3%81%8D%E3%81%AE%E6%93%8D%E4%BD%9C';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
