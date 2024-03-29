import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/listAbsent/listAbsent_view.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/settingGroupAccount/settingAccount_view.dart';
import 'package:cubook/userDetail/userDetail_model.dart';
import 'package:cubook/userDetail/widget/selectBook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).canvasColor, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class SelectBookView extends StatelessWidget {
  SelectBookView(String? uid, String type) {
    this.uid = uid;
    this.type = type;
  }
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  String? uid;
  String? type;

  late List<TabInfo> _tabs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('メンバー詳細'),
        ),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Consumer<UserDetailModel>(builder: (BuildContext context,
                    UserDetailModel model, Widget? child) {
                  model.getGroup();
                  if (model.group != null) {
                    if (type == 'scout') {
                      if (model.teamPosition != null) {
                        if (model.teamPosition == 'teamLeader') {
                          _tabs = [
                            TabInfo('進歩', SelectBook(uid)),
                            TabInfo('出欠', ListAbsentView(uid)),
                          ];
                        } else {
                          _tabs = [
                            TabInfo('進歩', SelectBook(uid)),
                            //TabInfo("表彰待ち", ListNotCititationed(uid)),
                            TabInfo('出欠', ListAbsentView(uid)),
                            TabInfo('設定', SettingAccountGroupView(uid)),
                          ];
                        }
                      } else {
                        _tabs = [
                          TabInfo('進歩', SelectBook(uid)),
                          //TabInfo("表彰待ち", ListNotCititationed(uid)),
                          TabInfo('出欠', ListAbsentView(uid)),
                          TabInfo('設定', SettingAccountGroupView(uid)),
                        ];
                      }
                    } else if (type == 'leader') {
                      _tabs = [
                        TabInfo('設定', SettingAccountGroupView(uid)),
                      ];
                    }
                    return DefaultTabController(
                        length: _tabs.length,
                        child: NestedScrollView(
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Consumer<UserDetailModel>(builder:
                                      (BuildContext context,
                                          UserDetailModel model,
                                          Widget? child) {
                                    model.getGroup();
                                    if (model.group != null) {
                                      return StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('user')
                                            .where('group',
                                                isEqualTo: model.group)
                                            .where('uid', isEqualTo: uid)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            final DocumentSnapshot
                                                userSnapshot =
                                                snapshot.data!.docs[0];
                                            return Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16, bottom: 10),
                                                  child: Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            theme.getUserColor(
                                                                userSnapshot
                                                                    .get(
                                                                        'age')),
                                                        shape: BoxShape.circle),
                                                    child: const Icon(
                                                      Icons.person,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Text(
                                                      userSnapshot.get('name'),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25),
                                                    )),
                                              ],
                                            );
                                          } else {
                                            return const Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          }
                                        },
                                      );
                                    } else {
                                      return const Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: CircularProgressIndicator()),
                                      );
                                    }
                                  }),
                                ]),
                              ),
                              Container(
                                  child: SliverPersistentHeader(
                                pinned: true,
                                delegate: _StickyTabBarDelegate(
                                  TabBar(
                                    indicatorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    labelColor:
                                        Theme.of(context).colorScheme.secondary,
                                    isScrollable: false,
                                    tabs: _tabs.map((TabInfo tab) {
                                      return Tab(text: tab.label);
                                    }).toList(),
                                  ),
                                ),
                              )),
                            ];
                          },
                          body: TabBarView(
                              children: _tabs
                                  .map((TabInfo tab) => tab.widget)
                                  .toList()),
                        ));
                  } else {
                    return const Center(
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator()),
                    );
                  }
                }))));
  }
}
