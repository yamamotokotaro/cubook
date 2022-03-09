import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/detailTaskWaiting/detailTaskWaiting_model.dart';
import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DetailTaskWaitingView_old extends StatelessWidget {
  String documentID;
  String name;
  String item;
  String type;
  Map<String, dynamic> taskInfo;
  Map<String, dynamic> content;
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

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
        create: (BuildContext context) => DetailTaskWaitingModel(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('タスク詳細'), systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: SafeArea(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
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
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 28,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Material(
                                      type: MaterialType.transparency,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 21,
                                              color: Colors.white),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ))),
                      Consumer<DetailTaskWaitingModel>(
                          builder: (BuildContext context, DetailTaskWaitingModel model, _) {
                        if (!model.isGet) {
                          model.getTaskSnapshot(documentID);
                        }
                        if (model.isLoaded) {
                          if (model.taskSnapshot.get('phase') == 'wait') {
                            content =
                                task.getContent(type, model.page, model.number);
                            if (content['common'] != null) {
                              taskInfo = task.getPartMap(
                                  content['common']['type'],
                                  content['common']['page']);
                            }
                            final DocumentSnapshot snapshot = model.taskSnapshot;
                            final Map<String, dynamic> mapTask = task.getPartMap(
                                snapshot.get('type'),
                                snapshot.get('page'));
                            return Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, right: 20),
                                        child: FlatButton(
                                            onPressed: () async {
                                              final int result =
                                                  await showModalBottomSheet<
                                                      int>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(15),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                child: Text(
                                                                  task.getContent(
                                                                      type,
                                                                      model
                                                                          .page,
                                                                      model
                                                                          .number)['body'],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              )),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                child: const Text(
                                                                  '\n公財ボーイスカウト日本連盟「令和2年版 諸規定」',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              )),
                                                        ],
                                                      ));
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: const <Widget>[
                                                  Icon(Icons.sort),
                                                  Text('細目',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                            ))),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, right: 20),
                                        child: FlatButton(
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .push<dynamic>(MyPageRoute(
                                                      page: showTaskConfirmView(
                                                          model.page,
                                                          type,
                                                          model.uid_get,
                                                          0),
                                                      dismissible: true));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: const <Widget>[
                                                  Icon(Icons.view_carousel),
                                                  Text('該当ページ',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                            ))),
                                  ],
                                ),
                                ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 800),
                                    child: Column(children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Center(
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5, top: 4),
                                                child: Icon(
                                                  Icons.book,
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  size: 32,
                                                ),
                                              ),
                                              const Text(
                                                '取り組み内容',
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ])),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: snapshot
                                                  .get('data')
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final String type =
                                                    snapshot.get('data')
                                                        [index]['type'];
                                                if (type == 'image') {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5),
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
                                                    padding: const EdgeInsets.all(5),
                                                    child: Container(
                                                      child: Card(
                                                        child: Column(
                                                          children: <Widget>[
                                                            AspectRatio(
                                                                aspectRatio: model
                                                                    .body[index]
                                                                    .aspectRatio,
                                                                child: Chewie(
                                                                  controller:
                                                                      model.body[
                                                                          index],
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else if (type == 'text') {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5),
                                                    child: Container(
                                                      child: Card(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Text(
                                                                  model.body[
                                                                      index],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18,
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
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Center(
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5, top: 4),
                                                child: Icon(
                                                  Icons.message,
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  size: 32,
                                                ),
                                              ),
                                              const Text(
                                                'フィードバック',
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ])),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: TextField(
                                          maxLengthEnforcement: MaxLengthEnforcement.none, controller: model.feedbackController,
                                          enabled: true,
                                          // 入力数
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              labelText: 'フィードバックを入力',
                                              suffixIcon: IconButton(
                                                onPressed: () => model
                                                    .feedbackController
                                                    .clear(),
                                                icon: const Icon(Icons.clear),
                                              ),
                                              errorText: model.EmptyError
                                                  ? 'フィードバックを入力してください'
                                                  : null),
                                        ),
                                      ),
                                      if (content['common'] != null) Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 10,
                                                  right: 10,
                                                  left: 10),
                                              child: Text(
                                                theme.getTitle(content['common']
                                                        ['type']) +
                                                    ' ' +
                                                    taskInfo['title'] +
                                                    ' (' +
                                                    task.getNumber(
                                                        content['common']
                                                            ['type'],
                                                        content['common']
                                                            ['page'],
                                                        content['common']
                                                            ['number']) +
                                                    ')\nもサインされます',
                                                textAlign: TextAlign.center,
                                              )) else Container(),
                                      if (!model.isLoading) RaisedButton.icon(
                                              onPressed: () {
                                                model.onTapSend();
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              color: Colors.blue[900],
                                              label: const Text(
                                                'サインする',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ) else Container(
                                              child: const Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Center(),
                                              ),
                                            ),
                                      if (!model.isLoading) FlatButton.icon(
                                              onPressed: () {
                                                model.onTapReject();
                                              },
                                              icon: const Icon(
                                                Icons.reply,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              label: const Text(
                                                'やりなおし',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ) else Container(
                                              child: const Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Center(),
                                              ),
                                            ),
                                    ]))
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Center(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5, top: 4),
                                            child: Icon(
                                              Icons.check,
                                              color:
                                                  Theme.of(context).colorScheme.secondary,
                                              size: 32,
                                            ),
                                          ),
                                          const Text(
                                            'このタスクは完了しました',
                                            style: TextStyle(
                                                fontSize: 23.0,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ]))),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, right: 20),
                                        child: FlatButton(
                                            onPressed: () async {
                                              final int result =
                                                  await showModalBottomSheet<
                                                      int>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(15),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                child: Text(
                                                                  task.getContent(
                                                                      type,
                                                                      model
                                                                          .page,
                                                                      model
                                                                          .number)['body'],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              )),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                child: const Text(
                                                                  '\n公財ボーイスカウト日本連盟「令和2年版 諸規定」',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              )),
                                                        ],
                                                      ));
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: const <Widget>[
                                                  Icon(Icons.sort),
                                                  Text('細目',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                            ))),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20, right: 20),
                                        child: FlatButton(
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .push<dynamic>(MyPageRoute(
                                                      page: showTaskConfirmView(
                                                          model.page,
                                                          type,
                                                          model.uid_get,
                                                          0),
                                                      dismissible: true));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: const <Widget>[
                                                  Icon(Icons.view_carousel),
                                                  Text('該当ページ',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                            ))),
                                  ],
                                ),
                                if (content['common'] != null) Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 10,
                                            right: 10,
                                            left: 10),
                                        child: Text(
                                          theme.getTitle(
                                                  content['common']['type']) +
                                              ' ' +
                                              taskInfo['title'] +
                                              ' (' +
                                              task.getNumber(
                                                  content['common']['type'],
                                                  content['common']['page'],
                                                  content['common']['number']) +
                                              ')\nもサインされます',
                                          textAlign: TextAlign.center,
                                        )) else Container(),
                              ],
                            );
                          }
                        } else {
                          return const Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: CircularProgressIndicator()),
                          );
                        }
                      })
                    ],
                  )))),
        ));
  }
}
