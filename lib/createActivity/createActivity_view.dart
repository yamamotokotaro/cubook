import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/createActivity/createActivity_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateActivityView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    Color color_ring;
    if(Theme.of(context).accentColor == Colors.white){
      color_ring = Colors.blue[900];
    } else {
      color_ring = Colors.white;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('新規作成'),
        ),
        floatingActionButton:
            Consumer<CreateActivityModel>(builder: (context, model, child) {
          if (model.isLoading) {
            return FloatingActionButton(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(color_ring ),
              ),
            );
          } else {
            return FloatingActionButton.extended(
              onPressed: () {
                model.onSend(context);
              },
              label: Text('記録'),
              icon: Icon(Icons.save)
            );
          }
        }),
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                  child: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Consumer<CreateActivityModel>(
                        builder: (context, model, child) {
                      model.getAdmob(context);
                      model.getGroup();
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                                controller: model.titleController,
                                enabled: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLengthEnforced: false,
                                decoration: InputDecoration(
                                    labelText: "活動タイトルを追加",
                                    hintText: '〇〇ハイク',
                                    errorText: model.EmptyError
                                        ? 'タイトルを入力してください　'
                                        : null)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10, left: 10),
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
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                                width: double.infinity,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FlatButton(
                                      child: Text(
                                        DateFormat('yyyy/MM/dd')
                                            .format(model.date)
                                            .toString(),
                                        style: TextStyle(
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
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 10),
                              child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    '取得項目',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.left,
                                  ))),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 15, left: 10),
                              child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    '選択した項目は一括でサインされます',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12
                                    ),
                                    textAlign: TextAlign.left,
                                  ))),
                          Align(
                            alignment: Alignment.centerLeft,
                          child:FlatButton.icon(
                              onPressed: () {
                                model.onPressedSelectItem(context);
                              },
                              icon: Icon(Icons.list),
                              label: Text('項目を選択'))),
                          Selector<CreateActivityModel,
                              List<Map<String, dynamic>>>(
                            selector: (context, model) => model.list_selected,
                            builder: (context, list_selected, child) {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: list_selected.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Map<String, dynamic> part_selected =
                                        list_selected[index];
                                    String type = part_selected['type'];
                                    int page = part_selected['page'];
                                    int number = part_selected['number'];
                                    Map<String, dynamic> map_task =
                                        task.getPartMap(type, page);
                                    return Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Card(
                                          color: theme.getThemeColor(type),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          theme.getTitle(type) +
                                                              ' ' +
                                                              (page + 1)
                                                                  .toString() +
                                                              ' ' +
                                                              map_task[
                                                                  'title'] +
                                                              ' (' +
                                                              (number + 1)
                                                                  .toString() +
                                                              ')',
                                                          style: TextStyle(
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
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 10),
                              child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    '出席者',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.left,
                                  ))),
                          Padding(
                              padding: EdgeInsets.only(bottom: 70),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
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
                                    if (snapshot.data.documents.length != 0) {
                                      QuerySnapshot querySnapshot =
                                          snapshot.data;
                                      String team_last = '';
                                      return ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              querySnapshot.documents.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String uid;
                                            DocumentSnapshot snapshot =
                                                querySnapshot.documents[index];
                                            uid = snapshot['uid'];
                                            bool isCheck = true;
                                            if (model.uid_check[uid] != null) {
                                              isCheck = model.uid_check[uid];
                                            }
                                            String team;
                                            if (snapshot['team'] is int) {
                                              team =
                                                  snapshot['team'].toString();
                                            } else {
                                              team = snapshot['team'];
                                            }
                                            bool isFirst;
                                            if (team_last != team) {
                                              isFirst = true;
                                              team_last = team;
                                            } else {
                                              isFirst = false;
                                            }
                                            String grade = snapshot['grade'];
                                            String team_call;
                                            if (grade == 'cub') {
                                              team_call = '組';
                                            } else {
                                              team_call = '班';
                                            }
                                            print(model.uid_check);
                                            return Column(children: <Widget>[
                                              isFirst && team != ''
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            team + team_call,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 23,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          )))
                                                  : Container(),
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          model.onCheckMember(
                                                              uid);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: theme.getUserColor(
                                                                        snapshot[
                                                                            'age']),
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                    snapshot[
                                                                        'name'],
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            25),
                                                                  )),
                                                              Spacer(),
                                                              Checkbox(
                                                                value: isCheck,
                                                                onChanged:
                                                                    (bool e) {
                                                                  model
                                                                      .onCheckMember(
                                                                          uid);
                                                                },
                                                                activeColor:
                                                                    Colors.blue[
                                                                        600],
                                                              )
                                                              /*Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                snapshot['team']
                                                                        .toString() +
                                                                    '組',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                              ))*/
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                            ]);
                                          });
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, left: 10, right: 10),
                                        child: Container(
                                            child: InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.bubble_chart,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    size: 35,
                                                  ),
                                                  Padding(
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
              )));
        }));
  }
}
