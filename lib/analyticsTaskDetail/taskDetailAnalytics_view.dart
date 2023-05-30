import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/analyticsTaskDetail/taskDetailAnalytics_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsTaskDetailView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();
  TaskContents task = TaskContents();

  @override
  Widget build(BuildContext context) {
    final TaskDetail info =
        ModalRoute.of(context)!.settings.arguments as TaskDetail;
    final String? type = info.type;
    final int? page = info.page;
    final Color? themeColor = theme.getThemeColor(type);
    final List<Map<String, dynamic>>? contents =
        task.getContentList(type, page);
    final Map<String, dynamic> mapTask = task.getPartMap(type, page)!;
    final bool isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final ColorScheme scheme = ColorScheme.fromSeed(
        seedColor: themeColor!,
        brightness: MediaQuery.of(context).platformBrightness);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          mapTask['title'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: themeColor,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Consumer<AnalyticsTaskDetailModel>(builder:
                      (BuildContext context, AnalyticsTaskDetailModel model,
                          Widget? child) {
                    model.getGroup();
                    if (model.group != null) {
                      return Column(
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                              stream: model.getUserSnapshot(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  int userCount = 0;
                                  final List<DocumentSnapshot> listSnapshot =
                                      snapshot.data!.docs;
                                  final List<String?> listUid = <String?>[];
                                  if (type == 'challenge' || type == 'gino') {
                                    userCount = listSnapshot.length;
                                    for (DocumentSnapshot documentSnapshot
                                        in listSnapshot) {
                                      listUid.add(documentSnapshot.get('uid'));
                                    }
                                  } else if (type == 'tukinowa') {
                                    for (DocumentSnapshot documentSnapshot
                                        in listSnapshot) {
                                      if (documentSnapshot.get('age') ==
                                          'kuma') {
                                        userCount++;
                                        listUid
                                            .add(documentSnapshot.get('uid'));
                                      }
                                    }
                                  } else {
                                    for (DocumentSnapshot documentSnapshot
                                        in listSnapshot) {
                                      if (documentSnapshot.get('age') == type) {
                                        userCount++;
                                        listUid
                                            .add(documentSnapshot.get('uid'));
                                      }
                                    }
                                  }
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection(type!)
                                        .where('group', isEqualTo: model.group)
                                        .where('page', isEqualTo: page)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshotTask) {
                                      if (snapshotTask.hasData) {
                                        final int quant = task.getPartMap(
                                            type, page)!['hasItem'];
                                        final List<DocumentSnapshot>
                                            listDocumentSnapshot =
                                            snapshotTask.data!.docs;
                                        final List<int> countItem =
                                            List<int>.generate(
                                                quant, (int index) => 0);
                                        int countEnd = 0;
                                        for (DocumentSnapshot documentSnapshot
                                            in listDocumentSnapshot) {
                                          final Map<String, dynamic>?
                                              documentData =
                                              documentSnapshot.data()
                                                  as Map<String, dynamic>?;
                                          if (listUid.contains(
                                              documentSnapshot.get('uid'))) {
                                            if (documentData!['end'] != null) {
                                              countEnd++;
                                            }
                                          }
                                          final Map<dynamic, dynamic>? signed =
                                              documentSnapshot.get('signed');
                                          for (int i = 0; i < quant; i++) {
                                            final Map<dynamic, dynamic>?
                                                signedPart =
                                                signed![i.toString()];
                                            if (signedPart != null) {
                                              if (signedPart['phaze'] ==
                                                      'signed' &&
                                                  listUid.contains(
                                                      documentSnapshot
                                                          .get('uid'))) {
                                                countItem[i]++;
                                              }
                                            }
                                          }
                                        }
                                        return Column(children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Card(
                                                color: scheme.surface,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).pushNamed(
                                                          '/taskDetailAnalyticsMember',
                                                          arguments:
                                                              TaskDetailMember(
                                                                  type: type,
                                                                  page: page,
                                                                  phase:
                                                                      'end'));
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15,
                                                                    bottom: 15,
                                                                    left: 10,
                                                                    right: 10),
                                                            child:
                                                                CircularProgressIndicator(
                                                              backgroundColor: isDark
                                                                  ? Colors
                                                                      .grey[700]
                                                                  : Colors.grey[
                                                                      300],
                                                              valueColor: AlwaysStoppedAnimation<
                                                                      Color?>(
                                                                  isDark
                                                                      ? Colors
                                                                          .white
                                                                      : theme.getThemeColor(
                                                                          type)),
                                                              value: userCount ==
                                                                      0
                                                                  ? 0
                                                                  : countEnd /
                                                                      userCount,
                                                            )),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(
                                                                          '完修者 ' +
                                                                              countEnd.toString() +
                                                                              '/' +
                                                                              userCount.toString(),
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 23),
                                                                        ))),
                                                              ],
                                                            )),
                                                      ],
                                                    )), /*child: Text(countItem[
                                                                        index]
                                                                    .toString() +
                                                                '/' +
                                                                userCount
                                                                    .toString())*/
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 17),
                                              child: Container(
                                                  width: double.infinity,
                                                  child: const Text(
                                                    '細目ごとのサイン数',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                          ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: quant,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Card(
                                                      color: scheme.surface,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).pushNamed(
                                                                '/taskDetailAnalyticsMember',
                                                                arguments: TaskDetailMember(
                                                                    type: type,
                                                                    page: page,
                                                                    phase:
                                                                        'number',
                                                                    number:
                                                                        index));
                                                          },
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: const BorderRadius
                                                                              .only(
                                                                          topLeft: Radius.circular(
                                                                              10),
                                                                          bottomLeft: Radius.circular(
                                                                              10)),
                                                                      color:
                                                                          themeColor),
                                                                  height: 65,
                                                                  child:
                                                                      ConstrainedBox(
                                                                    constraints:
                                                                        const BoxConstraints(
                                                                            minWidth:
                                                                                60),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(0),
                                                                        child:
                                                                            Text(
                                                                          (index + 1)
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 30,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 10),
                                                                          child: Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                'サイン済み ' + countItem[index].toString() + '/' + userCount.toString(),
                                                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                              ))),
                                                                      Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 10,
                                                                              bottom: 12,
                                                                              left: 5),
                                                                          child: Container(
                                                                              width: 200,
                                                                              child: LinearProgressIndicator(
                                                                                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                                                                                valueColor: AlwaysStoppedAnimation<Color?>(isDark ? Colors.white : theme.getThemeColor(type)),
                                                                                value: userCount == 0 ? 0 : countItem[index] / userCount,
                                                                              )))
                                                                    ],
                                                                  )),
                                                            ],
                                                          )), /*child: Text(countItem[
                                                                        index]
                                                                    .toString() +
                                                                '/' +
                                                                userCount
                                                                    .toString())*/
                                                    ));
                                              })
                                        ]);
                                      } else {
                                        return const Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child:
                                                  CircularProgressIndicator()),
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
                          Padding(
                              padding: const EdgeInsets.only(top: 5, left: 17),
                              child: Container(
                                  width: double.infinity,
                                  child: const Text(
                                    '細目',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ))),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: contents!.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String content =
                                        contents[index]['body'];
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, right: 5, left: 5),
                                        child: Card(
                                          color: const Color(0x00000000),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 0,
                                          child: InkWell(
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Semantics(
                                                    label: 'さいもく' +
                                                        (index + 1).toString() +
                                                        '、',
                                                    child: Text(content)),
                                              )),
                                        ));
                                  })),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, bottom: 10, right: 15),
                              child: Container(
                                width: double.infinity,
                                child: const Text(
                                  '\n公財ボーイスカウト日本連盟「令和2年版 諸規定」',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: CircularProgressIndicator()),
                      );
                    }
                  }))
            ],
          ),
        ),
      )),
    );
  }
}
