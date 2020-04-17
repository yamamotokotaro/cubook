import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailTaskWaitingView extends StatelessWidget {
  String documentID;
  var task = new Task();
  var theme = new ThemeInfo();

  DetailTaskWaitingView(String _documentID) {
    documentID = _documentID;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DetailTaskWaitingModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('タスク詳細'),
          ),
          body: SingleChildScrollView(child:
              Consumer<DetailTaskWaitingModel>(builder: (context, model, _) {
            if (!model.isGet) {
              model.getTaskSnapshot(documentID);
            }
            if (model.isLoaded) {
              if (!model.taskFinished) {
                DocumentSnapshot snapshot = model.taskSnapshot;
                Map<String, dynamic> map_task =
                    task.getPartMap(snapshot['type'], snapshot['page']);
                return Column(
                  children: <Widget>[
                    Hero(
                        tag: 'detailTask' + documentID,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: theme.getThemeColor(snapshot['type']),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    snapshot['family'] + snapshot['first'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 30,
                                        color: Colors.white),
                                  ),
                                ),
                                Material(
                                    type: MaterialType.transparency,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        theme.getTitle(snapshot['type']) +
                                            ' ' +
                                            map_task['number'] +
                                            ' ' +
                                            map_task['title'] +
                                            ' (' +
                                            (snapshot['number'] + 1)
                                                .toString() +
                                            ')',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 21,
                                            color: Colors.white),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 5, top: 4),
                              child: Icon(
                                Icons.book,
                                color: Theme.of(context).accentColor,
                                size: 32,
                              ),
                            ),
                            Text(
                              '取り組み内容',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                          ])),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot['data'].length,
                            itemBuilder: (BuildContext context, int index) {
                              String type = snapshot['data'][index]['type'];
                              if (type == 'image') {
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    child: Card(
                                      color: Colors.green,
                                      child: Column(
                                        children: <Widget>[
                                          Image.network(model.body[index])
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else if (type == 'video') {
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    child: Card(
                                      child: Column(
                                        children: <Widget>[
                                          Chewie(
                                            controller: model.body[index],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else if (type == 'text') {
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    child: Card(
                                        child: Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                model.body[index],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ))
                                        ],
                                      ),
                                    )),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 5, top: 4),
                              child: Icon(
                                Icons.message,
                                color: Theme.of(context).accentColor,
                                size: 32,
                              ),
                            ),
                            Text(
                              'フィードバック',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                          ])),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        enabled: true,
                        // 入力数
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLengthEnforced: false,
                        onChanged: (text) {
                          model.onTextChanged(text);
                        },
                      ),
                    ),
                    !model.isLoading
                        ? RaisedButton.icon(
                            onPressed: () {
                              model.onTapSend();
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                            color: Theme.of(context).accentColor,
                            label: Text(
                              'サインする',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        : Container(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(),
                            ),
                          ),
                  ],
                );
              } else {
                return Container(
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'タスクが完了しました',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  )),
                );
              }
            } else {
              return Center(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: CircularProgressIndicator()),
              );
            }
          })),
        ));
  }
}
