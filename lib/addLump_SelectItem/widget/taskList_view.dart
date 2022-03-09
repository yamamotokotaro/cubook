import 'package:cubook/addLump_SelectItem/addLumpSelectItem_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskView extends StatelessWidget {
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();
  Color? themeColor;
  String? type;
  String? typeFireStore;
  String? title = '';
  int index_number = -1;

  TaskView(String _type) {
    themeColor = theme.getThemeColor(_type);
    title = theme.getTitle(_type);
    if (_type == 'usagi') {
      typeFireStore = 'step';
    } else if (_type == 'challenge') {
      typeFireStore = 'challenge';
    }
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 70),
                  child: Consumer<AddLumpSelectItemModel>(
                      builder: (BuildContext context, AddLumpSelectItemModel model, Widget? child) {
                    final List<Map<String, dynamic>> mapTask = task.getAllMap(type)!;
                    final int taskLength = mapTask.length;
                    if (model.itemSelected[type] == null) {
                      model.createList(type, taskLength);
                    }
                    if (model.itemSelected[type] != null) {
                      final List<dynamic>? listItemCheck = model.itemSelected[type];
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: taskLength,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int indexPage) {
                            final Map<String, dynamic> mapItem =
                                mapTask[indexPage];
                            return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                    child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            color: themeColor),
                                        height: 120,
                                        child: ConstrainedBox(
                                          constraints:
                                              const BoxConstraints(minWidth: 76),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Text(
                                                mapItem['number'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    mapItem['title'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  ))),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                    height: 37,
                                                    width: 250,
                                                    child: ListView.builder(
                                                        itemCount:
                                                            mapItem['hasItem'],
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          index_number++;
                                                          if (listItemCheck![
                                                                      indexPage]
                                                                  .length ==
                                                              0) {
                                                            model.createbool(
                                                                type,
                                                                indexPage,
                                                                mapItem[
                                                                    'hasItem']);
                                                          }

                                                          if (listItemCheck[
                                                                      indexPage]
                                                                  .length !=
                                                              0) {
                                                            return Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            3),
                                                                child: Semantics(
                                                                    hint: 'さいもく' + (index + 1).toString() + 'を選択する',
                                                                    child: InkWell(
                                                                        customBorder: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30.0),
                                                                        ),
                                                                        onTap: () {
                                                                          model.onPressedCheck(
                                                                              type,
                                                                              indexPage,
                                                                              index);
                                                                        },
                                                                        child: listItemCheck[indexPage][index]
                                                                            ? Container(
                                                                                height: 37,
                                                                                width: 37,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(40),
                                                                                  color: themeColor,
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    (index + 1).toString(),
                                                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                                                                                  ),
                                                                                ))
                                                                            : Container(
                                                                                height: 37,
                                                                                width: 37,
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(color: Theme.of(context).hintColor),
                                                                                  borderRadius: BorderRadius.circular(40),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    (index + 1).toString(),
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Theme.of(context).hintColor),
                                                                                  ),
                                                                                )))));
                                                          } else {
                                                            return Container();
                                                          }
                                                        }))),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                                )));
                          });
                    } else {
                      return Container();
                    }
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
