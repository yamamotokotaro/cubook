import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/notification/notification_model.dart';
import 'package:cubook/scoutTaskDetail/scoutTaskOverview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お知らせ'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Consumer<NotificationModel>(builder:
                        (BuildContext context, NotificationModel model,
                            Widget? child) {
                      model.getUser();
                      if (model.uid != null) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('notification')
                              .where('uid', isEqualTo: model.uid)
                              .orderBy('time', descending: true)
                              .limit(50)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isNotEmpty) {
                                final QuerySnapshot querySnapshot =
                                    snapshot.data!;
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: querySnapshot.docs.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final DocumentSnapshot snapshot =
                                          querySnapshot.docs[index];
                                      final String? type = snapshot.get('type');
                                      final int? page = snapshot.get('page');
                                      final int? number =
                                          snapshot.get('number');
                                      final Color? color = theme
                                          .getThemeColor(snapshot.get('type'));
                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          child: Card(
                                            color: color,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: InkWell(
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push<dynamic>(MyPageRoute(
                                                        page: showTaskView(page,
                                                            type, number! + 1),
                                                        dismissible: true));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 3,
                                                                bottom: 8),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              snapshot
                                                                  .get('body'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3,
                                                                top: 5),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              DateFormat(
                                                                      'yyyy/MM/dd hh:mm')
                                                                  .format(snapshot
                                                                      .get(
                                                                          'time')
                                                                      .toDate())
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 10, right: 10),
                                  child: Container(
                                      child: InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.bubble_chart,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 35,
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: Text(
                                                    'お知らせはまだありません',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
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
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
