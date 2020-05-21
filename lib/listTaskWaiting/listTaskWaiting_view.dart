import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailTaskWaiting/detrailTaskWaiting_view.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTaskWaitingView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('サイン待ちリスト'),
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Consumer<ListTaskWaitingModel>(
                    builder: (context, model, child) {
                  model.getSnapshot();
                  if (model.group != null) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('task')
                            .where('group', isEqualTo: model.group)
                            .where('phase', isEqualTo: 'wait')
                            .orderBy('date', descending: false)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot_get) {
                          if (snapshot_get.hasData) {
                            return ListView.builder(
                                itemCount: snapshot_get.data.documents.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot snapshot =
                                      snapshot_get.data.documents[index];
                                  Map<String, dynamic> map_task =
                                      task.getPartMap(
                                          snapshot['type'], snapshot['page']);
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Container(
                                      child: Hero(
                                          tag: 'detailTask' +
                                              snapshot_get.data.documents[index]
                                                  .documentID,
                                          child: SingleChildScrollView(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              color: theme.getThemeColor(
                                                  snapshot['type']),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      new MaterialPageRoute<
                                                              DetailTaskWaitingView>(
                                                          builder: (BuildContext
                                                              context) {
                                                    return DetailTaskWaitingView(
                                                        snapshot_get
                                                            .data
                                                            .documents[index]
                                                            .documentID,
                                                        snapshot['family'] +
                                                            snapshot['first'],
                                                        theme.getTitle(snapshot[
                                                                'type']) +
                                                            ' ' +
                                                            map_task['number'] +
                                                            ' ' +
                                                            map_task['title'] +
                                                            ' (' +
                                                            (snapshot['number'] +
                                                                    1)
                                                                .toString() +
                                                            ')',
                                                        snapshot['type']);
                                                  }));
                                                },
                                                child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Material(
                                                            type: MaterialType
                                                                .transparency,
                                                            child: Text(
                                                              snapshot[
                                                                      'family'] +
                                                                  snapshot[
                                                                      'first'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 25,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          Material(
                                                              type: MaterialType
                                                                  .transparency,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                  theme.getTitle(
                                                                          snapshot[
                                                                              'type']) +
                                                                      ' ' +
                                                                      map_task[
                                                                          'number'] +
                                                                      ' ' +
                                                                      map_task[
                                                                          'title'] +
                                                                      ' (' +
                                                                      (snapshot['number'] +
                                                                              1)
                                                                          .toString() +
                                                                      ')',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ))
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          )),
                                    ),
                                  );
                                });
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
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator()),
                    );
                  }
                }))));
  }
}
