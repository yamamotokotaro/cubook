import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailMigrationWaiting/detrailMigrationWaiting_view.dart';
import 'package:cubook/detailTaskWaiting/detrailTaskWaiting_view.dart';
import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ListMigrationWaitingView extends StatelessWidget {
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('移行申請'), systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Consumer<ListTaskWaitingModel>(
                    builder: (BuildContext context, ListTaskWaitingModel model, Widget? child) {
                  model.getSnapshot();
                  if (model.group != null) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('migration')
                            .where('group', isEqualTo: model.group)
                            .where('phase', isEqualTo: 'wait')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshotGet) {
                          if (snapshotGet.hasData) {
                            return ListView.builder(
                                itemCount: snapshotGet.data!.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final DocumentSnapshot snapshot =
                                      snapshotGet.data!.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Container(
                                      child: Hero(
                                          tag: 'detailTask' +
                                              snapshotGet.data!.docs[index].id,
                                          child: SingleChildScrollView(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              color: theme.getThemeColor(
                                                  snapshot.get('age')),
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
                                                    return DetailMigrationWaitingView(
                                                        snapshotGet.data!
                                                            .docs[index].id,
                                                        snapshot.get('name'),
                                                        snapshot.get(
                                                            'groupName_from'),
                                                        snapshot.get('age'));
                                                  }));
                                                },
                                                child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Material(
                                                            type: MaterialType
                                                                .transparency,
                                                            child: Text(
                                                              snapshot
                                                                  .get('name'),
                                                              style: const TextStyle(
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
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                  snapshot.get(
                                                                      'groupName_from'),
                                                                  style: const TextStyle(
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
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator()),
                    );
                  }
                }))));
  }
}
