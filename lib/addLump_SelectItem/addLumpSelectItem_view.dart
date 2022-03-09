import 'package:cubook/addLump_SelectItem/addLumpSelectItem_model.dart';
import 'package:cubook/addLump_SelectItem/widget/taskList_view.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabInfo {
  String label;
  Widget widget;

  TabInfo(this.label, this.widget);
}

class AddLumpSelectItemView extends StatelessWidget {
  ThemeInfo theme = ThemeInfo();

  final List<TabInfo> _tabs = [
    TabInfo('うさぎのカブブック', TaskView('usagi')),
    TabInfo('しかのカブブック', TaskView('sika')),
    TabInfo('くまのカブブック', TaskView('kuma')),
    TabInfo('月の輪', TaskView('tukinowa')),
    TabInfo('チャレンジ章', TaskView('challenge')),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String>? uids = ModalRoute.of(context)!.settings.arguments as List<String>?;
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('サインする項目を選択'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30.0),
              child: TabBar(
                isScrollable: true,
                tabs: _tabs.map((TabInfo tab) {
                  return Tab(text: tab.label);
                }).toList(),
              ),
            ),
          ),
          floatingActionButton: Consumer<AddLumpSelectItemModel>(
            builder: (BuildContext context, AddLumpSelectItemModel model, Widget? child) => FloatingActionButton.extended(
              onPressed: () {
                model.onPressedSend(uids, context);
              },
              label: const Text('決定'),
              icon: const Icon(Icons.check),
            ),
          ),
          body: TabBarView(children: _tabs.map((TabInfo tab) => tab.widget).toList()),
        ));
  }
}
