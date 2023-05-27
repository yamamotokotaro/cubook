import 'package:cubook/listAbsent/listAbsent_view.dart';
import 'package:cubook/listAbsent_scout/listAbsentScout_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAbsentScoutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('活動記録'),
        ),
        body: SafeArea(child: Consumer<ListAbsentScoutModel>(builder:
            (BuildContext context, ListAbsentScoutModel model, Widget? child) {
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
