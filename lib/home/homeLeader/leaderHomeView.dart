import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'leaderHomeModel.dart';

class HomeLeaderView extends StatelessWidget {
  String? group;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Consumer<LeaderHomeModel>(builder:
          (BuildContext context, LeaderHomeModel model, Widget? child) {
        model.getSnapshot(context);
        if (model.group != null) {
          return StreamBuilder<QuerySnapshot>(
              stream: model.getTaskSnapshot(model.group),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/listTaskWaiting');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    size: 35,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Material(
                                          type: MaterialType.transparency,
                                          child: Text(
                                            'サイン待ち' +
                                                snapshot.data!.docs.length
                                                    .toString() +
                                                '件',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 30,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer),
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
                  return const Center(
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
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
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
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      color: Theme.of(context).colorScheme.primary,
                      size: 35,
                    ),
                    const Padding(
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
        ),
      ),
      Selector<LeaderHomeModel, String?>(
          selector: (BuildContext context, LeaderHomeModel model) =>
              model.teamPosition,
          builder: (BuildContext context, String? teamPosition, Widget? child) {
            if (teamPosition == null) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 10, right: 10, bottom: 5),
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
                      padding: const EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.event,
                              color: Theme.of(context).colorScheme.primary,
                              size: 35,
                            ),
                            const Padding(
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
                ),
              );
            } else {
              return Container();
            }
          }),
      Selector<LeaderHomeModel, String?>(
          selector: (BuildContext context, LeaderHomeModel model) =>
              model.teamPosition,
          builder: (BuildContext context, String? teamPosition, Widget? child) {
            return Padding(
              padding: teamPosition != null
                  ? const EdgeInsets.only(
                      top: 5, left: 10, right: 10, bottom: 5)
                  : const EdgeInsets.only(
                      top: 5, left: 10, right: 10, bottom: 20),
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
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.insert_chart,
                            color: Theme.of(context).colorScheme.primary,
                            size: 35,
                          ),
                          const Padding(
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
              ),
            );
          }),
    ]);
  }

  Future<void> launchURL() async {
    const String url =
        'https://sites.google.com/view/cubookinfo/qa/%E9%87%8D%E8%A6%81%E3%82%A2%E3%83%83%E3%83%97%E3%83%87%E3%83%BC%E3%83%88%E3%81%AE%E3%81%8A%E9%A1%98%E3%81%84';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buttonItem(
      IconData iconData, String title, String name, BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(0),
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
            Navigator.of(context).pushNamed(name);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconData,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 35,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      )),
                ]),
          ),
        ),
      )),
    ));
  }
}
