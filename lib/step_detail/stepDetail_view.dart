import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/step_detail/stepDetail_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPageRoute extends TransitionRoute {
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

class StepDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    elevation: 2,
                    child: InkWell(
                        child: Selector<StepDetailModel, DocumentSnapshot>(
                      selector: (context, model) => model.stepSnapshot,
                      builder: (context, snapshot, child) =>
                          snapshot != null ?
                          Column(
                        children: <Widget>[
                          SingleChildScrollView(
                              child: Column(children: <Widget>[
                            Container(
                              color: Colors.orange,
                              child: Padding(
                                padding: EdgeInsets.only(top: 40, bottom: 20),
                                child: Center(
                                  child: Text(
                                    '笑顔１',
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
                                '完修済み🎉',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                '開始日',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                snapshot['start'].toDate().toString(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                '完修日',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                snapshot['end'].toDate().toString(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Center(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 5, top: 4),
                                    child: Icon(
                                      //ああああ
                                      Icons.chrome_reader_mode,
                                      color: Theme.of(context).accentColor,
                                      size: 22,
                                    ),
                                  ),
                                  Text(
                                    '内容はカブブックで確認しよう',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.none),
                                  ),
                                ])),
                          ]))
                        ],
                      ) :
                            Container()
                    )),
                  )),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      elevation: 7,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.collections_bookmark,
                            size: 40,
                            color: Colors.orange,
                          )),
                    ),
                  ))
            ])));
  }
}

class StepAddView extends StatelessWidget {
  int index_page;

  StepAddView(int index) {
    this.index_page = index;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                  height: 600,
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      child: /*SingleChildScrollView(
                        child: */Column(
                          children: <Widget>[
                            Consumer<StepDetailModel>(
                                builder: (context, model, _) {
                              if (!model.isGet) {
                                model.getSnapshot();
                              }
                              if (model.stepSnapshot != null){
                              if (model.stepSnapshot['signed']
                                      [index_page.toString()] ==
                                  null) {
                                return Column(children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.orange,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 40, bottom: 20),
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
                                    height: 485,
                                      child:
                                  SingleChildScrollView(
                                      child: Column(
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 20, right: 20),
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
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: model
                                                  .list_attach[index_page]
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                String attach = model
                                                        .list_attach[index_page]
                                                    [index];
                                                if (attach == 'image') {
                                                  return Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Container(
                                                      child: Card(
                                                        color: Colors.green,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons.image,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  Text(
                                                                    '画像を選ぶ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  child:
                                                                      SizedBox(
                                                                    height: 44,
                                                                    child:
                                                                        FlatButton
                                                                            .icon(
                                                                      onPressed:
                                                                          () {
                                                                        model
                                                                            .onImagePressCamera(index_page,index);
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .camera_alt,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      color: Colors
                                                                              .blueGrey[
                                                                          400],
                                                                      label:
                                                                          Text(
                                                                        'カメラ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child: SizedBox(
                                                                        height: 44,
                                                                        child: FlatButton.icon(
                                                                          onPressed:
                                                                              () {
                                                                            model.onImagePressPick(index_page,index);
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.collections,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          color:
                                                                              Colors.brown[400],
                                                                          label:
                                                                              Text(
                                                                            'ギャラリー',
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white),
                                                                          ),
                                                                        )))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else if (attach == 'movie') {
                                                  return Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Container(
                                                      child: Card(
                                                        color: Colors.blue,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons.movie,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  Text(
                                                                    '動画を選ぶ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  child:
                                                                      SizedBox(
                                                                    height: 44,
                                                                    child:
                                                                        FlatButton
                                                                            .icon(
                                                                      onPressed:
                                                                          () {
                                                                        model
                                                                            .onVideoPressCamera(index_page, index);
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .camera_alt,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      color: Colors
                                                                              .blueGrey[
                                                                          400],
                                                                      label:
                                                                          Text(
                                                                        'カメラ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child: SizedBox(
                                                                        height: 44,
                                                                        child: FlatButton.icon(
                                                                          onPressed:
                                                                              () {
                                                                            model.onVideoPressPick(index_page, index);
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.collections,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          color:
                                                                              Colors.brown[400],
                                                                          label:
                                                                              Text(
                                                                            'ギャラリー',
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white),
                                                                          ),
                                                                        )))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else if (attach ==
                                                    'sentence') {
                                                  return Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Container(
                                                      child: Card(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  color: Colors.orange,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                          Icons
                                                                              .view_headline,
                                                                          color:
                                                                              Colors.white,
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
                                                                  maxLengthEnforced:
                                                                      false,
                                                                  onChanged:(text){ model.onTextChanged(index_page, index, text);},
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
                                          model.onPressAdd_new(
                                              index_page, 'sentence');
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
                                          model.onPressAdd_new(
                                              index_page, 'image');
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
                                          model.onPressAdd_new(
                                              index_page, 'movie');
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Checkbox(
                                              activeColor: Colors.orange,
                                              value: model.checkParent,
                                              onChanged:
                                                  model.onPressedCheckParent,
                                            ),
                                            Text('保護者チェック')
                                          ],
                                        ),
                                      ),
                                      RaisedButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        color: Colors.orange,
                                        label: Text(
                                          'リーダーにサインをお願いする',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )))
                                ]);
                              } else {
                                return Column(children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.orange,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 40, bottom: 20),
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
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      model.stepSnapshot['signed']
                                      [index_page.toString()]['time'].toDate().toString() +  model.stepSnapshot['signed'][index_page.toString()]['family'],
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                ]);
                              }
                            } else {
                                return Container();
                              }})
                          ],
                        ),
//                      ),
                    ),
                  ))),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 70,
                width: 70,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                  elevation: 7,
                  child: Center(
                    child: Text(
                      (index_page + 1).toString(),
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                  ),
                ),
              ))
        ]));
  }
}
