import 'package:chewie/chewie.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_model.dart';
import 'package:cubook/task_detail_scout/widget/taskDetailScout_add.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

class TaskScoutDetailView extends StatelessWidget {
  TaskScoutDetailView(String? _type, int? _number) {
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    child: InkWell(child: Consumer<TaskDetailScoutModel>(
                        builder: (BuildContext context,
                            TaskDetailScoutModel model, _) {
                      if (model.isExit) {
                        String message = '';
                        if (model.stepData!['end'] != null) {
                          message = '完修済み🎉';
                        } else {
                          message = 'その調子🏃‍♂️';
                        }
                        return Column(
                          children: <Widget>[
                            Column(children: <Widget>[
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
                              Container(
                                  height: MediaQuery.of(context).size.height >
                                          700
                                      ? MediaQuery.of(context).size.height - 334
                                      : MediaQuery.of(context).size.height -
                                          228,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(model.stepSnapshot
                                                          .get('start')
                                                          .toDate())
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(model.stepSnapshot
                                                          .get('end')
                                                          .toDate()),
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
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
                                          model.group ==
                                              ' z4pkBhhgr0fUMN4evr5z')
                                        Column(children: [
                                          ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: contents!.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final String content =
                                                    contents[index]['body'];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          right: 10,
                                                          left: 10),
                                                  child: Card(
                                                      color: const Color(
                                                          0x00000000),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      elevation: 0,
                                                      child: InkWell(
                                                        customBorder:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child:
                                                                Text(content)),
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                ]))),
                                    ],
                                  ))),
                            ]),
                          ],
                        );
                      } else if (model.isExit != true &&
                          model.isLoaded == true) {
                        return Column(children: <Widget>[
                          Column(children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  color: themeColor),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 20),
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
                            Container(
                                height: MediaQuery.of(context).size.height > 700
                                    ? MediaQuery.of(context).size.height - 334
                                    : MediaQuery.of(context).size.height - 228,
                                child: SingleChildScrollView(
                                    child: Column(children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'はじめよう💨',
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
                                                  shape: RoundedRectangleBorder(
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
                                                          BorderRadius.circular(
                                                              10.0),
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ]))),
                                ])))
                          ])
                        ]);
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

class TaskScoutAddView extends StatelessWidget {
  TaskScoutAddView(String? _type, int? _page, int _index) {
    themeColor = theme.getThemeColor(_type);
    type = _type;
    page = _page;
    index_page = _index;
  }
  int? index_page;
  int? page;
  String? type;
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  Color? themeColor;

  @override
  Widget build(BuildContext context) {
    final String numberShow = task.getNumber(type, page, index_page!)!;
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
                      child:
                          /*SingleChildScrollView(
                        child: */
                          Column(
                        children: <Widget>[
                          Consumer<TaskDetailScoutModel>(builder:
                              (BuildContext context, TaskDetailScoutModel model,
                                  _) {
                            if (!model.isGet) {
                              model.getSnapshot();
                            }
                            if (model.isLoaded) {
                              if (model.isExit) {
                                if (model.stepSnapshot
                                        .get('signed')[index_page.toString()] ==
                                    null) {
                                  return TaskDetailScoutAddView(
                                      index_page, type, 'どんなことをしたのかリーダーに教えよう');
                                } else if (model.stepSnapshot.get('signed')[
                                        index_page.toString()]['phaze'] ==
                                    'signed') {
                                  final Map<String, dynamic> snapshot = model
                                      .stepSnapshot
                                      .get('signed')[index_page.toString()];
                                  return Column(children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          color: themeColor),
                                      width: MediaQuery.of(context).size.width,
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 40, bottom: 20),
                                        child: Center(
                                          child: Text(
                                            'サイン済み',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: MediaQuery.of(context)
                                                    .size
                                                    .height >
                                                700
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                334
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                228,
                                        child: SingleChildScrollView(
                                            child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                DateFormat('yyyy/MM/dd')
                                                        .format(model
                                                            .stepSnapshot
                                                            .get('signed')[
                                                                index_page
                                                                    .toString()]
                                                                ['time']
                                                            .toDate())
                                                        .toString() +
                                                    model.stepSnapshot
                                                                .get('signed')[
                                                            index_page
                                                                .toString()]
                                                        ['family'],
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                model.stepSnapshot
                                                            .get('signed')[
                                                        index_page.toString()]
                                                    ['feedback'],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                            if (snapshot['data'] != null)
                                              Column(
                                                children: <Widget>[
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
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
                                                            final String? type =
                                                                snapshot['data']
                                                                        [index]
                                                                    ['type'];
                                                            if (type ==
                                                                'image') {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    Container(
                                                                  child: Card(
                                                                    child:
                                                                        Column(
                                                                      children: <Widget>[
                                                                        Image.network(model.dataList[index_page!]
                                                                            [
                                                                            index])
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            } else if (type ==
                                                                'video') {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    Container(
                                                                  child: Card(
                                                                    child:
                                                                        Column(
                                                                      children: <Widget>[
                                                                        AspectRatio(
                                                                            aspectRatio:
                                                                                model.dataList[index_page!][index].aspectRatio,
                                                                            child: Chewie(
                                                                              controller: model.dataList[index_page!][index],
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
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
                                                                        const EdgeInsets
                                                                            .all(0),
                                                                    child:
                                                                        Column(
                                                                      children: <Widget>[
                                                                        Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
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
                                          ],
                                        )))
                                  ]);
                                } else if (model.stepSnapshot
                                            .get('signed')[index_page.toString()]
                                        ['phaze'] ==
                                    'wait') {
                                  final Map<String, dynamic> snapshot = model
                                      .stepSnapshot
                                      .get('signed')[index_page.toString()];
                                  return Column(children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          color: themeColor),
                                      width: MediaQuery.of(context).size.width,
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 40, bottom: 20),
                                        child: Center(
                                          child: Text(
                                            'サイン待ち',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: MediaQuery.of(context)
                                                    .size
                                                    .height >
                                                700
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                334
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                228,
                                        child: SingleChildScrollView(
                                            child: Column(children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'ちょっと待っててね⏰',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 20, right: 20),
                                              child: TextButton.icon(
                                                onPressed: () async {
                                                  model.withdraw(index_page);
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                                label: const Text(
                                                  'お願いを取り消し',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )),
                                          if (snapshot['data'] != null)
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
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
                                                          print(
                                                              snapshot['data']);
                                                          print(model.dataList);
                                                          final String? type =
                                                              snapshot['data']
                                                                      [index]
                                                                  ['type'];
                                                          if (type == 'image') {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Container(
                                                                child: Card(
                                                                  color: Colors
                                                                      .green,
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      Image.network(
                                                                          model.dataList[index_page!]
                                                                              [
                                                                              index])
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else if (type ==
                                                              'video') {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Container(
                                                                child: Card(
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      AspectRatio(
                                                                          aspectRatio: model
                                                                              .dataList[index_page!][
                                                                                  index]
                                                                              .aspectRatio,
                                                                          child:
                                                                              Chewie(
                                                                            controller:
                                                                                model.dataList[index_page!][index],
                                                                          ))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else if (type ==
                                                              'text') {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Container(
                                                                child: Card(
                                                                    child:
                                                                        Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      Padding(
                                                                          padding: const EdgeInsets.all(
                                                                              10),
                                                                          child:
                                                                              Text(
                                                                            model.dataList[index_page!][index],
                                                                            style:
                                                                                const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
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
                                        ])))
                                  ]);
                                } else if (model.stepSnapshot
                                            .get('signed')[index_page.toString()]
                                        ['phaze'] ==
                                    'reject') {
                                  return Column(children: <Widget>[
                                    TaskDetailScoutAddView(
                                        index_page,
                                        type,
                                        'やりなおし： ' +
                                            model.stepSnapshot.get('signed')[
                                                    index_page.toString()]
                                                ['feedback'])
                                  ]);
                                } else if (model.stepSnapshot
                                            .get('signed')[index_page.toString()]
                                        ['phaze'] ==
                                    'withdraw') {
                                  return Column(children: <Widget>[
                                    TaskDetailScoutAddView(
                                        index_page, type, 'どんなことをしたのかリーダーに教えよう')
                                  ]);
                                } else {
                                  return const Center(
                                    child: Text('エラーが発生しました'),
                                  );
                                }
                              } else {
                                return TaskDetailScoutAddView(
                                    index_page, type, 'どんなことをしたのかリーダーに教えよう');
                              }
                            } else {
                              return Padding(
                                  padding: const EdgeInsets.only(top: 60),
                                  child: Container(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color?>(
                                                  themeColor)),
                                    ),
                                  ));
                            }
                          })
                        ],
                      ),
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
