import 'package:cubook/listAbsent/listAbsent_view.dart';
import 'package:cubook/listAbsent_scout/listAbsentScout_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAbsentScoutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('活動のきろく'),
        ),
        body: Consumer<ListAbsentScoutModel>(builder:
            (BuildContext context, ListAbsentScoutModel model, Widget? child) {
          model.getUser();
          if (model.uid != null) {
            return Scrollbar(child: ListAbsentView(model.uid));
          } else {
            return const Center(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator()),
            );
          }
        }));
  }
}
