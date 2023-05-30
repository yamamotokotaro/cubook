import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/analyticsTaskList/analyticsTaskListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsTaskListView extends StatelessWidget {
  AnalyticsTaskListView(String _type) {
    themeColor = theme.getThemeColor(_type);
    title = theme.getTitle(_type);
    if (_type == 'usagi') {
      typeFireStore = 'step';
    } else if (_type == 'challenge') {
      typeFireStore = 'challenge';
    }
    type = _type;
  }
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  Color? themeColor;
  String? type;
  String? typeFireStore;
  String? title = '';

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = ColorScheme.fromSeed(
        seedColor: themeColor!,
        brightness: MediaQuery.of(context).platformBrightness);
    final List<Map<String, dynamic>>? mapTask = task.getAllMap(type);
    final bool isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
            child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Consumer<AnalyticsTaskListModel>(builder:
                        (BuildContext context, AnalyticsTaskListModel model,
                            Widget? child) {
                      model.getGroup();
                      if (model.group != null) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: model.getUserSnapshot(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                int userCount = 0;
                                final List<DocumentSnapshot> listSnapshot =
                                    snapshot.data!.docs;
                                final List<String?> listUid = <String?>[];
                                if (type == 'challenge' ||
                                    type == 'gino' ||
                                    type == 'syorei') {
                                  userCount = listSnapshot.length;
                                  for (DocumentSnapshot documentSnapshot
                                      in listSnapshot) {
                                    listUid.add(documentSnapshot.get('uid'));
                                  }
                                } else if (type == 'tukinowa') {
                                  for (DocumentSnapshot documentSnapshot
                                      in listSnapshot) {
                                    if (documentSnapshot.get('age') == 'kuma') {
                                      userCount++;
                                      listUid.add(documentSnapshot.get('uid'));
                                    }
                                  }
                                } else {
                                  for (DocumentSnapshot documentSnapshot
                                      in listSnapshot) {
                                    if (documentSnapshot.get('age') == type) {
                                      userCount++;
                                      listUid.add(documentSnapshot.get('uid'));
                                    }
                                  }
                                }
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: mapTask!.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Container(
                                            child: Card(
                                              color: scheme.surface,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: InkWell(
                                                customBorder:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/taskDetailAnalytics',
                                                          arguments: TaskDetail(
                                                              type: type,
                                                              page: index));
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                            color: themeColor),
                                                        height: 120,
                                                        child: ConstrainedBox(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  minWidth: 76),
                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              child: Text(
                                                                mapTask[index]
                                                                    ['number'],
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        30,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      mapTask[index]
                                                                          [
                                                                          'title'],
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              25),
                                                                    ))),
                                                            StreamBuilder<
                                                                    QuerySnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        type!)
                                                                    .where(
                                                                        'group',
                                                                        isEqualTo:
                                                                            model
                                                                                .group)
                                                                    .where(
                                                                        'page',
                                                                        isEqualTo:
                                                                            index)
                                                                    .orderBy(
                                                                        'end')
                                                                    .snapshots(),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            QuerySnapshot>
                                                                        snapshotTask) {
                                                                  if (snapshotTask
                                                                      .hasData) {
                                                                    int itemCount =
                                                                        0;
                                                                    final List<
                                                                            DocumentSnapshot>
                                                                        listSnapshot =
                                                                        snapshotTask
                                                                            .data!
                                                                            .docs;
                                                                    for (DocumentSnapshot documentSnapshot
                                                                        in listSnapshot) {
                                                                      if (listUid
                                                                          .contains(
                                                                              documentSnapshot.get('uid'))) {
                                                                        itemCount++;
                                                                      }
                                                                    }
                                                                    return Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                15),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Padding(
                                                                                padding: const EdgeInsets.only(left: 5, right: 10),
                                                                                child: Container(
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                    child: CircularProgressIndicator(
                                                                                      backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                                                                                      valueColor: AlwaysStoppedAnimation<Color?>(isDark ? Colors.white : theme.getThemeColor(type)),
                                                                                      value: userCount == 0 ? 0 : itemCount / userCount,
                                                                                    ))),
                                                                            Text('完修者 ' + itemCount.toString() + '/' + userCount.toString(),
                                                                                style: const TextStyle(fontSize: 17)),
                                                                          ],
                                                                        ));
                                                                  } else {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              10),
                                                                      child: Container(
                                                                          height: 30,
                                                                          width: 30,
                                                                          child: CircularProgressIndicator(
                                                                            backgroundColor: isDark
                                                                                ? Colors.grey[700]
                                                                                : Colors.grey[300],
                                                                            valueColor: AlwaysStoppedAnimation<Color?>(isDark
                                                                                ? Colors.white
                                                                                : theme.getThemeColor(type)),
                                                                          )),
                                                                    );
                                                                  }
                                                                })
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                    });
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        backgroundColor: isDark
                                            ? Colors.grey[700]
                                            : Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color?>(
                                                isDark
                                                    ? Colors.white
                                                    : theme
                                                        .getThemeColor(type)),
                                      )),
                                );
                              }
                            });
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5, right: 10),
                          child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                backgroundColor: isDark
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color?>(
                                    isDark
                                        ? Colors.white
                                        : theme.getThemeColor(type)),
                              )),
                        );
                      }
                    }))
              ]),
            ),
          ),
        )),
      ),
    );
  }
}
