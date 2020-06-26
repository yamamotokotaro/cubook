import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/createActivity/createActivity_model.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateActivityView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新規作成'),
        ),
        floatingActionButton:
            Consumer<CreateActivityModel>(builder: (context, model, child) {
          return FloatingActionButton.extended(
            onPressed: () {
              model.onSend(context);
            },
            label: Text('記録'),
            icon: Icon(Icons.save),
          );
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
                                      int team_last = 0;
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
                                            bool isFirst;
                                            if (team_last != snapshot['team']) {
                                              isFirst = true;
                                              team_last = snapshot['team'];
                                            } else {
                                              isFirst = false;
                                            }
                                            print(model.uid_check);
                                            return Column(children: <Widget>[
                                              isFirst
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            snapshot['team']
                                                                    .toString() +
                                                                '組',
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
                                                                    color: theme.getThemeColor(
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
                                      return Container();
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
                          /*Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: model.isLoading
                                    ? Padding(
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator())
                                    : RaisedButton(
                                    color: Colors.blue[900],
                                    onPressed: () {
                                      //model.inviteRequest(context);
                                    },
                                    child: Text(
                                      '招待を送信',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )*/
                        ],
                      );
                    })),
              )));
        }));
  }
}
