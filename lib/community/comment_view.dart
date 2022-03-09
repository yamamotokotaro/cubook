import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/community/community_model.dart';
import 'package:cubook/model/arguments.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CommentView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();
  TaskContents task = TaskContents();

  @override
  Widget build(BuildContext context) {
    final Comment info = ModalRoute.of(context).settings.arguments;
    final String type = info.type;
    final String effortid = info.effortid;
    final Color themeColor = theme.getThemeColor(type);
    bool isDark;
    if (Theme.of(context).colorScheme.secondary == Colors.white) {
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
            title: const Text('コメント'),
            backgroundColor: themeColor,
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
              child: Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 100),
                            child: Consumer<CommunityModel>(
                                builder: (BuildContext context, CommunityModel model, Widget child) {
                              model.getGroup();
                              if (model.group != null) {
                                return Column(
                                  children: <Widget>[
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
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
                                                    .data.docs.length,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final DocumentSnapshot snapshot =
                                                      querySnapshot.data
                                                          .docs[index];
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5),
                                                    child: InkWell(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                        },
                                                        onLongPress: () async {
                                                          if (model.user.uid ==
                                                              snapshot.get('uid')) {
                                                            await showModalBottomSheet<
                                                                int>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Padding(
                                                                    padding: const EdgeInsets.only(
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
                                                                              const Icon(Icons.delete),
                                                                          title:
                                                                              const Text('コメントを削除する'),
                                                                          onTap:
                                                                              () {
                                                                            model.deleteComent(snapshot.id);
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
                                                                padding: const EdgeInsets
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
                                                                          snapshot.get(
                                                                              'age')),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: const Icon(
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
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          snapshot.get(
                                                                              'name'),
                                                                          style:
                                                                              const TextStyle(
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
                                                                    padding: const EdgeInsets.only(
                                                                        top: 3,
                                                                        left: 5,
                                                                        bottom:
                                                                            5),
                                                                    child: Text(
                                                                      snapshot.get(
                                                                          'body'),
                                                                      style:
                                                                          const TextStyle(
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
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                          child: Container(
                            width: 100,
                            child: Consumer<CommunityModel>(
                                builder: (BuildContext context, CommunityModel model, Widget child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: TextField(
                                      maxLengthEnforcement: MaxLengthEnforcement.none, controller: model.commentController,
                                      enabled: true,
                                      // 入力数
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                          labelText: 'コメントを入力',
                                          hintText: 'きれいな言葉を使いましょう'),
                                      onChanged: (String text) {
                                        //model.joinCode = text;
                                      },
                                    ),
                                  ),
                                  if (model.isLoading_comment) Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5, left: 10, right: 6),
                                          child: Container(
                                              width: 32,
                                              height: 32,
                                              child:
                                                  const CircularProgressIndicator())) else Padding(
                                          padding: const EdgeInsets.only(top: 13),
                                          child: IconButton(
                                            onPressed: () {
                                              model.sendComment(
                                                  effortid, context);
                                            },
                                            icon: const Icon(Icons.send),
                                            color:
                                                Theme.of(context).colorScheme.secondary,
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
