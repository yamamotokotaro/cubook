import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_model.dart';

class listEffort extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5, top: 4),
                child: Icon(
                  //ああああ
                  Icons.assignment,
                  color: Theme.of(context).accentColor,
                  size: 32,
                ),
              ),
              Text(
                'みんなの取り組み',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ])),
        Consumer<ListEffortModel>(builder:
            (BuildContext context, ListEffortModel model, Widget child) {
          if (!model.isGet) {
            model.getSnapshot();
          }

          if (model.effortSnapshot != null) {
            final List<DocumentSnapshot> listSnapshot =
                model.effortSnapshot.documents;
            if (listSnapshot.length != 0) {
              return Padding(
                padding: const EdgeInsets.all(0),
                child: ListView.builder(
                    itemCount: listSnapshot.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot documentSnapshot = listSnapshot[index];
                      final String body = documentSnapshot['family'] +
                          documentSnapshot['first'] +
                          documentSnapshot['call'] +
                          'が' +
                          documentSnapshot['body'];
                      final int congrats = documentSnapshot['congrats'];
                      final String documentID = documentSnapshot.documentID;
                      Color color;
                      if (documentSnapshot['type'] == 'usagi') {
                        color = Colors.orange;
                      } else if (documentSnapshot['type'] == 'sika') {
                        color = Colors.green;
                      } else if (documentSnapshot['type'] == 'kuma') {
                        color = Colors.blue;
                      } else if (documentSnapshot['type'] == 'challenge') {
                        color = Colors.green[900];
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 90,
                                  color: color,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Text(
                                      body,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                ),
                                FlatButton.icon(
                                    onPressed: () {
                                      model.increaseCount(documentID);
                                    },
                                    icon: Icon(Icons.favorite_border),
                                    label: Text('おめでとう！' + congrats.toString()))
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Container(
                    child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.bubble_chart,
                            color: Colors.blue[900],
                            size: 35,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  'まだありません',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                              )),
                        ]),
                  ),
                )),
              );
            }
          } else {
            return const Center(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator()),
            );
          }
        })
      ],
    );
  }
}
