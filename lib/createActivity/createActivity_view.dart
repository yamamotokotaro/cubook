import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/createActivity/createActivity_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateActivityView extends StatelessWidget {
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    Color? colorRing;
    if (Theme.of(context).colorScheme.secondary == Colors.white) {
      colorRing = Colors.blue[900];
    } else {
      colorRing = Colors.white;
    }
    final bool isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          title: const Text('新規作成'),
        ),
        floatingActionButton: Consumer<CreateActivityModel>(builder:
            (BuildContext context, CreateActivityModel model, Widget? child) {
          if (model.isLoading) {
            return FloatingActionButton(
              onPressed: () {},
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color?>(colorRing),
              ),
            );
          } else {
            return FloatingActionButton.extended(
                onPressed: () {
                  model.onSend(context);
                },
                label: const Text('記録'),
                icon: const Icon(Icons.save));
          }
        }),
        body: Builder(builder: (BuildContext contextBuilder) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scrollbar(
                  child: SingleChildScrollView(
                      child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Consumer<CreateActivityModel>(builder:
                        (BuildContext context, CreateActivityModel model,
                            Widget? child) {
                      model.getGroup();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                                maxLengthEnforcement: MaxLengthEnforcement.none,
                                controller: model.titleController,
                                enabled: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    labelText: '活動タイトルを追加',
                                    hintText: '〇〇ハイク',
                                    errorText: model.EmptyError
                                        ? 'タイトルを入力してください　'
                                        : null)),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    '日付',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).hintColor),
                                    textAlign: TextAlign.left,
                                  ))),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                                width: double.infinity,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      child: Text(
                                        DateFormat('yyyy/MM/dd')
                                            .format(model.date)
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none),
                                      ),
                                      onPressed: () {
                                        model.openTimePicker(
                                            model.date, context);
                                      },
                                    ))),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 10),
                              child: Container(
                                  width: double.infinity,
                                  child: const Text(
                                    '取得項目',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.left,
                                  ))),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 15, left: 10),
                              child: Container(
                                  width: double.infinity,
                                  child: const Text(
                                    '選択した項目は一括でサインされます\n反映までに数分要します',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                    textAlign: TextAlign.left,
                                  ))),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                  onPressed: () {
                                    model.onPressedSelectItem(context);
                                  },
                                  icon: const Icon(Icons.list),
                                  label: const Text('項目を選択'))),
                          Selector<CreateActivityModel,
                              List<Map<String, dynamic>>>(
                            selector: (BuildContext context,
                                    CreateActivityModel model) =>
                                model.list_selected,
                            builder: (BuildContext context,
                                List<Map<String, dynamic>> listSelected,
                                Widget? child) {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: listSelected.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Map<String, dynamic> partSelected =
                                        listSelected[index];
                                    final String? type = partSelected['type'];
                                    final int? page = partSelected['page'];
                                    final int number = partSelected['number'];
                                    final Map<String, dynamic> mapTask =
                                        task.getPartMap(type, page)!;
                                    return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Card(
                                          color: theme.getThemeColor(type),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5, bottom: 5),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          theme.getTitle(
                                                                  type)! +
                                                              ' ' +
                                                              mapTask[
                                                                  'number'] +
                                                              ' ' +
                                                              mapTask['title'] +
                                                              ' (' +
                                                              (number + 1)
                                                                  .toString() +
                                                              ')',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white))
                                                    ],
                                                  ))),
                                        ));
                                  });
                            },
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10),
                                  child: Container(
                                      child: const Text(
                                    '出席者',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.left,
                                  ))),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () {
                                  model.resetUser();
                                },
                                icon: const Icon(
                                  Icons.replay,
                                  size: 20,
                                ),
                                label: const Text(
                                  'リセット',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 70),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('user')
                                    .where('group', isEqualTo: model.group)
                                    .where('position', isEqualTo: 'scout')
                                    .orderBy('team')
                                    .orderBy('age_turn', descending: true)
                                    .orderBy('name')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      final QuerySnapshot querySnapshot =
                                          snapshot.data!;
                                      String? teamLast = '';
                                      return ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: querySnapshot.docs.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String? uid;
                                            final DocumentSnapshot snapshot =
                                                querySnapshot.docs[index];
                                            final Map<String, dynamic>
                                                dataSnapshot = snapshot.data()
                                                    as Map<String, dynamic>;
                                            uid = dataSnapshot['uid'];
                                            if (!model.list_notApplicable
                                                .contains(uid)) {
                                              bool? isCheck = true;
                                              if (model.uid_check[uid] !=
                                                  null) {
                                                isCheck = model.uid_check[uid];
                                              }
                                              String? team;
                                              if (dataSnapshot['team'] is int) {
                                                team = dataSnapshot['team']
                                                    .toString();
                                              } else {
                                                team = dataSnapshot['team'];
                                              }
                                              bool isFirst;
                                              if (teamLast != team) {
                                                isFirst = true;
                                                teamLast = team;
                                              } else {
                                                isFirst = false;
                                              }
                                              final String? grade =
                                                  dataSnapshot['grade'];
                                              String teamCall;
                                              if (grade == 'cub') {
                                                teamCall = '組';
                                              } else {
                                                teamCall = '班';
                                              }
                                              return Column(children: <Widget>[
                                                if (isFirst && team != '')
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            team! + teamCall,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 23,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          )))
                                                else
                                                  Container(),
                                                Dismissible(
                                                    key: Key(
                                                        dataSnapshot['uid']),
                                                    onDismissed:
                                                        (DismissDirection
                                                            direction) {
                                                      model.dismissUser(uid);
                                                      final SnackBar snackBar =
                                                          SnackBar(
                                                        content: Text(snapshot
                                                                .get('name') +
                                                            'を対象外にしました'),
                                                        action: SnackBarAction(
                                                          label: '取り消し',
                                                          textColor: isDark
                                                              ? Colors.blue[900]
                                                              : Colors
                                                                  .blue[400],
                                                          onPressed: () {
                                                            model.cancelDismiss(
                                                                uid);
                                                          },
                                                        ),
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Container(
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: InkWell(
                                                              onTap: () {
                                                                model
                                                                    .onCheckMember(
                                                                        uid);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    /*IconButton(
                                                                  icon: Icon(Icons
                                                                      .clear),
                                                                  onPressed:
                                                                      () {}),*/
                                                                    Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      decoration: BoxDecoration(
                                                                          color: theme.getUserColor(dataSnapshot[
                                                                              'age']),
                                                                          shape:
                                                                              BoxShape.circle),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .get('name'),
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 25),
                                                                        )),
                                                                    const Spacer(),
                                                                    Checkbox(
                                                                      value:
                                                                          isCheck,
                                                                      onChanged:
                                                                          (bool?
                                                                              e) {
                                                                        model.onCheckMember(
                                                                            uid);
                                                                      },
                                                                      activeColor:
                                                                          Colors
                                                                              .blue[600],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )))
                                              ]);
                                            } else {
                                              return Container();
                                            }
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
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Text(
                                                          'スカウトを招待しよう',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
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
                              )),
                        ],
                      );
                    })),
              ))));
        }));
  }
}
