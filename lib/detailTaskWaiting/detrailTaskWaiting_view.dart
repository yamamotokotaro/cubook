import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailTaskWaitingView_old extends StatelessWidget {
  String documentID;
  String name;
  String item;
  String type;
  var task = new Task();
  var theme = new ThemeInfo();

  DetailTaskWaitingView_old(
      String _documentID, String _name, String _item, String _type) {
    documentID = _documentID;
    name = _name;
    item = _item;
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DetailTaskWaitingModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('タスク詳細'),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              Hero(
                  tag: 'detailTask' + documentID,
                  child: SingleChildScrollView(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: theme.getThemeColor(type),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Material(
                            type: MaterialType.transparency,
                            child: Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 28,
                                  color: Colors.white),
                            ),
                          ),
                          Material(
                              type: MaterialType.transparency,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 21,
                                      color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ))),
              Consumer<DetailTaskWaitingModel>(builder: (context, model, _) {
                if (!model.isGet) {
                  model.getTaskSnapshot(documentID);
                }
                if (model.isLoaded) {
                  if (model.taskSnapshot.data['phase'] == 'wait') {
                    DocumentSnapshot snapshot = model.taskSnapshot;
                    Map<String, dynamic> map_task =
                        task.getPartMap(snapshot['type'], snapshot['page']);
                    return Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                            child: FlatButton.icon(
                              onPressed: () async {
                                var result = await showModalBottomSheet<int>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.all(0),
                                                child: Container(
                                                  width: double.infinity,
                                                  child:
                                                  Text(
                                                    task.getContent(
                                                        type, model.page, model.number),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                )),
                                            Padding(
                                                padding: EdgeInsets.all(0),
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                    '\n©︎2020 公益財団法人ボーイスカウト日本連盟',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                )),
                                          ],
                                        ));
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.book,
                                size: 20,
                              ),
                              label: Text(
                                '内容を見る',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,),
                              ),
                            )),
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 800),
                            child: Column(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Center(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 5, top: 4),
                                        child: Icon(
                                          Icons.book,
                                          color: Theme.of(context).accentColor,
                                          size: 32,
                                        ),
                                      ),
                                      Text(
                                        '取り組み内容',
                                        style: TextStyle(
                                            fontSize: 25.0,fontWeight: FontWeight.bold),
                                      ),
                                    ])),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot['data'].length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String type =
                                            snapshot['data'][index]['type'];
                                        if (type == 'image') {
                                          return Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.network(
                                                      model.body[index])
                                                ],
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
                                                      controller:
                                                          model.body[index],
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
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          model.body[index],
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 5, top: 4),
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
                                  decoration: InputDecoration(
                                      labelText: "フィードバックを入力",
                                      errorText: model.EmptyError
                                          ? 'フィードバックを入力してください'
                                          : null),
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
                                      color: Colors.blue[900],
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
                              !model.isLoading
                                  ? FlatButton.icon(
                                      onPressed: () {
                                        model.onTapReject();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      label: Text(
                                        'やりなおし',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    )
                                  : Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Center(),
                                      ),
                                    ),
                            ]))
                      ],
                    );
                  } else {
                    return Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5, top: 4),
                                child: Icon(
                                  Icons.check,
                                  color: Theme.of(context).accentColor,
                                  size: 32,
                                ),
                              ),
                              Text(
                                'このタスクは完了しました',
                                style: TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            ])));
                  }
                } else {
                  return Center(
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator()),
                  );
                }
              })
            ],
          ))),
        ));
  }
}

class DetailTaskWaitingView extends StatelessWidget {
  String documentID;
  String name;
  String item;
  String type;
  var task = new Task();
  var theme = new ThemeInfo();

  DetailTaskWaitingView(
      String _documentID, String _name, String _item, String _type) {
    documentID = _documentID;
    name = _name;
    item = _item;
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('取り組み内容'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: <Widget>[
          Hero(
              tag: 'detailTask' + documentID,
              child: SingleChildScrollView(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                color: theme.getThemeColor(type),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 28,
                              color: Colors.white),
                        ),
                      ),
                      Material(
                          type: MaterialType.transparency,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              item,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 21,
                                  color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                ),
              ))),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('task')
                    .document(documentID)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Container();
                  }
                  if (asyncSnapshot.hasData) {
                    return Consumer<DetailTaskWaitingModel>(
                        builder: (context, model, _) {
                      DocumentSnapshot snapshot = asyncSnapshot.data;
                      model.onSnapshotHasData(snapshot);
                      if (snapshot.data['phase'] == 'wait') {
                        print('kiteru');
                        if (model.body.length != 0) {
                          print('Map hasData');
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Center(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 5, top: 4),
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String type =
                                            snapshot['data'][index]['type'];
                                        if (type == 'image') {
                                          return Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Container(
                                              child: Card(
                                                color: Colors.green,
                                                child: Column(
                                                  children: <Widget>[
                                                    Image.network(
                                                        model.body[index])
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
                                                      controller:
                                                          model.body[index],
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
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          model.body[index],
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 5, top: 4),
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
                                  decoration: InputDecoration(
                                      labelText: "フィードバックを入力",
                                      errorText: model.EmptyError
                                          ? 'フィードバックを入力してください'
                                          : null),
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
                                      color: Colors.blue[900],
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
                              !model.isLoading
                                  ? FlatButton.icon(
                                      onPressed: () {
                                        model.onTapReject();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      label: Text(
                                        'やりなおし',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
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
                          return Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: CircularProgressIndicator()),
                          );
                        }
                      } else {
                        return Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 5, top: 4),
                                    child: Icon(
                                      Icons.check,
                                      color: Theme.of(context).accentColor,
                                      size: 32,
                                    ),
                                  ),
                                  Text(
                                    'このタスクは完了しました',
                                    style: TextStyle(
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none),
                                  ),
                                ])));
                      }
                    });
                  } else {
                    return Center(
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator()),
                    );
                  }
                },
              ))
        ],
      ))),
    );
  }
}
