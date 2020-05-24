import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/home_lump/homeLump_view.dart';
import 'package:cubook/invite/invite_view.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_view.dart';
import 'package:cubook/list_scout/listMember_view.dart';
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
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () {
                  launchURL();
                },
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.assignment_late,
                          color: Theme.of(context).accentColor,
                          size: 30,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                '重要なお知らせ',
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
        model.getSnapshot();
        if (model.group != null) {
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('task')
                  .where('group', isEqualTo: model.group)
                  .where('phase', isEqualTo: 'wait')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.length != 0) {
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
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute<ListTaskWaitingView>(
                                    builder: (BuildContext context) {
                              return ListTaskWaitingView();
                            }));
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
                                                snapshot.data.documents.length
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
            onTap: () {
              Navigator.of(context).pushNamed('/listMember');
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.book,
                      color: Theme.of(context).accentColor,
                      size: 35,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            ' カブブック確認',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 30),
                          ),
                        )),
                  ]),
            ),
          ),
        )),
      ),
      Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/homeLump');
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.list,
                          color: Theme.of(context).accentColor,
                          size: 35,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                ' 一括サイン',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal, fontSize: 30),
                              ),
                            )),
                      ]),
                ),
              ),
            )),
      ),
      Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 20),
        child: Container(
            child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute<InviteView>(
                  builder: (BuildContext context) {
                return InviteView();
              }));
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
                            'メンバーを招待',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 30,
                            ),
                          ),
                        )),
                  ]),
            ),
          ),
        )),
      ),
    ]);
  }

  void launchURL() async {
    const url = 'https://sites.google.com/view/cubookinfo/qa/%E9%87%8D%E8%A6%81%E3%82%A2%E3%83%83%E3%83%97%E3%83%87%E3%83%BC%E3%83%88%E3%81%AE%E3%81%8A%E9%A1%98%E3%81%84';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
