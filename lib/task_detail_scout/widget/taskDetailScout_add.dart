
import 'package:chewie/chewie.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../taskDetailScout_model.dart';

class TaskDetailScoutAddView extends StatelessWidget {
  int? index_page;
  String? type;
  late String mes;
  Color? themeColor;
  int? countChewie;
  late Map<String, dynamic> content;
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  TaskDetailScoutAddView(int? _index, String? _type, String _mes) {
    themeColor = theme.getThemeColor(_type);
    index_page = _index;
    type = _type;
    mes = _mes;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDetailScoutModel>(builder: (BuildContext context, TaskDetailScoutModel model, _) {
      content = task.getContent(type, model.page, index_page);
      countChewie = 0;
      return Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              color: themeColor),
          child: const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Center(
              child: Text(
                'サインをもらおう！',
                style: TextStyle(
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
                child: Column(
              children: <Widget>[
                if ((type != 'risu' &&
                            type != 'usagi' &&
                            type != 'sika' &&
                            type != 'kuma' &&
                            type != 'challenge' &&
                            type != 'tukinowa') ||
                        model.group == ' j27DETWHGYEfpyp2Y292' ||
                        model.group == ' z4pkBhhgr0fUMN4evr5z') Padding(
                        padding: const EdgeInsets.all(15),
                        child: ExpandText(
                          content['body'],
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.light? Colors.black:Colors.white
                          ),
                          textAlign: TextAlign.justify,
                        )) else Container(),
                if (type == 'usagi' ||
                        type == 'sika' ||
                        type == 'kuma' ||
                        type == 'challenge') Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Text(
                          mes,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )) else Container(),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.list_attach[index_page!].length,
                        itemBuilder: (BuildContext context, int index) {
                          final String? attach = model.list_attach[index_page!][index];
                          if (attach == 'image') {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                child: Card(
                                  color: Colors.green,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const <Widget>[
                                            Icon(
                                              Icons.image,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '画像を選ぶ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (model.map_attach[index_page!][index] ==
                                              null) Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 44,
                                                    child: FlatButton.icon(
                                                      onPressed: () {
                                                        model
                                                            .onImagePressCamera(
                                                                index_page!,
                                                                index);
                                                      },
                                                      icon: const Icon(
                                                        Icons.camera_alt,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      color:
                                                          Colors.blueGrey[400],
                                                      label: const Text(
                                                        'カメラ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: SizedBox(
                                                        height: 44,
                                                        child: FlatButton.icon(
                                                          onPressed: () {
                                                            model
                                                                .onImagePressPick(
                                                                    index_page!,
                                                                    index);
                                                          },
                                                          icon: const Icon(
                                                            Icons.collections,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                          color:
                                                              Colors.brown[400],
                                                          label: const Text(
                                                            'ギャラリー',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )))
                                              ],
                                            ) else Container(
                                              child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Container(
                                                    child: Card(
                                                      color: Colors.green,
                                                      child: Column(
                                                        children: <Widget>[
                                                          if (model.map_attach[index_page!]
                                                                      [index]
                                                                  is PickedFile) Image.memory(
                                                                  model.map_show[
                                                                          index_page!]
                                                                      [index]) else Image.network(
                                                                  model.map_show[
                                                                          index_page!]
                                                                      [index])
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                /*IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: () async {
                                                    model.onPressDelete(index_page, index);
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 21,
                                                  ),
                                                )*/
                                              ],
                                            ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (attach == 'video') {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                child: Card(
                                  color: Colors.blue,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const <Widget>[
                                            Icon(
                                              Icons.movie,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '動画を選ぶ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (model.map_attach[index_page!][index] ==
                                              null) Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 44,
                                                    child: FlatButton.icon(
                                                      onPressed: () {
                                                        model
                                                            .onVideoPressCamera(
                                                                index_page!,
                                                                index);
                                                      },
                                                      icon: const Icon(
                                                        Icons.camera_alt,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      color:
                                                          Colors.blueGrey[400],
                                                      label: const Text(
                                                        'カメラ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: SizedBox(
                                                        height: 44,
                                                        child: FlatButton.icon(
                                                          onPressed: () {
                                                            model
                                                                .onVideoPressPick(
                                                                    index_page!,
                                                                    index);
                                                          },
                                                          icon: const Icon(
                                                            Icons.collections,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                          color:
                                                              Colors.brown[400],
                                                          label: const Text(
                                                            'ギャラリー',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )))
                                              ],
                                            ) else Container(
                                              child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Container(
                                                    child: Card(
                                                      child: Column(
                                                        children: <Widget>[
                                                          AspectRatio(
                                                              aspectRatio: model
                                                                  .map_show[
                                                                      index_page!]
                                                                      [index]
                                                                  .aspectRatio,
                                                              child: Chewie(
                                                                controller: model
                                                                        .map_show[
                                                                    index_page!][index],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                /*IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: () async {
                                                    model.onPressDelete(index_page, index);
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 21,
                                                  ),
                                                )*/
                                              ],
                                            ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (attach == 'text') {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: Colors.orange,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const <Widget>[
                                              Icon(
                                                Icons.view_headline,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                '文章を入力',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        maxLengthEnforcement: MaxLengthEnforcement.none, enabled: true,
                                        controller: model.map_attach[index_page!]
                                            [index],
                                        // 入力数
                                        maxLength: 2000,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                      ),
                                      /*IconButton(
                                                padding: EdgeInsets.all(0),
                                                onPressed: () async {
                                                  model.onPressDelete(index_page, index);
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 21,
                                                ),
                                              )*/
                                    ],
                                  ),
                                )),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })),
                FlatButton.icon(
                  onPressed: () {
                    model.onPressAdd_new(index_page!, 'text');
                  },
                  icon: const Icon(
                    Icons.view_headline,
                    size: 20,
                    color: Colors.white,
                  ),
                  color: Colors.orange,
                  label: const Text(
                    '文章を追加',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    model.onPressAdd_new(index_page!, 'image');
                  },
                  icon: const Icon(
                    Icons.image,
                    size: 20,
                    color: Colors.white,
                  ),
                  color: Colors.green,
                  label: const Text(
                    '画像を追加',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    model.onPressAdd_new(index_page!, 'video');
                  },
                  icon: const Icon(
                    Icons.movie,
                    size: 20,
                    color: Colors.white,
                  ),
                  color: Colors.blue,
                  label: const Text(
                    '動画を追加',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                if (type == 'risu' ||
                        type == 'usagi' ||
                        type == 'sika' ||
                        type == 'kuma' ||
                        type == 'challenge') Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              activeColor: themeColor,
                              value: model.checkParent,
                              onChanged: model.onPressedCheckParent,
                            ),
                            const Text('保護者チェック')
                          ],
                        ),
                      ) else Container(),
                if (!model.isLoading[index_page!]) Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: RaisedButton.icon(
                          onPressed: () {
                            model.onTapSend(index_page);
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                          color: themeColor,
                          label: const Text(
                            'リーダーにサインをお願いする',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )) else Container(
                        child: Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color?>(themeColor),
                            ),
                          ),
                        ),
                      ),
              ],
            )))
      ]);
    });
  }
}
