import 'package:cubook/listTaskWaiting/listTaskWaiting_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTaskWaiting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('サイン待ちリスト'),),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child:
        Consumer<ListTaskWaitingModel>(builder: (context, model, _) {
          return ListView.builder(itemBuilder: null);
    }
      ),
    );
  }
}