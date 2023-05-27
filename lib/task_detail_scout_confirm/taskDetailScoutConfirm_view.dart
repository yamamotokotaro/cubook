import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/widget/taskDetailScoutConfirm_add.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'taskDetailScoutConfirm_model.dart';

class MyPageRoute extends TransitionRoute<dynamic> {
  MyPageRoute({
    required this.page,
    required this.dismissible,
  });

  final Widget page;
  final bool dismissible;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(builder: _buildModalBarrier),
      OverlayEntry(builder: (BuildContext context) => Center(child: page))
    ];
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  Widget _buildModalBarrier(BuildContext context) {
    return IgnorePointer(
      ignoring: animation!.status ==
              AnimationStatus
                  .reverse || // changedInternalState is called when this updates
          animation!.status == AnimationStatus.dismissed,
      // dismissed is possible when doing a manual pop gesture
      child: AnimatedModalBarrier(
        color: animation!.drive(
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
  TaskScoutDetailConfirmView(String? _type, int? _number) {
    themeColor = theme.getThemeColor(_type);
    type = _type;
    number = _number;
  }
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  String? type;
  int? number;
  Color? themeColor;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>>? contents =
        task.getContentList(type, number);

    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: themeColor!);
    return Container(
        width: 280,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Card(
                    color: scheme.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    child: InkWell(child: Consumer<TaskDetailScoutConfirmModel>(
                        builder: (BuildContext context,
                            TaskDetailScoutConfirmModel model, _) {
                      if (model.isExit == true) {
                        String message = '';
                        final DocumentSnapshot snapshot = model.stepSnapshot;
                        final Map<String, dynamic> documentData =
                            snapshot.data() as Map<String, dynamic>;
                        if (documentData['end'] != null) {
                          if (type != 'usagi' &&
                              type != 'sika' &&
                              type != 'kuma' &&
                              type != 'tukinowa' &&
                              type != 'challenge') {
                            if (documentData['phase'] != null) {
                              if (snapshot.get('phase') == 'not examined') {
                                message = '技能考査が必要です';
                              } else {
                                message = '完修済み';
                              }
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
                                backgroundColor: scheme.background,
                                body: SingleChildScrollView(
                                    child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          color: themeColor),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 40, bottom: 20),
                                        child: Center(
                                          child: Text(
                                            task.getPartMap(
                                                type, number)!['title'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        message,
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    if (type != 'usagi' &&
                                        type != 'sika' &&
                                        type != 'kuma' &&
                                        type != 'tukinowa' &&
                                        type != 'challenge')
                                      if (model.stepData!['phase'] != null)
                                        model.stepSnapshot.get('phase') ==
                                                'not examined'
                                            ? Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                left: 20,
                                                                right: 20),
                                                        child:
                                                            ElevatedButton.icon(
                                                          onPressed: () async {
                                                            model
                                                                .onTapExamination(
                                                                    snapshot
                                                                        .id);
                                                          },
                                                          icon: const Icon(
                                                            Icons.check,
                                                            size: 20,
                                                          ),
                                                          label: const Text(
                                                            '考査済みにする',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : Container()
                                      else
                                        Container(),
                                    if (model.stepData!['start'] != null)
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            const Padding(
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
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: TextButton(
                                                child: Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(snapshot
                                                          .get('start')
                                                          .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: scheme.onSurface,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                onPressed: () {
                                                  model.changeTime(
                                                      snapshot
                                                          .get('start')
                                                          .toDate(),
                                                      context,
                                                      snapshot.id,
                                                      'start');
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Container(),
                                    if (model.stepData!['end'] != null)
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            const Padding(
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
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: TextButton(
                                                child: Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(snapshot
                                                          .get('end')
                                                          .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: scheme.onSurface,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                onPressed: () {
                                                  model.changeTime(
                                                      snapshot
                                                          .get('end')
                                                          .toDate(),
                                                      context,
                                                      snapshot.id,
                                                      'end');
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Container(),
                                    if (type != 'usagi' &&
                                        type != 'sika' &&
                                        type != 'kuma' &&
                                        type != 'tukinowa' &&
                                        type != 'challenge')
                                      if (model.stepData!['date_examination'] !=
                                          null)
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              const Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  '考査面接日',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: TextButton(
                                                  child: Text(
                                                    model.stepSnapshot.get(
                                                                'date_interview') !=
                                                            null
                                                        ? DateFormat(
                                                                'yyyy/MM/dd')
                                                            .format(snapshot
                                                                .get(
                                                                    'date_interview')
                                                                .toDate())
                                                            .toString()
                                                        : 'タップして追加',
                                                    style: const TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                  onPressed: () {
                                                    model.changeTime(
                                                        snapshot
                                                            .get(
                                                                'date_examination')
                                                            .toDate(),
                                                        context,
                                                        snapshot.id,
                                                        'date_interview');
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        Container(),
                                    if (type != 'usagi' &&
                                        type != 'sika' &&
                                        type != 'kuma' &&
                                        type != 'tukinowa' &&
                                        type != 'challenge')
                                      if (model.stepData!['date_examination'] !=
                                          null)
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              const Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  '考査認定日',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: TextButton(
                                                  child: Text(
                                                    DateFormat('yyyy/MM/dd')
                                                        .format(snapshot
                                                            .get(
                                                                'date_examination')
                                                            .toDate())
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                  onPressed: () {
                                                    model.changeTime(
                                                        snapshot
                                                            .get(
                                                                'date_examination')
                                                            .toDate(),
                                                        context,
                                                        snapshot.id,
                                                        'date_examination');
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 20,
                                                          right: 20),
                                                  child: TextButton.icon(
                                                    onPressed: () async {
                                                      model.onTapNotExamination(
                                                          snapshot.id);
                                                    },
                                                    icon: const Icon(
                                                      Icons.close,
                                                      size: 20,
                                                    ),
                                                    label: const Text(
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
                                      else
                                        Container(),
                                    if ((type != 'risu' &&
                                            type != 'usagi' &&
                                            type != 'sika' &&
                                            type != 'kuma' &&
                                            type != 'challenge' &&
                                            type != 'tukinowa') ||
                                        model.group ==
                                            ' j27DETWHGYEfpyp2Y292' ||
                                        model.group == ' z4pkBhhgr0fUMN4evr5z')
                                      Column(children: [
                                        ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: contents!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String content =
                                                  contents[index]['body'];
                                              Color? bordercolor;
                                              if (Theme.of(context)
                                                      .colorScheme
                                                      .secondary ==
                                                  Colors.white) {
                                                bordercolor = Colors.grey[700];
                                              } else {
                                                bordercolor = Colors.grey[300];
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10,
                                                    right: 10,
                                                    left: 10),
                                                child: Card(
                                                    color:
                                                        const Color(0x00000000),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color: bordercolor!,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    elevation: 0,
                                                    child: InkWell(
                                                      customBorder:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Text(content)),
                                                    )),
                                              );
                                            }),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                bottom: 10,
                                                right: 15),
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
                                      ])
                                    else
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Center(
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5, top: 4),
                                                  child: Icon(
                                                    //ああああ
                                                    Icons.chrome_reader_mode,
                                                    color: themeColor,
                                                    size: 22,
                                                  ),
                                                ),
                                                const Text(
                                                  '内容はカブブックで確認しよう',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ]))),
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
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    color: themeColor),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 20),
                                  child: Center(
                                    child: Text(
                                      task.getPartMap(type, number)!['title'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '記録がありません',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              if ((type != 'risu' &&
                                      type != 'usagi' &&
                                      type != 'sika' &&
                                      type != 'kuma' &&
                                      type != 'challenge' &&
                                      type != 'tukinowa') ||
                                  model.group == ' j27DETWHGYEfpyp2Y292' ||
                                  model.group == ' z4pkBhhgr0fUMN4evr5z')
                                Column(children: [
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: contents!.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final String content =
                                            contents[index]['body'];
                                        Color? bordercolor;
                                        if (Theme.of(context)
                                                .colorScheme
                                                .secondary ==
                                            Colors.white) {
                                          bordercolor = Colors.grey[700];
                                        } else {
                                          bordercolor = Colors.grey[300];
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, right: 10, left: 10),
                                          child: Card(
                                              color: const Color(0x00000000),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: bordercolor!,
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
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(content)),
                                              )),
                                        );
                                      }),
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
                                ])
                              else
                                Padding(
                                    padding: const EdgeInsets.only(top: 5),
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
                                              //ああああ
                                              Icons.chrome_reader_mode,
                                              color: themeColor,
                                              size: 22,
                                            ),
                                          ),
                                          const Text(
                                            '内容はカブブックで確認しよう',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.normal,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ]))),
                            ]))));
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color?>(themeColor),
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
                          padding: const EdgeInsets.all(10),
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
  TaskScoutAddConfirmView(
    String? _type,
    int? _page,
    int _index,
  ) {
    themeColor = theme.getThemeColor(_type);
    page = _page;
    index_page = _index;
    type = _type;
  }
  int? page;
  int? index_page;
  String? type;
  Color? themeColor;
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    bool isDark;
    final String numberShow = task.getNumber(type, page, index_page!)!;
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: themeColor!);
    if (Theme.of(context).colorScheme.secondary == Colors.white) {
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
              padding: const EdgeInsets.only(top: 30),
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
                                backgroundColor: scheme.background,
                                body: SingleChildScrollView(
                                    child: Column(
                                  children: <Widget>[
                                    Consumer<TaskDetailScoutConfirmModel>(
                                        builder: (BuildContext context,
                                            TaskDetailScoutConfirmModel model,
                                            _) {
                                      if (!model.isGet) {
                                        model.getSnapshot();
                                      }
                                      if (model.isLoaded) {
                                        if (model.isExit) {
                                          if (model.stepSnapshot.get('signed')[
                                                  index_page.toString()] ==
                                              null) {
                                            return Container(
                                              child:
                                                  TaskDetailScoutConfirmAddView(
                                                      index_page, type, ''),
                                            );
                                          } else if (model.stepSnapshot.get('signed')[index_page.toString()]
                                                  ['phaze'] ==
                                              'signed') {
                                            final Map<String, dynamic>
                                                snapshot = model.stepSnapshot
                                                        .get('signed')[
                                                    index_page.toString()];
                                            return Column(children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0)),
                                                    color: themeColor),
                                                child: const Padding(
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
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: TextButton(
                                                  child: Text(
                                                    DateFormat('yyyy/MM/dd')
                                                        .format(
                                                            model.dateSelected[
                                                                index_page!])
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: scheme.onSurface,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                  onPressed: () {
                                                    model.openTimePicker(
                                                        model.stepSnapshot
                                                            .get('signed')[
                                                                index_page
                                                                    .toString()]
                                                                ['time']
                                                            .toDate(),
                                                        context,
                                                        index_page);
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: TextField(
                                                  controller:
                                                      model.textField_signature[
                                                          index_page!],
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: '署名'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 20),
                                                child: TextField(
                                                  maxLines: null,
                                                  controller:
                                                      model.textField_feedback[
                                                          index_page!],
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'フィードバック'),
                                                ),
                                              ),
                                              if (!model.isLoading[index_page!])
                                                Column(
                                                  children: <Widget>[
                                                    FilledButton.icon(
                                                        onPressed: () {
                                                          model.onTapSave(
                                                              index_page!,
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.save,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                        label: const Text(
                                                          '変更を保存',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        scheme
                                                                            .primary))),
                                                    TextButton.icon(
                                                      onPressed: () async {
                                                        await showModalBottomSheet<
                                                            int>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <Widget>[
                                                                    Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                17,
                                                                            bottom:
                                                                                17),
                                                                        child: Container(
                                                                            width: double.infinity,
                                                                            child: const Text(
                                                                              '本当に取り消しますか?',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 22,
                                                                              ),
                                                                              textAlign: TextAlign.left,
                                                                            ))),
                                                                    ListTile(
                                                                      leading:
                                                                          const Icon(
                                                                              Icons.delete),
                                                                      title: const Text(
                                                                          'はい'),
                                                                      onTap:
                                                                          () {
                                                                        model.onTapCancel(
                                                                            index_page!);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    ListTile(
                                                                      leading:
                                                                          const Icon(
                                                                              Icons.arrow_back),
                                                                      title: const Text(
                                                                          'いいえ'),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    )
                                                                  ],
                                                                ));
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.close,
                                                        size: 20,
                                                        color: Colors.red,
                                                      ),
                                                      label: const Text(
                                                        'サイン取り消し',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Divider(
                                                          color: isDark
                                                              ? Colors.grey[600]
                                                              : Colors
                                                                  .grey[400],
                                                        )),
                                                    TextButton.icon(
                                                      onPressed: () async {
                                                        final int? result =
                                                            await showModalBottomSheet<
                                                                int>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <Widget>[
                                                                    Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        child: Container(
                                                                            width: double.infinity,
                                                                            child: const Text(
                                                                              '画像',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                              ),
                                                                              textAlign: TextAlign.left,
                                                                            ))),
                                                                    ListTile(
                                                                      leading:
                                                                          const Icon(
                                                                              Icons.camera_alt),
                                                                      title: const Text(
                                                                          'カメラ'),
                                                                      onTap:
                                                                          () {
                                                                        model.onImagePressCamera(
                                                                            model.page,
                                                                            index_page);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    ListTile(
                                                                      leading:
                                                                          const Icon(
                                                                        Icons
                                                                            .collections,
                                                                      ),
                                                                      title: const Text(
                                                                          'ギャラリー'),
                                                                      onTap:
                                                                          () {
                                                                        model.onImagePressPick(
                                                                            model.page,
                                                                            index_page);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        child: Container(
                                                                            width: double.infinity,
                                                                            child: const Text(
                                                                              '動画',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                              ),
                                                                              textAlign: TextAlign.left,
                                                                            ))),
                                                                    ListTile(
                                                                      leading:
                                                                          const Icon(
                                                                              Icons.camera_alt),
                                                                      title: const Text(
                                                                          'カメラ'),
                                                                      onTap:
                                                                          () {
                                                                        model.onVideoPressCamera(
                                                                            model.page,
                                                                            index_page);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    ListTile(
                                                                      leading:
                                                                          const Icon(
                                                                        Icons
                                                                            .collections,
                                                                      ),
                                                                      title: const Text(
                                                                          'ギャラリー'),
                                                                      onTap:
                                                                          () {
                                                                        model.onVideoPressPick(
                                                                            model.page,
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
                                                        color: scheme.primary,
                                                      ),
                                                      label: Text(
                                                        '画像・動画を追加',
                                                        style: TextStyle(
                                                          color: scheme.primary,
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
                                                                    Color?>(
                                                                themeColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot['data'] != null)
                                                Column(
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                snapshot['data']
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              final String?
                                                                  type =
                                                                  snapshot['data']
                                                                          [
                                                                          index]
                                                                      ['type'];
                                                              if (type ==
                                                                  'image') {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(5),
                                                                  child:
                                                                      Material(
                                                                          child:
                                                                              InkWell(
                                                                    onLongPress:
                                                                        () async {
                                                                      final int?
                                                                          result =
                                                                          await showModalBottomSheet<
                                                                              int>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return Padding(
                                                                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: <Widget>[
                                                                                  ListTile(
                                                                                    leading: const Icon(Icons.delete),
                                                                                    title: const Text('画像を削除する'),
                                                                                    onTap: () {
                                                                                      //model.deleteEffort(id);
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
                                                                          Image.network(model.dataList[index_page!]
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
                                                                        const EdgeInsets.all(
                                                                            5),
                                                                    child:
                                                                        Material(
                                                                      child:
                                                                          InkWell(
                                                                        onLongPress:
                                                                            () async {
                                                                          final int?
                                                                              result =
                                                                              await showModalBottomSheet<int>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return Padding(
                                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      ListTile(
                                                                                        leading: const Icon(Icons.delete),
                                                                                        title: const Text('動画を削除する'),
                                                                                        onTap: () {
                                                                                          //model.deleteEffort(id);
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
                                                                              AspectRatio(
                                                                                  aspectRatio: model.dataList[index_page!][index].aspectRatio,
                                                                                  child: Chewie(
                                                                                    controller: model.dataList[index_page!][index],
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ));
                                                              } else if (type ==
                                                                  'text') {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(5),
                                                                  child:
                                                                      Container(
                                                                    child: Card(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        children: <Widget>[
                                                                          Padding(
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: Text(
                                                                                model.dataList[index_page!][index],
                                                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
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
                                              else
                                                Container(),
                                            ]);
                                          } else if (model.stepSnapshot
                                                      .get('signed')[index_page.toString()]
                                                  ['phaze'] ==
                                              'wait') {
                                            return Column(children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0)),
                                                    color: themeColor),
                                                child: const Padding(
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
                                              const Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  '最初の画面に戻ってサインしてください',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
                                            ]);
                                          } else if (model.stepSnapshot
                                                      .get('signed')[index_page.toString()]
                                                  ['phaze'] ==
                                              'reject') {
                                            return Column(children: <Widget>[
                                              TaskDetailScoutConfirmAddView(
                                                  index_page,
                                                  type,
                                                  'やりなおし： ' +
                                                      model.stepSnapshot.get(
                                                                  'signed')[
                                                              index_page
                                                                  .toString()]
                                                          ['feedback'])
                                            ]);
                                          } else if (model.stepSnapshot
                                                      .get('signed')[index_page.toString()]
                                                  ['phaze'] ==
                                              'withdraw') {
                                            return Column(children: <Widget>[
                                              TaskDetailScoutConfirmAddView(
                                                  index_page, type, '')
                                            ]);
                                          } else {
                                            return const Center(
                                              child: Text('エラーが発生しました'),
                                            );
                                          }
                                        } else {
                                          return TaskDetailScoutConfirmAddView(
                                              index_page, type, '');
                                        }
                                      } else {
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 60, bottom: 10),
                                            child: Container(
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color?>(
                                                            themeColor)),
                                              ),
                                            ));
                                      }
                                    })
                                  ],
                                ))))
//                      ),
                        ),
                  ))),
          if (numberShow.length == 1)
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
                        numberShow,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: themeColor),
                      ),
                    ),
                  ),
                ))
          else
            Align(
              alignment: Alignment.topCenter,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0)),
                elevation: 7,
                child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: 61, minHeight: 61),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      child: Text(
                        numberShow,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: themeColor),
                      ),
                    )),
              ),
            )
        ]));
  }
}
