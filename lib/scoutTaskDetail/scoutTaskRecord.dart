import 'package:chewie/chewie.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/scoutTaskDetail/scoutTaskModel.dart';
import 'package:cubook/scoutTaskDetail/scoutTaskReport.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScoutTaskRecord extends StatelessWidget {
  ScoutTaskRecord(String? _type, int? _page, int _index) {
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
    final ColorScheme scheme = ColorScheme.fromSeed(
        seedColor: themeColor!,
        brightness: MediaQuery.of(context).platformBrightness);
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
                    color: scheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    child: InkWell(
                      child: Column(
                        children: <Widget>[
                          Consumer<ScoutTaskModel>(builder:
                              (BuildContext context, ScoutTaskModel model, _) {
                            if (!model.isGet) {
                              model.getSnapshot();
                            }
                            if (model.isLoaded) {
                              if (model.isExit) {
                                if (model.stepSnapshot
                                        .get('signed')[index_page.toString()] ==
                                    null) {
                                  return ScoutTaskReport(
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
                                    ScoutTaskReport(
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
                                    ScoutTaskReport(
                                        index_page, type, 'どんなことをしたのかリーダーに教えよう')
                                  ]);
                                } else {
                                  return const Center(
                                    child: Text('エラーが発生しました'),
                                  );
                                }
                              } else {
                                return ScoutTaskReport(
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
