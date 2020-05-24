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
  String mes;

  TaskDetailScoutConfirmAddView(int _index, String _type, String _mes) {
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
    mes = _mes;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDetailScoutConfirmModel>(builder: (context, model, _) {
      return Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius
                      .circular(0),
                  topRight:
                  const Radius
                      .circular(0)),
              color: themeColor),
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
        mes != '' ?
        Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              mes,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )): Container(),
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
                            onChanged: model.onPressCheckbox,
                            activeColor: themeColor,
                            value: model.checkPost,
                          ),
                          Text('過去に表彰済み')
                        ],
                      ),
                    ),
                    !model.isLoading[index_page]
                        ? RaisedButton.icon(
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
