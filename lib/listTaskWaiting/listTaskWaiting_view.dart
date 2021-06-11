import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailTaskWaiting/detrailTaskWaiting_view.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTaskWaitingView extends StatelessWidget {
  var task = TaskContents();
  var theme = ThemeInfo();

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
                        stream: model.getTaskSnapshot(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshotGet) {
                          if (snapshotGet.hasData) {
                            return ListView.builder(
                                itemCount: snapshotGet.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final DocumentSnapshot snapshot =
                                      snapshotGet.data.docs[index];
                                  final Map<String, dynamic> mapTask =
                                      task.getPartMap(snapshot.get('type'),
                                          snapshot.get('page'));
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Container(
                                      child: Hero(
                                          tag: 'detailTask' +
                                              snapshotGet.data.docs[index].id,
                                          child: SingleChildScrollView(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              color: theme.getThemeColor(
                                                  snapshot.get('type')),
                                              child: InkWell(
                                                customBorder:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute<
                                                              DetailTaskWaitingView_old>(
                                                          builder: (BuildContext
                                                              context) {
                                                    return DetailTaskWaitingView_old(
                                                        snapshotGet.data
                                                            .docs[index].id,
                                                        snapshot.get(
                                                                'family') +
                                                            snapshot.get(
                                                                'first'),
                                                        theme.getTitle(
                                                                snapshot.get(
                                                                    'type')) +
                                                            ' ' +
                                                            mapTask['number'] +
                                                            ' ' +
                                                            mapTask['title'] +
                                                            ' (' +
                                                            task.getNumber(snapshot['type'], snapshot['page'], snapshot['number']) +
                                                            ')',
                                                        snapshot
                                                            .get('type'));
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
                                                              snapshot.get(
                                                                      'family') +
                                                                  snapshot.get(
                                                                      'first'),
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
                                                                          snapshot.get(
                                                                              'type')) +
                                                                      ' ' +
                                                                      mapTask[
                                                                          'number'] +
                                                                      ' ' +
                                                                      mapTask[
                                                                          'title'] +
                                                                      ' (' +
                                                                      task.getNumber(snapshot['type'], snapshot['page'], snapshot['number']) +
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
