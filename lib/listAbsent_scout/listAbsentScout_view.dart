import 'package:cubook/listAbsent/listAbsent_view.dart';
import 'package:cubook/listAbsent_scout/listAbsentScout_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAbsentScoutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('出欠確認'),
        ),
        body: SafeArea(child:
            Consumer<ListAbsentScoutModel>(builder: (context, model, child) {
          model.getUser();
          if (model.uid != null) {
            return ListAbsentView(model.uid);
          } else {
            return const Center(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator()),
            );
          }
        })));
  }
}
