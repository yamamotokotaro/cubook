import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../taskDetailScout_model.dart';

class TaskDetailScoutAddView extends StatelessWidget {
  int index_page;
  String type;
  String mes;
  Color themeColor;
  int countChewie;
  var task = new Task();
  var theme = new ThemeInfo();

  TaskDetailScoutAddView(int _index, String _type, String _mes) {
    themeColor = theme.getThemeColor(_type);
    index_page = _index;
    type = _type;
    mes = _mes;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDetailScoutModel>(builder: (context, model, _) {
      countChewie = 0;
      return Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20)),
              color: themeColor),
          child: Padding(
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
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Text(
                      mes,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
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
                                          child: Text(
                                            task.getContent(type,
                                                model.numberPushed, index_page).toString(),
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
                                            '\n公財ボーイスカウト日本連盟「令和2年版 諸規定」',
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
                        Icons.sort ,
                        size: 20,
                      ),
                      label: Text(
                        '内容を見る',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.list_attach[index_page].length,
                        itemBuilder: (BuildContext context, int index) {
                          String attach = model.list_attach[index_page][index];
                          if (attach == 'image') {
                            return Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                child: Card(
                                  color: Colors.green,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
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
                                      model.map_attach[index_page][index] ==
                                              null
                                          ? Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 44,
                                                    child: FlatButton.icon(
                                                      onPressed: () {
                                                        model
                                                            .onImagePressCamera(
                                                                index_page,
                                                                index);
                                                      },
                                                      icon: Icon(
                                                        Icons.camera_alt,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      color:
                                                          Colors.blueGrey[400],
                                                      label: Text(
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
                                                                    index_page,
                                                                    index);
                                                          },
                                                          icon: Icon(
                                                            Icons.collections,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                          color:
                                                              Colors.brown[400],
                                                          label: Text(
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
                                            )
                                          : Container(
                                              child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                    child: Card(
                                                      color: Colors.green,
                                                      child: Column(
                                                        children: <Widget>[
                                                          model.map_attach[
                                                                      index_page]
                                                                  [
                                                                  index] is File
                                                              ? Image.file(model
                                                                          .map_attach[
                                                                      index_page]
                                                                  [index])
                                                              : Image.network(
                                                                  model.map_show[
                                                                          index_page]
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
                              padding: EdgeInsets.all(0),
                              child: Container(
                                child: Card(
                                  color: Colors.blue,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
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
                                      model.map_attach[index_page][index] ==
                                              null
                                          ? Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 44,
                                                    child: FlatButton.icon(
                                                      onPressed: () {
                                                        model
                                                            .onVideoPressCamera(
                                                                index_page,
                                                                index);
                                                      },
                                                      icon: Icon(
                                                        Icons.camera_alt,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      color:
                                                          Colors.blueGrey[400],
                                                      label: Text(
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
                                                                    index_page,
                                                                    index);
                                                          },
                                                          icon: Icon(
                                                            Icons.collections,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                          color:
                                                              Colors.brown[400],
                                                          label: Text(
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
                                            )
                                          : Container(
                                              child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                    child: Card(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Chewie(
                                                            controller: model
                                                                        .map_show[
                                                                    index_page]
                                                                [index],
                                                          )
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
                              padding: EdgeInsets.all(0),
                              child: Container(
                                child: Card(
                                    child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: Colors.orange,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
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
                                      new TextField(
                                        enabled: true,
                                        controller: model.map_attach[index_page]
                                            [index],
                                        // 入力数
                                        maxLength: 2000,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        maxLengthEnforced: false,
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
                    model.onPressAdd_new(index_page, 'text');
                  },
                  icon: Icon(
                    Icons.view_headline,
                    size: 20,
                    color: Colors.white,
                  ),
                  color: Colors.orange,
                  label: Text(
                    '文章を追加',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    model.onPressAdd_new(index_page, 'image');
                  },
                  icon: Icon(
                    Icons.image,
                    size: 20,
                    color: Colors.white,
                  ),
                  color: Colors.green,
                  label: Text(
                    '画像を追加',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    model.onPressAdd_new(index_page, 'video');
                  },
                  icon: Icon(
                    Icons.movie,
                    size: 20,
                    color: Colors.white,
                  ),
                  color: Colors.blue,
                  label: Text(
                    '動画を追加',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        activeColor: themeColor,
                        value: model.checkParent,
                        onChanged: model.onPressedCheckParent,
                      ),
                      Text('保護者チェック')
                    ],
                  ),
                ),
                !model.isLoading[index_page]
                    ? RaisedButton.icon(
                        onPressed: () {
                          model.onTapSend(index_page);
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                        color: themeColor,
                        label: Text(
                          'リーダーにサインをお願いする',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    : Container(
                        child: Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
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
