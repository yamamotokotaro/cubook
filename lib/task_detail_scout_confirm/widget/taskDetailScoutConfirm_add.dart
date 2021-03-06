import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_model.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailScoutConfirmAddView extends StatelessWidget {
  int index_page;
  String type;
  Color themeColor;
  String mes;
  Map<String, dynamic> taskInfo;
  Map<String, dynamic> content;
  var task = new TaskContents();
  var theme = new ThemeInfo();

  TaskDetailScoutConfirmAddView(int _index, String _type, String _mes) {
    themeColor = theme.getThemeColor(_type);
    index_page = _index;
    type = _type;
    mes = _mes;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDetailScoutConfirmModel>(builder: (context, model, _) {
      content = task.getContent(type, model.page, index_page);
      if (content['common'] != null) {
        taskInfo = task.getPartMap(
            content['common']['type'], content['common']['page']);
      }
      return Column(children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(0),
                    topRight: const Radius.circular(0)),
                color: themeColor),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: Center(
                    child: Text(
                      '未サイン',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
        mes != ''
            ? Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Text(
                  mes,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ))
            : Container(),
        Container(
            height: MediaQuery.of(context).size.height > 700
                ? MediaQuery.of(context).size.height - 334
                : MediaQuery.of(context).size.height - 228,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                /*Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: FlatButton.icon(
                      onPressed: () async {
                        var result = await showModalBottomSheet<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            task
                                                .getContent(type, model.page,
                                                    index_page)
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(0),
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
                                        )),
                                  ],
                                ));
                          },
                        );
                      },
                      icon: Icon(
                        Icons.sort,
                        size: 20,
                      ),
                      label: Text(
                        '内容を見る',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),*/
                (type != 'risu' &&
                            type != 'usagi' &&
                            type != 'sika' &&
                            type != 'kuma' &&
                            type != 'challenge' &&
                            type != 'tukinowa') ||
                        model.group == ' j27DETWHGYEfpyp2Y292' ||
                        model.group == ' z4pkBhhgr0fUMN4evr5z'
                    ? Padding(
                        padding: EdgeInsets.all(15),
                        child: ExpandText(
                          content['body'],
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.justify,
                        ))
                    : Container(),
                content['common'] != null
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 10, right: 10, left: 10),
                        child: Text(
                          theme.getTitle(content['common']['type']) +
                              ' ' +
                              taskInfo['title'] +
                              ' (' +
                              task.getNumber(
                                  content['common']['type'],
                                  content['common']['page'],
                                  content['common']['number']) +
                              ')\nもサインされます',
                          textAlign: TextAlign.center,
                        ))
                    : Container(),
                model.isLast
                    ? Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              onChanged: model.onPressCheckbox,
                              activeColor: themeColor,
                              value: model.checkCitation,
                            ),
                            Text('表彰待ちリストに追加しない')
                          ],
                        ),
                      )
                    : Container(),
                !model.isLoading[index_page]
                    ? Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: RaisedButton.icon(
                          onPressed: () {
                            model.onTapSend(index_page);
                          },
                          icon: Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                          color: themeColor,
                          label: Text(
                            'サインする',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ))
                    : Container(
                        child: Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                          ),
                        ),
                      ),
              ],
            )))
      ]);
    });
  }
}
