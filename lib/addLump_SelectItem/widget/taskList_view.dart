import 'package:cubook/addLump_SelectItem/addLumpSelectItem_model.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskView extends StatelessWidget {
  var task = new Task();
  var theme = new ThemeInfo();
  Color themeColor;
  String type;
  String typeFireStore;
  String title = '';
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
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 70),
                  child: Consumer<AddLumpSelectItemModel>(
                      builder: (context, model, child) {
                    var map_task = task.getAllMap(type);
                    int task_length = map_task.length;
                    if (model.itemSelected[type] == null) {
                      model.createList(type, task_length);
                    }
                    if (model.itemSelected[type] != null) {
                      List<dynamic> list_itemCheck = model.itemSelected[type];
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: task_length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index_page) {
                            Map<String, dynamic> map_item = map_task[index_page];
                            return Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                    child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(10),
                                                bottomLeft:
                                                    const Radius.circular(10)),
                                            color: themeColor),
                                        height: 120,
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(minWidth: 76),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Text(
                                                map_item['number'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    map_item['title'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  ))),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                    height: 37,
                                                    width: 250,
                                                    child: ListView.builder(
                                                        itemCount:
                                                            map_item['hasItem'],
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          index_number++;
                                                          if(list_itemCheck[index_page].length == 0){
                                                            model.createbool(type, index_page, map_item['hasItem']);
                                                          }

                                                          if(list_itemCheck[index_page].length != 0) {
                                                            return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    right: 3),
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      model
                                                                          .onPressedCheck(
                                                                          type,
                                                                          index_page,
                                                                      index);
                                                                    },
                                                                    child: list_itemCheck[index_page][index]
                                                                        ? Container(
                                                                        height:
                                                                        37,
                                                                        width:
                                                                        37,
                                                                        decoration:
                                                                        BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                              40),
                                                                          color:
                                                                          themeColor,
                                                                        ),
                                                                        child:
                                                                        Center(
                                                                          child:
                                                                          Text(
                                                                            (index +
                                                                                1)
                                                                                .toString(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight
                                                                                    .bold,
                                                                                fontSize: 22,
                                                                                color: Colors
                                                                                    .white),
                                                                          ),
                                                                        ))
                                                                        : Container(
                                                                        height:
                                                                        37,
                                                                        width:
                                                                        37,
                                                                        decoration:
                                                                        BoxDecoration(
                                                                          border:
                                                                          Border
                                                                              .all(
                                                                              color: Theme.of(context).hintColor

                                                                          ),
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                              40),
                                                                        ),
                                                                        child:
                                                                        Center(
                                                                          child:
                                                                          Text(
                                                                            (index +
                                                                                1)
                                                                                .toString(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight
                                                                                    .bold,
                                                                                fontSize: 22,
                                                                                color: Theme.of(context).hintColor),
                                                                          ),
                                                                        ))));
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
