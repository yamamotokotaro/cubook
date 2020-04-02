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
                      child: Column(
                        children: <Widget>[
                          SingleChildScrollView(
                              child: Column(children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
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
                                '2020/3/30 ',
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
                                '2020/4/5',
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
                      ),
                    ),
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

class StepSignView extends StatelessWidget {
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
                      child: Column(
                        children: <Widget>[
                          SingleChildScrollView(
                              child: Column(children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.orange,
                              child: Padding(
                                padding: EdgeInsets.only(top: 40, bottom: 20),
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
                                '2020/4/5 山本',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ]))
                        ],
                      ),
                    ),
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
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                      ),
                    ),
                  ))
            ])));
  }
}

class StepAddView extends StatelessWidget {
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Consumer<StepDetailModel>(
                                builder: (context, model, _) {
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
                                Column(
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
                                            itemCount:
                                                model.list_isSelected.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Container(
                                                  height: 52,
                                                  child: Card(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: SizedBox(
                                                                height: 44,
                                                                child:
                                                                    FlatButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(
                                                                    Icons
                                                                        .view_headline,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  color: Colors
                                                                      .orange,
                                                                  label: Text(
                                                                    '文章',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                height: 44,
                                                                child:
                                                                    FlatButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: Icon(
                                                                    Icons.image,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  color: Colors
                                                                      .green,
                                                                  label: Text(
                                                                    '画像',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: SizedBox(
                                                                    height: 44,
                                                                    child:
                                                                        FlatButton
                                                                            .icon(
                                                                      onPressed:
                                                                          () {},
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .movie,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      color: Colors
                                                                          .blue,
                                                                      label:
                                                                          Text(
                                                                        '動画',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
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
                                            })),
                                    FlatButton.icon(
                                      onPressed: () {
                                        model.onPressAdd();
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.orange,
                                      ),
                                      label: Text('文章・写真・動画をつける'),
                                      textColor: Colors.orange,
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
                                )
                              ]);
                            })
                          ],
                        ),
                      ),
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
                      '2',
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
