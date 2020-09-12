import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/widget/taskDetailScoutConfirm_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'taskDetailScoutConfirm_model.dart';

class MyPageRoute extends TransitionRoute<dynamic> {
  MyPageRoute({
    @required this.page,
    @required this.dismissible,
  });

  final Widget page;
  final bool dismissible;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(builder: _buildModalBarrier),
      OverlayEntry(builder: (context) => Center(child: page))
    ];
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  Widget _buildModalBarrier(BuildContext context) {
    return IgnorePointer(
      ignoring: animation.status ==
              AnimationStatus
                  .reverse || // changedInternalState is called when this updates
          animation.status == AnimationStatus.dismissed,
      // dismissed is possible when doing a manual pop gesture
      child: AnimatedModalBarrier(
        color: animation.drive(
          ColorTween(
            begin: Colors.transparent,
            end: Colors.black.withAlpha(150),
          ),
        ),
        dismissible: dismissible,
      ),
    );
  }
}

class TaskScoutDetailConfirmView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();
  String type;
  int number;
  Color themeColor;

  TaskScoutDetailConfirmView(String _type, int _number) {
    themeColor = theme.getThemeColor(_type);
    type = _type;
    number = _number;
  }

  @override
  Widget build(BuildContext context) {
    List<String> contents = task.getContentList(type, number);
    return Container(
        width: 280,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Card(
//                    color: Color.fromRGBO(48, 48, 48, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    child: InkWell(child: Consumer<TaskDetailScoutConfirmModel>(
                        builder: (context, model, _) {
                      if (model.isExit == true) {
                        var message = '';
                        DocumentSnapshot snapshot = model.stepSnapshot;
                        if (snapshot['end'] != null) {
                          if (snapshot['phase'] != null) {
                            if (snapshot['phase'] == 'not examined') {
                              message = '技能考査が必要です';
                            } else {
                              message = '完修済み';
                            }
                          } else {
                            message = '完修済み';
                          }
                        } else {
                          message = '進行中️';
                        }
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Scaffold(
                                body: SingleChildScrollView(
                                    child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20)),
                                      color: themeColor),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 40, bottom: 20),
                                    child: Center(
                                      child: Text(
                                        task.getPartMap(type, number)['title'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    message,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                                model.stepSnapshot['phase'] != null
                                    ? model.stepSnapshot['phase'] ==
                                            'not examined'
                                        ? Container(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10,
                                                        left: 20,
                                                        right: 20),
                                                    child: RaisedButton.icon(
                                                      onPressed: () async {
                                                        model.onTapExamination(
                                                            snapshot
                                                                .documentID);
                                                      },
                                                      color: themeColor,
                                                      icon: Icon(
                                                        Icons.check,
                                                        size: 20,
                                                      ),
                                                      label: Text(
                                                        '考査済みにする',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          )
                                        : Container()
                                    : Container(),
                                model.stepSnapshot['start'] != null
                                    ? Container(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                '開始日',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: FlatButton(
                                                child: Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(snapshot['start']
                                                          .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                onPressed: () {
                                                  model.changeTime(
                                                      snapshot['start']
                                                          .toDate(),
                                                      context,
                                                      snapshot.documentID,
                                                      'start');
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                model.stepSnapshot['end'] != null
                                    ? Container(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                '完修日',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: FlatButton(
                                                child: Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(snapshot['end']
                                                          .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                onPressed: () {
                                                  model.changeTime(
                                                      snapshot['end'].toDate(),
                                                      context,
                                                      snapshot.documentID,
                                                      'end');
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                model.stepSnapshot['date_examination'] != null
                                    ? Container(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                '考査認定日',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: FlatButton(
                                                child: Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(snapshot[
                                                              'date_examination']
                                                          .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                onPressed: () {
                                                  model.changeTime(
                                                      snapshot[
                                                              'date_examination']
                                                          .toDate(),
                                                      context,
                                                      snapshot.documentID,
                                                      'date_examination');
                                                },
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 20,
                                                    right: 20),
                                                child: FlatButton.icon(
                                                  onPressed: () async {
                                                    model.onTapNotExamination(
                                                        snapshot.documentID);
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    '考査未完了にする',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: contents.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String content = contents[index];
                                      Color bordercolor;
                                      if (Theme.of(context).accentColor ==
                                          Colors.white) {
                                        bordercolor = Colors.grey[700];
                                      } else {
                                        bordercolor = Colors.grey[300];
                                      }
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10, right: 10, left: 10),
                                        child: Card(
                                            color: Color(0x00000000),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: bordercolor,
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
                                              onTap: () {
                                                if (model
                                                    .controller.hasClients) {
                                                  model.controller
                                                      .animateToPage(index + 1,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          curve: Curves.ease);
                                                }
                                              },
                                              child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(content)),
                                            )),
                                      );
                                    }),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, bottom: 10, right: 15),
                                    child: Container(
                                      width: double.infinity,
                                      child: Text(
                                        '\n公財ボーイスカウト日本連盟「令和2年版 諸規定」',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                              ],
                            ))));
                      } else if (model.isExit != true &&
                          model.isLoaded == true) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Scaffold(
                                body: SingleChildScrollView(
                                    child: Column(children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20)),
                                    color: themeColor),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 40, bottom: 20),
                                  child: Center(
                                    child: Text(
                                      task.getPartMap(type, number)['title'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '記録がありません',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: contents.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String content = contents[index];
                                    Color bordercolor;
                                    if (Theme.of(context).accentColor ==
                                        Colors.white) {
                                      bordercolor = Colors.grey[700];
                                    } else {
                                      bordercolor = Colors.grey[300];
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 10, right: 10, left: 10),
                                      child: Card(
                                          color: Color(0x00000000),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: bordercolor,
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
                                            onTap: () {
                                              model.controller.animateToPage(
                                                  index + 1,
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  curve: Curves.ease);
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(content)),
                                          )),
                                    );
                                  }),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, bottom: 10, right: 15),
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      '\n公財ボーイスカウト日本連盟「令和2年版 諸規定」',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                            ]))));
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                          ),
                        );
                      }
                    })),
                  )),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      elevation: 7,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.collections_bookmark,
                            size: 40,
                            color: themeColor,
                          )),
                    ),
                  ))
            ])));
  }
}

class TaskScoutAddConfirmView extends StatelessWidget {
  int index_page;
  String type;
  Color themeColor;
  var theme = new ThemeInfo();

  TaskScoutAddConfirmView(int _index, String _type) {
    themeColor = theme.getThemeColor(_type);
    index_page = _index;
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                  height: 1500,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    child: InkWell(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Scaffold(
                                body: SingleChildScrollView(
                                    child: Column(
                              children: <Widget>[
                                Consumer<TaskDetailScoutConfirmModel>(
                                    builder: (context, model, _) {
                                  if (!model.isGet) {
                                    model.getSnapshot();
                                  }
                                  if (model.isLoaded) {
                                    if (model.isExit) {
                                      if (model.stepSnapshot['signed']
                                              [index_page.toString()] ==
                                          null) {
                                        return Container(
                                          child: TaskDetailScoutConfirmAddView(
                                              index_page, type, ''),
                                        );
                                      } else if (model.stepSnapshot['signed']
                                                  [index_page.toString()]
                                              ['phaze'] ==
                                          'signed') {
                                        Map<String, dynamic> snapshot =
                                            model.stepSnapshot['signed']
                                                [index_page.toString()];
                                        return Column(children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            0),
                                                    topRight:
                                                        const Radius.circular(
                                                            0)),
                                                color: themeColor),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 40, bottom: 20),
                                              child: Center(
                                                child: Text(
                                                  'サイン済み',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: FlatButton(
                                              child: Text(
                                                DateFormat('yyyy/MM/dd')
                                                    .format(model.dateSelected[
                                                        index_page])
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                              onPressed: () {
                                                model.openTimePicker(
                                                    model.stepSnapshot['signed']
                                                            [index_page
                                                                .toString()]
                                                            ['time']
                                                        .toDate(),
                                                    context,
                                                    index_page);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextField(
                                              controller:
                                                  model.textField_signature[
                                                      index_page],
                                              decoration: InputDecoration(
                                                  labelText: "署名"),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                                bottom: 20),
                                            child: TextField(
                                              maxLines: null,
                                              controller:
                                                  model.textField_feedback[
                                                      index_page],
                                              keyboardType:
                                                  TextInputType.multiline,
                                              decoration: InputDecoration(
                                                  labelText: "フィードバック"),
                                            ),
                                          ),
                                          if (!model.isLoading[index_page])
                                            Column(
                                              children: <Widget>[
                                                RaisedButton.icon(
                                                  onPressed: () {
                                                    model.onTapSave(
                                                        index_page, context);
                                                  },
                                                  icon: Icon(
                                                    Icons.save,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  color: themeColor,
                                                  label: Text(
                                                    '変更を保存',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                FlatButton.icon(
                                                  onPressed: () async {
                                                    await showModalBottomSheet<
                                                        int>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 5,
                                                                        left:
                                                                            17,
                                                                        bottom:
                                                                            17),
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        child: Text(
                                                                          '本当に取り消しますか?',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                22,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                        ))),
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .delete),
                                                                  title: Text(
                                                                      'はい'),
                                                                  onTap: () {
                                                                    model.onTapCancel(
                                                                        index_page);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .arrow_back),
                                                                  title: Text(
                                                                      'いいえ'),
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                )
                                                              ],
                                                            ));
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                  label: Text(
                                                    'サイン取り消し',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Divider(
                                                      color: isDark
                                                          ? Colors.grey[600]
                                                          : Colors.grey[400],
                                                    )),
                                                FlatButton.icon(
                                                  onPressed: () async {
                                                    var result =
                                                        await showModalBottomSheet<
                                                            int>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        child: Text(
                                                                          '画像',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                20,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                        ))),
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .camera_alt),
                                                                  title: Text(
                                                                      'カメラ'),
                                                                  onTap: () {
                                                                    model.onImagePressCamera(
                                                                        model
                                                                            .page,
                                                                        index_page);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  leading: Icon(
                                                                    Icons
                                                                        .collections,
                                                                  ),
                                                                  title: Text(
                                                                      'ギャラリー'),
                                                                  onTap: () {
                                                                    model.onImagePressPick(
                                                                        model
                                                                            .page,
                                                                        index_page);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        child: Text(
                                                                          '動画',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                20,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                        ))),
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .camera_alt),
                                                                  title: Text(
                                                                      'カメラ'),
                                                                  onTap: () {
                                                                    model.onVideoPressCamera(
                                                                        model
                                                                            .page,
                                                                        index_page);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  leading: Icon(
                                                                    Icons
                                                                        .collections,
                                                                  ),
                                                                  title: Text(
                                                                      'ギャラリー'),
                                                                  onTap: () {
                                                                    model.onVideoPressPick(
                                                                        model
                                                                            .page,
                                                                        index_page);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            ));
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    '画像・動画を追加',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          else
                                            Container(
                                              child: Container(
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(themeColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          snapshot['data'] != null
                                              ? Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: ListView.builder(
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                snapshot['data']
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              String type =
                                                                  snapshot['data']
                                                                          [
                                                                          index]
                                                                      ['type'];
                                                              if (type ==
                                                                  'image') {
                                                                return Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child:
                                                                      Material(
                                                                          child:
                                                                              InkWell(
                                                                    onLongPress:
                                                                        () async {
                                                                      var result =
                                                                          await showModalBottomSheet<
                                                                              int>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return Padding(
                                                                              padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  ListTile(
                                                                                    leading: Icon(Icons.delete),
                                                                                    title: Text('画像を削除する'),
                                                                                    onTap: () {
                                                                                      //model.deleteEffort(documentID);
                                                                                      model.deleteFile(index_page, index);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ));
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Image.network(model.dataList[index_page]
                                                                              [
                                                                              index])
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )),
                                                                );
                                                              } else if (type ==
                                                                  'video') {
                                                                return Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(
                                                                                5),
                                                                    child:
                                                                        Material(
                                                                      child:
                                                                          InkWell(
                                                                        onLongPress:
                                                                            () async {
                                                                          var result =
                                                                              await showModalBottomSheet<int>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return Padding(
                                                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      ListTile(
                                                                                        leading: Icon(Icons.delete),
                                                                                        title: Text('動画を削除する'),
                                                                                        onTap: () {
                                                                                          //model.deleteEffort(documentID);
                                                                                          model.deleteFile(index_page, index);
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ));
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: <Widget>[
                                                                              Chewie(
                                                                                controller: model.dataList[index_page][index],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ));
                                                              } else if (type ==
                                                                  'text') {
                                                                return Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child:
                                                                      Container(
                                                                    child: Card(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                              padding: EdgeInsets.all(10),
                                                                              child: Text(
                                                                                model.dataList[index_page][index],
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    )),
                                                                  ),
                                                                );
                                                              } else {
                                                                return Container();
                                                              }
                                                            }))
                                                  ],
                                                )
                                              : Container(),
                                        ]);
                                      } else if (model.stepSnapshot['signed']
                                                  [index_page.toString()]
                                              ['phaze'] ==
                                          'wait') {
                                        return Column(children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            0),
                                                    topRight:
                                                        const Radius.circular(
                                                            0)),
                                                color: themeColor),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 40, bottom: 20),
                                              child: Center(
                                                child: Text(
                                                  'サイン待ち',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              '最初の画面に戻ってサインしてください',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                        ]);
                                      } else if (model.stepSnapshot['signed']
                                                  [index_page.toString()]
                                              ['phaze'] ==
                                          'reject') {
                                        return Column(children: <Widget>[
                                          TaskDetailScoutConfirmAddView(
                                              index_page,
                                              type,
                                              'やりなおし： ' +
                                                  model.stepSnapshot['signed'][
                                                          index_page.toString()]
                                                      ['feedback'])
                                        ]);
                                      } else if (model.stepSnapshot['signed']
                                                  [index_page.toString()]
                                              ['phaze'] ==
                                          'withdraw') {
                                        return Column(children: <Widget>[
                                          TaskDetailScoutConfirmAddView(
                                              index_page, type, '')
                                        ]);
                                      } else {
                                        return Center(
                                          child: Text('エラーが発生しました'),
                                        );
                                      }
                                    } else {
                                      return TaskDetailScoutConfirmAddView(
                                          index_page, type, '');
                                    }
                                  } else {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                            top: 60, bottom: 10),
                                        child: Container(
                                          child: Center(
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(themeColor)),
                                          ),
                                        ));
                                  }
                                })
                              ],
                            ))))
//                      ),
                        ),
                  ))),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 70,
                width: 70,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                  elevation: 7,
                  child: Center(
                    child: Text(
                      (index_page + 1).toString(),
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: themeColor),
                    ),
                  ),
                ),
              ))
        ]));
  }
}
