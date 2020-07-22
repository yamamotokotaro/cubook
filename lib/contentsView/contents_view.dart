import 'package:cubook/contentsView/contents_model.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentsView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('スペシャルコンテンツ'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child:
                    Consumer<ContentsModel>(builder: (context, model, child) {
                  model.getContent(id);
                  if (model.contentSnapshot != null) {
                    return Column(
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(
                                top: 16, left: 25, right: 25),
                            width: 685,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 1900.0),
                                  child: Text(model.contentSnapshot['title'],
                                      style: TextStyle(
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                      )),
                                ))),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 16, left: 25, right: 25),
                            width: 685,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(model.contentSnapshot['body'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ))
                      ],
                    );
                  } else {
                    return Container();
                  }
                })),
          ),
        ),
      ),
    );
  }
}
