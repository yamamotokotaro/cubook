import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/listAbsent/listAbsent_view.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/setting_account_group/settingAccount_view.dart';
import 'package:cubook/userDetail/userDetail_model.dart';
import 'package:cubook/userDetail/widget/list_notCititationed.dart';
import 'package:cubook/userDetail/widget/selectBook.dart';
import 'package:flutter/cupertino.dart';
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
  var task = new Task();
  var theme = new ThemeInfo();
  String uid;

  List<TabInfo> _tabs;

  SelectBookView(String uid) {
    this.uid = uid;
    _tabs = [
      TabInfo("進歩", SelectBook(uid)),
      TabInfo("表彰待ち", ListNotCititationed(uid)),
      TabInfo("出欠", ListAbsentView(uid)),
      TabInfo("設定", SettingAccountView(uid)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('メンバー詳細'),
        ),
        body: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: DefaultTabController(
                    length: _tabs.length,
                    child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Consumer<UserDetailModel>(
                                    builder: (context, model, child) {
                                  model.getGroup();
                                  if (model.group != null) {
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('user')
                                          .where('group',
                                              isEqualTo: model.group)
                                          .where('uid', isEqualTo: uid)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          DocumentSnapshot userSnapshot =
                                              snapshot.data.documents[0];
                                          return Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 16, bottom: 10),
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          theme.getUserColor(
                                                              userSnapshot[
                                                                  'age']),
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Text(
                                                    userSnapshot['name'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
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
                                  indicatorColor: Theme.of(context).accentColor,
                                  labelColor: Theme.of(context).accentColor,
                                  isScrollable: false,
                                  tabs: _tabs.map((TabInfo tab) {
                                    return Tab(text: tab.label);
                                  }).toList(),
                                ),
                              ),
                            )),
                          ];
                        },
                        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),)))));
  }
}
