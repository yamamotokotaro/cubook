import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/Support/Support_model.dart';
import 'package:cubook/invite/invite_model.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SupportView extends StatelessWidget {
  var list_type = ['red', 'yellow', 'blue', 'green'];
  var list_color = [Colors.red, Colors.yellow[700], Colors.blue, Colors.green];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('運営を支援'),
        ),
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                  child: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child:
                        Consumer<InviteModel>(builder: (context, model, child) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Material(
                                                    type: MaterialType
                                                        .transparency,
                                                    child: Text(
                                                      '継続的な運営をご支援ください',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    )))),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 7, bottom: 10, right: 10),
                                            child: Material(
                                                type: MaterialType.transparency,
                                                child: Text(
                                                  'cubookは個人で開発・運営を行っています。今後も継続的に運営と改善を行うためにご支援賜りますようお願い申し上げます。支援は動画広告を最後まで見ることで行うことができます。視聴後にお礼としてアプリ内でロープを差し上げます。ロープの色はランダムで決まります。',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 17,
                                                  ),
                                                ))),
                                      ],
                                    ))),
                          ),
                          Consumer<SupportModel>(
                              builder: (context, model, child) {
                            model.getUser();
                            model.getAdmob(context);
                            return /*RaisedButton(
                                child: Text("SHOW REWARDED VIDEOAD"),
                                onPressed: () {
                                  model.videoAd.show();
                                });*/
                                !model.isLoaded
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                            child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 8,
                                          color: Colors.blue[900],
                                          child: InkWell(
                                            onTap: () {
                                              model.videoAd.show();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Material(
                                                            type: MaterialType
                                                                .transparency,
                                                            child: Text(
                                                              '広告を再生',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 30,
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ]),
                                            ),
                                          ),
                                        )),
                                      );
                          }),
                          Selector<SupportModel, String>(
                              selector: (context, model) => model.uid,
                              builder: (context, uid, child) => uid != null
                                  ? StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('user')
                                          .where('uid', isEqualTo: uid)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        DocumentSnapshot userSnapshot =
                                            snapshot.data.documents[0];
                                        return Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Container(
                                                  height: 70,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: list_type.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      int count = 0;
                                                      if (userSnapshot[
                                                              list_type[
                                                                  index]] !=
                                                          null) {
                                                        count = userSnapshot[
                                                            list_type[index]];
                                                      }
                                                      return Container(
                                                        height: 70,
                                                        width: 100,
                                                        child: Card(
                                                            color: list_color[
                                                                index],
                                                            child: Center(
                                                                child: Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        SvgPicture
                                                                            .asset(
                                                                          'assets/svg/rope.svg',
                                                                          semanticsLabel:
                                                                              'shopping',
                                                                          color:
                                                                              Colors.white,
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                        ),
                                                                        Text(
                                                                          count
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 20,
                                                                              color: Colors.white),
                                                                        )
                                                                      ],
                                                                    )))),
                                                      );
                                                    },
                                                  ),
                                                )));
                                      })
                                  : Container())
                        ],
                      );
                    })),
              )));
        }));
  }
}
