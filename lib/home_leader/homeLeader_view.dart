import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:cubook/invite/invite_view.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_view.dart';
import 'package:cubook/list_scout/listScout_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeLeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Consumer<HomeLeaderModel>(builder: (context, model, _) {
        if (!model.isLoaded) {
          model.getTaskSnapshot2();
        }
        if (model.taskSnapshot != null) {
          if (model.taskSnapshot.documents.length != 0) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  child: Card(
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
                                        model.taskSnapshot.documents.length
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
                padding: EdgeInsets.all(5), child: CircularProgressIndicator()),
          );
        }
      }),
      /*Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Container(
            child: Card(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute<ListTaskWaitingView>(
                      builder: (BuildContext context) {
                        return ListTaskWaitingView();
                      }));},
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.blue[900],
                      size: 35,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '個別にサイン',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 30,
                                color: Colors.black),
                          ),
                        )),
                  ]),
            ),
          ),
        )),
      ),*/
      Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: Container(
            child: Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<ListScoutView>(
                          builder: (BuildContext context) {
                            return ListScoutView();
                          }));},
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 30),
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
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute<InviteView>(
                      builder: (BuildContext context) {
                        return InviteView();
                      }));},
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
                                fontSize: 30,),
                          ),
                        )),
                  ]),
            ),
          ),
        )),
      ),
      /*Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 20),
        child: Container(
            child: Card(
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.blue[900],
                      size: 35,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '一括サイン',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 30,
                                color: Colors.black),
                          ),
                        )),
                  ]),
            ),
          ),
        )),
      ),*/
    ]);
  }
}

class HomeLeaderView2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      StreamBuilder<QuerySnapshot>(
          stream: getTaskSnapshot(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length != 0) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                      child: Card(
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
          }),
      Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Container(
            child: Card(
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.blue[900],
                      size: 35,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '個別にサイン',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 30,
                                color: Colors.black),
                          ),
                        )),
                  ]),
            ),
          ),
        )),
      ),
      /*Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 20),
        child: Container(
            child: Card(
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.blue[900],
                      size: 35,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '一括サイン',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 30,
                                color: Colors.black),
                          ),
                        )),
                  ]),
            ),
          ),
        )),
      ),*/
    ]);
  }
}
