import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:cubook/checkScoutTaskDetail/taskDetailScoutConfirm_model.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailScoutConfirmAddView extends StatelessWidget {
  TaskDetailScoutConfirmAddView(int? _index, String? _type, String _mes) {
    themeColor = theme.getThemeColor(_type);
    index_page = _index;
    type = _type;
    mes = _mes;
  }
  int? index_page;
  String? type;
  Color? themeColor;
  String? mes;
  Map<String, dynamic>? taskInfo;
  late Map<String, dynamic> content;
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = ColorScheme.fromSeed(
        seedColor: themeColor!,
        brightness: MediaQuery.of(context).platformBrightness);
    return Consumer<TaskDetailScoutConfirmModel>(
        builder: (BuildContext context, TaskDetailScoutConfirmModel model, _) {
      content = task.getContent(type, model.page, index_page);
      if (content['common'] != null) {
        taskInfo = task.getPartMap(
            content['common']['type'], content['common']['page']);
      }
      return Column(children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0), topRight: Radius.circular(0)),
                color: themeColor),
            child: const Column(
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
        if (mes != '')
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                mes!,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))
        else
          Container(),
        Container(
            height: MediaQuery.of(context).size.height > 700
                ? MediaQuery.of(context).size.height - 334
                : MediaQuery.of(context).size.height - 228,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                if ((type != 'risu' &&
                        type != 'usagi' &&
                        type != 'sika' &&
                        type != 'kuma' &&
                        type != 'challenge' &&
                        type != 'tukinowa') ||
                    model.group == ' j27DETWHGYEfpyp2Y292' ||
                    model.group == ' z4pkBhhgr0fUMN4evr5z')
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: ExpandText(
                        content['body'],
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ))
                else
                  Container(),
                if (content['common'] != null)
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 10, right: 10, left: 10),
                      child: Text(
                        theme.getTitle(content['common']['type'])! +
                            ' ' +
                            taskInfo!['title'] +
                            ' (' +
                            task.getNumber(
                                content['common']['type'],
                                content['common']['page'],
                                content['common']['number'])! +
                            ')\nもサインされます',
                        textAlign: TextAlign.center,
                      ))
                else
                  Container(),
                if (model.isLast)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          onChanged: model.onPressCheckbox,
                          activeColor: themeColor,
                          value: model.checkCitation,
                        ),
                        const Text('表彰待ちリストに追加しない')
                      ],
                    ),
                  )
                else
                  Container(),
                if (!model.isLoading[index_page!])
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FilledButton.icon(
                          onPressed: () {
                            model.onTapSend(index_page!);
                          },
                          icon: Icon(Icons.edit, color: scheme.onPrimary),
                          label: Text(
                            'サインする',
                            style: TextStyle(color: scheme.onPrimary),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  scheme.primary))))
                else
                  Container(
                    child: Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color?>(themeColor),
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
