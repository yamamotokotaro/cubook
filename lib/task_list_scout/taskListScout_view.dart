import 'package:cubook/model/class.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout/taskDetailScout_view.dart';
import 'package:cubook/task_list_scout/taskListScout_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListScoutView extends StatelessWidget {
  TaskListScoutView(String? _type) {
    themeColor = theme.getThemeColor(_type);
    title = theme.getTitle(_type);
    if (_type == 'usagi') {
      typeFireStore = 'step';
    } else if (_type == 'challenge') {
      typeFireStore = 'challenge';
    }
    type = _type;
  }

  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  Color? themeColor;
  String? type;
  String? typeFireStore;
  String? title = '';

  @override
  Widget build(BuildContext context) {
    final bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: themeColor!);
    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Consumer<TaskListScoutModel>(builder:
                        (BuildContext context, TaskListScoutModel model,
                            Widget? child) {
                      if (!model.isGet) {
                        model.getSnapshot();
                      }
                      if (model.userSnapshot != null) {
                        final List<Map<String, dynamic>> mapTask =
                            task.getAllMap(type)!;
                        final List<bool> listIsCompleted =
                            List.generate(mapTask.length, (int index) => false);
                        final List<double?> listPercentage =
                            List.generate(mapTask.length, (int index) => 0.0);
                        if (model.userData![type!] != null) {
                          final Map map = Map<String, dynamic>.from(
                              model.userSnapshot!.get(type!));
                          for (int i = 0; i < mapTask.length; i++) {
                            if (map.containsKey(i.toString())) {
                              listPercentage[i] =
                                  model.userSnapshot!.get(type!)[i.toString()] /
                                      mapTask[i]['hasItem'].toDouble();
                            }
                          }
                        }
                        for (int i = 0; i < listPercentage.length; i++) {
                          if (listPercentage[i] == 1.0) {
                            listIsCompleted[i] = true;
                          }
                        }
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: mapTask.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    child: Card(
                                      color: scheme.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: InkWell(
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push<dynamic>(
                                              MyPageRoute(
                                                  page: showTaskView(
                                                      index, type, 0),
                                                  dismissible: true));
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10)),
                                                    color: themeColor),
                                                height: 120,
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 76),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Text(
                                                        mapTask[index]
                                                            ['number'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 30,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              mapTask[index]
                                                                  ['title'],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25),
                                                            ))),
                                                    if (listIsCompleted[index])
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                              'かんしゅう🎉',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 20),
                                                            )),
                                                      )
                                                    else
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Row(
                                                            children: <Widget>[
                                                              const Text('達成度'),
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10),
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    backgroundColor: isDark
                                                                        ? Colors.grey[
                                                                            700]
                                                                        : Colors
                                                                            .grey[300],
                                                                    valueColor: AlwaysStoppedAnimation<Color?>(isDark
                                                                        ? Colors
                                                                            .white
                                                                        : theme.getThemeColor(
                                                                            type)),
                                                                    value: listPercentage[
                                                                        index],
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
