import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class listEffort extends StatelessWidget {
  String group;

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
        Consumer<ListEffortModel>(builder: (context, model, child) {
          model.getSnapshot();
          if (model.group != null) {
            return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('effort')
                  .where('group', isEqualTo: model.group)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> listSnapshot =
                      snapshot.data.documents;
                  if (listSnapshot.length != 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                          itemCount: listSnapshot.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot documentSnapshot =
                                listSnapshot[index];
                            final String body = documentSnapshot['family'] +
                                documentSnapshot['first'] +
                                documentSnapshot['call'] +
                                'が' +
                                documentSnapshot['body'];
                            final int congrats = documentSnapshot['congrats'];
                            final String documentID =
                                documentSnapshot.documentID;
                            Color color;
                            if (documentSnapshot['type'] == 'usagi') {
                              color = Colors.orange;
                            } else if (documentSnapshot['type'] == 'sika') {
                              color = Colors.green;
                            } else if (documentSnapshot['type'] == 'kuma') {
                              color = Colors.blue;
                            } else if (documentSnapshot['type'] ==
                                'challenge') {
                              color = Colors.green[900];
                            }
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                child: Card(
                                  color: color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 11, right: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  //ああああ
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, bottom: 3),
                                                  child: Text(
                                                    documentSnapshot['family'] +
                                                        documentSnapshot[
                                                            'first'] +
                                                        documentSnapshot[
                                                            'call'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(DateFormat(
                                                    'MM/dd')
                                                    .format(documentSnapshot[
                                                'time']
                                                    .toDate())
                                                    .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.5,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      decoration:
                                                      TextDecoration
                                                          .none),)
                                              ],
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10, right: 10),
                                            child: Text(
                                              documentSnapshot['body'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 2),
                                          child: Row(
                                            children: <Widget>[
                                              FlatButton.icon(
                                                onPressed: () {
                                                  increaseCount(documentID);
                                                },
                                                icon: Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  'おめでとう！' +
                                                      congrats.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Spacer(),
                                              model.position == 'leader'
                                                  ? IconButton(
                                                      onPressed: () async {
                                                        var result =
                                                            await showModalBottomSheet<
                                                                int>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    ListTile(
                                                                      leading: Icon(
                                                                          Icons
                                                                              .delete),
                                                                      title: Text(
                                                                          '投稿を削除する'),
                                                                      onTap:
                                                                          () {
                                                                        model.deleteEffort(
                                                                            documentID);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ));
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        color: Colors.white,
                                                        size: 21,
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ))
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
                                  color: Theme.of(context).accentColor,
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
                                        ),
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
              },
            );
          } else {
            return const Center(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator()),
            );
          }
        }),
      ],
    );
  }

  void increaseCount(String documentID) async {
    Firestore.instance
        .collection('effort')
        .document(documentID)
        .updateData(<String, dynamic>{'congrats': FieldValue.increment(1)});
  }
}
