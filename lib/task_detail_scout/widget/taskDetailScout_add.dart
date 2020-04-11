import 'dart:io';

import 'package:cubook/task_detail_scout/widget/videoView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../taskDetailScout_model.dart';

class TaskDetailScoutAddView extends StatelessWidget {
  int index_page;
  String type;
  Color themeColor;

  TaskDetailScoutAddView(int _index, String _type) {
    if (_type == 'usagi') {
      themeColor = Colors.orange;
    } else if (_type == 'sika') {
      themeColor = Colors.green;
    } else if (_type == 'kuma') {
      themeColor = Colors.blue;
    } else if (_type == 'challenge') {
      themeColor = Colors.green[900];
    }
    index_page = _index;
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDetailScoutModel>(builder: (context, model, _) {
      return Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          color: themeColor,
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
            height: MediaQuery.of(context).size.height > 700 ? MediaQuery.of(context).size.height-334 : MediaQuery.of(context).size.height-228,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Text(
                      'どんなことをしたのかリーダーに教えよう',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.list_attach[index_page].length,
                        itemBuilder: (BuildContext context, int index) {
                          String attach = model.list_attach[index_page][index];
                          if (attach == 'image') {
                            return Padding(
                              padding: EdgeInsets.all(5),
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
                                              child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                '選択済み',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (attach == 'video') {
                            return Padding(
                              padding: EdgeInsets.all(5),
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
                                              child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                '選択済み',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (attach == 'text') {
                            return Padding(
                              padding: EdgeInsets.all(5),
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
                                        // 入力数
                                        maxLength: 2000,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        maxLengthEnforced: false,
                                        onChanged: (text) {
                                          model.onTextChanged(
                                              index_page, index, text);
                                        },
                                      ),
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
                /*FlatButton.icon(
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
                ),*/
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
                        child: Container(child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor),),),),
                      ),
              ],
            )))
      ]);
    });
  }
}
