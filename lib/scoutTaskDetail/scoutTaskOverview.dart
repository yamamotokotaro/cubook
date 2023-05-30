import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/scoutTaskDetail/scoutTaskModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskScoutOverview extends StatelessWidget {
  TaskScoutOverview(String? _type, int? _number) {
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
    final ColorScheme scheme = ColorScheme.fromSeed(
        seedColor: themeColor!,
        brightness: MediaQuery.of(context).platformBrightness);
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
                    color: scheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    child: InkWell(child: Consumer<ScoutTaskModel>(builder:
                        (BuildContext context, ScoutTaskModel model, _) {
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
