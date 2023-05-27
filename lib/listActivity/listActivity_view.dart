import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/listActivity/listActivity_model.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListActivityView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録一覧'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/createActivity');
        },
        label: const Text('新規作成'),
        icon: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Consumer<ListActivityModel>(builder:
                      (BuildContext context, ListActivityModel model,
                          Widget? child) {
                    model.getGroup();
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('activity')
                          .where('group', isEqualTo: model.group)
                          .orderBy('date', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            final QuerySnapshot querySnapshot = snapshot.data!;
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: querySnapshot.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final DocumentSnapshot snapshot =
                                      querySnapshot.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      child: Card(
                                        child: InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          onTap: () async {
                                            final Map<String, dynamic>
                                                documentData = snapshot.data()
                                                    as Map<String, dynamic>;
                                            if (documentData['type'] ==
                                                'migration') {
                                              await showDialog<int>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                      content:
                                                          SingleChildScrollView(
                                                              child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            child: const Text(
                                                                'この活動は表示できません',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18)),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .only(top: 5),
                                                              child: Text(
                                                                  '選択された活動は移行元で記録されたものです。移行元の活動詳細は表示することができません。'))
                                                        ],
                                                      )),
                                                    );
                                                  });
                                            } else {
                                              Navigator.of(context).pushNamed(
                                                  '/detailActivity',
                                                  arguments: snapshot.id);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3, bottom: 8),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          snapshot.get('title'),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 23),
                                                        ))),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3, top: 5),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          DateFormat(
                                                                  'yyyy/MM/dd')
                                                              .format(snapshot
                                                                  .get('date')
                                                                  .toDate())
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17),
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
                                            padding: EdgeInsets.only(left: 10),
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: Text(
                                                '記録はまだありません',
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
                  }))
            ],
          ),
        ),
      )),
    );
  }
}
