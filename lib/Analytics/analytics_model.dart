import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AnalyticsModel extends ChangeNotifier {
  DocumentSnapshot userSnapshot;
  User currentUser;
  bool isGet = false;
  bool isExporting = false;
  bool isExported = false;
  int count_userAll = 0;
  int count_userProgress = 0;
  int count_user = 0;
  String file_dir;
  String group;
  String group_before = '';
  String group_claim;
  String teamPosition;
  Map<String, dynamic> claims = new Map<String, dynamic>();

  void getGroup() async {
    String group_before = group;
    String teamPosition_before = teamPosition;
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      userSnapshot = snapshot.docs[0];
      group = userSnapshot.data()['group'];
      teamPosition = userSnapshot.data()['teamPosition'];
      if (group != group_before || teamPosition != teamPosition_before) {
        notifyListeners();
      }
      /*user.getIdTokenResult().then((value) {
        String group_claim_before = group_claim;
        group_claim = value.token['group'];
        if (group_claim_before != group_claim) {
          notifyListeners();
        }
      });*/
    });
  }

  void export() async {
    var task = new Task();
    var theme = new ThemeInfo();
    var type = [
//    'beaver',
      'usagi',
      'sika',
      'kuma',
      'challenge',
      'syokyu',
      'nikyu',
      'ikkyu',
      'kiku',
      'hayabusa',
      'fuji',
      'gino'
    ];
    if(!isExported && !isExporting) {
      isExporting = true;
      notifyListeners();
      var excel = Excel.createExcel();
      FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: group)
          .where('position', isEqualTo: 'scout')
          .orderBy('age_turn', descending: false)
          .orderBy('team')
          .orderBy('name')
          .get()
          .then((QuerySnapshot querySnapshots) async {
        List<DocumentSnapshot> list_documentsnapshot = querySnapshots.docs;
        Sheet sheetObject;
        String age_last;
        count_user = 0;
        count_userAll = list_documentsnapshot.length;
        List<int> count_item = new List<int>();
        for (DocumentSnapshot documentSnapshot in list_documentsnapshot) {
          if (age_last != documentSnapshot.data()['age']) {
            int row = 0;
            count_user = 0;
            age_last = documentSnapshot.data()['age'];
            sheetObject = excel[age_last];
            for (int i = 0; i < type.length; i++) {
              CellStyle cellStyle = CellStyle(
                  backgroundColorHex:
                  theme
                      .getThemeColor(type[i])
                      .value
                      .toRadixString(16),
                  fontColorHex: '#FFFFFF',
                  textWrapping: TextWrapping.WrapText,
                  verticalAlign: VerticalAlign.Center,
                  horizontalAlign: HorizontalAlign.Center);
              var map_task = task.getAllMap(type[i]);
              if (count_item.length < type.length + 1) {
                if (i == 0) {
                  count_item.add(0);
                  count_item.add(count_item[0] + map_task.length);
                } else {
                  count_item.add(count_item[i] + map_task.length);
                }
              }
              for (int j = 0; j < map_task.length; j++) {
                var cell = sheetObject.cell(CellIndex.indexByColumnRow(
                    columnIndex: row + 1, rowIndex: 0));
                cell.value = map_task[j]['title'];
                cell.cellStyle = cellStyle;
                row++;
              }
            }
          }
          CellStyle cellStyle = CellStyle(
              textWrapping: TextWrapping.WrapText,
              verticalAlign: VerticalAlign.Center,
              horizontalAlign: HorizontalAlign.Center);
          var cell = sheetObject.cell(CellIndex.indexByColumnRow(
              columnIndex: 0, rowIndex: count_user + 1));
          cell.value = documentSnapshot.data()['name'];
          cell.style = cellStyle;
          count_user++;
          count_userProgress++;
          for (int i = 0; i < type.length; i++) {
            QuerySnapshot querySnapshot_task = await FirebaseFirestore.instance
                .collection(type[i])
                .where('group', isEqualTo: group)
                .where('uid', isEqualTo: documentSnapshot.data()['uid'])
                .orderBy('end')
                .get();

            for (DocumentSnapshot documentSnapshot_task
            in querySnapshot_task.docs) {
              int page = documentSnapshot_task.data()['page'];
              CellStyle cellStyle = CellStyle(
                  textWrapping: TextWrapping.WrapText,
                  verticalAlign: VerticalAlign.Center,
                  horizontalAlign: HorizontalAlign.Center);
              var cell = sheetObject.cell(CellIndex.indexByColumnRow(
                  columnIndex: page + count_item[i] + 1,
                  rowIndex: count_user));
              cell.value = DateFormat('yyyy/MM/dd')
                  .format(documentSnapshot_task.data()['end'].toDate())
                  .toString();
              cell.style = cellStyle;
            }
          }
          notifyListeners();
        }
        excel.delete('Sheet1');
        excel.encode().then((onValue) async {
          Directory appDocDir = await getTemporaryDirectory();
          file_dir = appDocDir.path + "/cubook.xlsx";
          File(file_dir)
            ..createSync(recursive: true)
            ..writeAsBytesSync(onValue);
          isExporting = false;
          isExported = true;
          count_user = 0;
          count_userAll = 0;
          count_userProgress = 0;
          notifyListeners();
        });
      });
    }
  }

  void openFile() async {
    await OpenFile.open(file_dir);
  }

  void reExport() {
    isExported = false;
    export();
  }
}
