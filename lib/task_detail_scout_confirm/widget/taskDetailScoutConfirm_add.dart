import 'dart:io';

import 'package:cubook/task_detail_scout/widget/videoView.dart';
import 'package:cubook/task_detail_scout_confirm/taskDetailScoutConfirm_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailScoutConfirmAddView extends StatelessWidget {
  int index_page;
  String type;
  Color themeColor;

  TaskDetailScoutConfirmAddView(int _index, String _type) {
    if (_type == 'usagi') {
      themeColor = Colors.orange;
    } else if (_type == 'sika') {
      themeColor = Colors.green;
    } else if (_type == 'kuma') {
      themeColor = Colors.blue;
    } else if (_type == 'challenge') {
      themeColor = Colors.green[900];
    }
    index_page = _index;
    type = _type;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDetailScoutConfirmModel>(builder: (context, model, _) {
      return Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          color: themeColor,
          child: Padding(
            padding:
            EdgeInsets.only(top: 40, bottom: 20),
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
        ),
        Container(
            height: MediaQuery.of(context)
                .size
                .height >
                700
                ? MediaQuery.of(context).size.height -
                334
                : MediaQuery.of(context).size.height -
                228,
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            activeColor: themeColor,
                            value: model.checkParent,
                          ),
                          Text('みんなの取り組みに追加しない')
                        ],
                      ),
                    ),
                    !model.isLoading[index_page]
                        ? RaisedButton.icon(
                      onPressed: () {
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
                    )
                        : Container(
                      child: Container(child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor),),),),
                    ),
                  ],
                )))
      ]);
    });
  }
}
