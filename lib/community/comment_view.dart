import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/community/community_model.dart';
import 'package:cubook/detailActivity/detailActivity_model.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentView extends StatelessWidget {
  var theme = new ThemeInfo();
  var task = new Task();

  @override
  Widget build(BuildContext context) {
    Comment info = ModalRoute.of(context).settings.arguments;
    String type = info.type;
    String effortid = info.effortid;
    Color themeColor = theme.getThemeColor(type);
    bool isDark;
    if (Theme.of(context).accentColor == Colors.white) {
      isDark = true;
    } else {
      isDark = false;
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('コメント'),
            backgroundColor: themeColor,
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
              child: Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 100),
                            child: Consumer<CommunityModel>(
                                builder: (context, model, child) {
                              model.getGroup();
                              if (model.group != null) {
                                return Column(
                                  children: <Widget>[
                                    StreamBuilder<QuerySnapshot>(
                                        stream: Firestore.instance
                                            .collection('comment')
                                            .where('group',
                                                isEqualTo: model.group)
                                            .where('effortID',
                                                isEqualTo: effortid)
                                            .orderBy('time', descending: false)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                querySnapshot) {
                                          if (querySnapshot.hasData) {
                                            return ListView.builder(
                                                controller:
                                                    model.scrollController,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: querySnapshot
                                                    .data.documents.length,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  DocumentSnapshot snapshot =
                                                      querySnapshot.data
                                                          .documents[index];
                                                  return Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: InkWell(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                        },
                                                        onLongPress: () async {
                                                          if (model.user.uid ==
                                                              snapshot['uid']) {
                                                            await showModalBottomSheet<
                                                                int>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        ListTile(
                                                                          leading:
                                                                              Icon(Icons.delete),
                                                                          title:
                                                                              Text('コメントを削除する'),
                                                                          onTap:
                                                                              () {
                                                                            model.deleteComent(snapshot.documentID);
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ));
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 10,
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                child:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color: theme.getUserColor(
                                                                          snapshot[
                                                                              'age']),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )),
                                                            Flexible(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          snapshot[
                                                                              'name'],
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        )),
                                                                    // Spacer(),
                                                                    /*Text(
                                                                DateFormat(
                                                                        'MM/dd')
                                                                    .format(snapshot[
                                                                            'time']
                                                                        .toDate())
                                                                    .toString(),
                                                                  style: TextStyle(
                                                                    color: Colors.grey
                                                                  ),
                                                              )*/
                                                                  ],
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 3,
                                                                        left: 5,
                                                                        bottom:
                                                                            5),
                                                                    child: Text(
                                                                      snapshot[
                                                                          'body'],
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            19,
                                                                      ),
                                                                    ))
                                                              ],
                                                            ))
                                                          ],
                                                        )),
                                                  );
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
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, right: 10),
                          child: Container(
                            width: 100,
                            child: Consumer<CommunityModel>(
                                builder: (context, model, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: TextField(
                                      controller: model.commentController,
                                      enabled: true,
                                      // 入力数
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      maxLengthEnforced: false,
                                      decoration: InputDecoration(
                                          labelText: "コメントを入力",
                                          hintText: 'きれいな言葉を使いましょう'),
                                      onChanged: (text) {
                                        //model.joinCode = text;
                                      },
                                    ),
                                  ),
                                  model.isLoading_comment
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 5, left: 10, right: 6),
                                          child: Container(
                                              width: 32,
                                              height: 32,
                                              child:
                                                  CircularProgressIndicator()))
                                      : Padding(
                                          padding: EdgeInsets.only(top: 13),
                                          child: IconButton(
                                            onPressed: () {
                                              model.sendComment(
                                                  effortid, context);
                                            },
                                            icon: Icon(Icons.send),
                                            color:
                                                Theme.of(context).accentColor,
                                          ))
                                ],
                              );
                            }),
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ))),
    );
  }
}
