import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/community/community_model.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityView extends StatelessWidget {
  var theme = new ThemeInfo();
  var task = new TaskContents();

  @override
  Widget build(BuildContext context) {
    Community info = ModalRoute.of(context).settings.arguments;
    String type = info.type;
    int page = info.page;
    String name = info.name;
    String taskid = info.taskid;
    String effortid = info.effortid;
    Color themeColor = theme.getThemeColor(type);
    var map_task = task.getPartMap(type, page);
    int quant = map_task['hasItem'];
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(map_task['title']),
        backgroundColor: themeColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/commentView',
              arguments: Comment(type: type, effortid: effortid));
        },
        label: Selector<CommunityModel, String>(
            selector: (context, model) => model.group,
            builder: (context, group, child) {
              if (group != null) {
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('comment')
                        .where('group', isEqualTo: group)
                        .where('effortID', isEqualTo: effortid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> querySnapshot) {
                      if (querySnapshot.hasData) {
                        if (querySnapshot.data.docs.length != 0) {
                          return Text('コメント ' +
                              querySnapshot.data.docs.length.toString() +
                              '件');
                        } else {
                          return Text('コメント');
                        }
                      } else {
                        return const Center(
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: CircularProgressIndicator()),
                        );
                      }
                    });
              } else {
                return Container();
              }
            }),
        icon: Icon(Icons.comment),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 65),
                  child: Column(
                    children: <Widget>[
                      /*Padding(
                          padding: EdgeInsets.all(17),
                          child: Container(
                              width: double.infinity,
                              child: Text(
                                map_task['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                                textAlign: TextAlign.left,
                              ))),*/
                      Padding(
                          padding:
                              EdgeInsets.only(top: 20, bottom: 15, left: 17),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 35,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                    ),
                                    textAlign: TextAlign.left,
                                  ))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Consumer<CommunityModel>(
                              builder: (context, model, child) {
                            model.getGroup();
                            if (model.group != null) {
                              return Column(
                                children: <Widget>[
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: Firestore.instance
                                          .collection(type)
                                          .document(taskid)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              asyncSnapshot) {
                                        if (asyncSnapshot.hasData) {
                                          DocumentSnapshot snapshot =
                                              asyncSnapshot.data;
                                          return Consumer<CommunityModel>(
                                              builder: (context, model, child) {
                                            model.getData(snapshot, quant);
                                            return model.isGet
                                                ? ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        map_task['hasItem'],
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index_number) {
                                                      Map<String, dynamic>
                                                          numberSnapshot =
                                                          snapshot.data()['signed'][
                                                              index_number
                                                                  .toString()];
                                                      print(numberSnapshot);
                                                      return Column(
                                                        children: <Widget>[
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 20,
                                                              ),
                                                              child: Container(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    (index_number +
                                                                            1)
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ))),
                                                          numberSnapshot['data'] !=
                                                                  null
                                                              ? Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: ListView
                                                                      .builder(
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: numberSnapshot['data']
                                                                              .length,
                                                                          itemBuilder: (BuildContext context,
                                                                              int
                                                                                  index) {
                                                                            String
                                                                                type =
                                                                                numberSnapshot['data'][index]['type'];
                                                                            if (type ==
                                                                                'image') {
                                                                              return Padding(
                                                                                padding: EdgeInsets.all(5),
                                                                                child: Material(
                                                                                    child: InkWell(
                                                                                  child: Container(
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        model.dataList[index_number][index] != null ? Image.network(model.dataList[index_number][index]) : Container()
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                              );
                                                                            } else if (type ==
                                                                                'video') {
                                                                              return Padding(
                                                                                  padding: EdgeInsets.all(5),
                                                                                  child: Material(
                                                                                    child: InkWell(
                                                                                      child: Container(
                                                                                        child: Column(
                                                                                          children: <Widget>[
                                                                                            model.dataList[index_number][index] != null
                                                                                                ? Chewie(
                                                                                                    controller: model.dataList[index_number][index],
                                                                                                  )
                                                                                                : Container()
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ));
                                                                            } else if (type ==
                                                                                'text') {
                                                                              return Padding(
                                                                                padding: EdgeInsets.all(5),
                                                                                child: Container(
                                                                                  child: Card(
                                                                                      child: Padding(
                                                                                    padding: EdgeInsets.all(0),
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        Padding(
                                                                                            padding: EdgeInsets.all(10),
                                                                                            child: Text(
                                                                                              model.dataList[index_number][index],
                                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
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
                                                              : Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 18,
                                                                      top: 8,
                                                                      bottom:
                                                                          8),
                                                                  child: Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child: Text(
                                                                          'データがありません')))
                                                        ],
                                                      );
                                                    })
                                                : Container();
                                          });
                                        } else {
                                          return const Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        }
                                      }),
                                  /*Padding(
                                  padding: EdgeInsets.only(top: 5, left: 17),
                                  child: Container(
                                      width: double.infinity,
                                      child: Text(
                                        '細目',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ))),
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: contents.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String content = contents[index];
                                        Color bordercolor;
                                        if (Theme.of(context).accentColor ==
                                            Colors.white) {
                                          bordercolor = Colors.grey[700];
                                        } else {
                                          bordercolor = Colors.grey[300];
                                        }
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 10, right: 5, left: 5),
                                          child: Card(
                                              color: Color(0x00000000),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: bordercolor,
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
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(content)),
                                              )),
                                        );
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, bottom: 65, right: 15),
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
                                  )),*/
                                ],
                              );
                            } else {
                              return const Center(
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: CircularProgressIndicator()),
                              );
                            }
                          }))
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
