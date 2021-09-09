import 'dart:io';
import 'dart:convert';

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
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:html' as http;


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
  String position;
  Map<String, dynamic> claims = Map<String, dynamic>();

  void getGroup() async {
    final String groupBefore = group;
    final String teamPositionBefore = teamPosition;
    final User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) {
      userSnapshot = snapshot.docs[0];
      group = userSnapshot.get('group');
      position = userSnapshot.get('position');
      if (position == "scout") {
        teamPosition = userSnapshot.get('teamPosition');
        if(teamPosition == "teamLeader"){
          position = teamPosition;
        }
      }
      if (group != groupBefore || teamPosition != teamPositionBefore) {
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
    final task = TaskContents();
    final theme = ThemeInfo();
    final type = [
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
    if (!isExported && !isExporting) {
      isExporting = true;
      notifyListeners();
      final excel = Excel.createExcel();
      FirebaseFirestore.instance
          .collection('user')
          .where('group', isEqualTo: group)
          .where('position', isEqualTo: 'scout')
          .orderBy('age_turn', descending: false)
          .orderBy('team')
          .orderBy('name')
          .get()
          .then((QuerySnapshot querySnapshots) async {
        final List<DocumentSnapshot> listDocumentsnapshot = querySnapshots.docs;
        Sheet sheetObject;
        String ageLast;
        count_user = 0;
        count_userAll = listDocumentsnapshot.length;
        final List<int> countItem = <int>[];
        for (DocumentSnapshot documentSnapshot in listDocumentsnapshot) {
          if (ageLast != documentSnapshot.get('age')) {
            int row = 0;
            count_user = 0;
            ageLast = documentSnapshot.get('age');
            sheetObject = excel[ageLast];
            for (int i = 0; i < type.length; i++) {
              final CellStyle cellStyle = CellStyle(
                  backgroundColorHex:
                      theme.getThemeColor(type[i]).value.toRadixString(16),
                  fontColorHex: '#FFFFFF',
                  textWrapping: TextWrapping.WrapText,
                  verticalAlign: VerticalAlign.Center,
                  horizontalAlign: HorizontalAlign.Center);
              final mapTask = task.getAllMap(type[i]);
              if (countItem.length < type.length + 1) {
                if (i == 0) {
                  countItem.add(0);
                  countItem.add(countItem[0] + mapTask.length);
                } else {
                  countItem.add(countItem[i] + mapTask.length);
                }
              }
              for (int j = 0; j < mapTask.length; j++) {
                final cell = sheetObject.cell(CellIndex.indexByColumnRow(
                    columnIndex: row + 1, rowIndex: 0));
                cell.value = mapTask[j]['title'];
                cell.cellStyle = cellStyle;
                row++;
              }
            }
          }
          final CellStyle cellStyle = CellStyle(
              textWrapping: TextWrapping.WrapText,
              verticalAlign: VerticalAlign.Center,
              horizontalAlign: HorizontalAlign.Center);
          final cell = sheetObject.cell(CellIndex.indexByColumnRow(
              columnIndex: 0, rowIndex: count_user + 1));
          cell.value = documentSnapshot.get('name');
          cell.cellStyle = cellStyle;
          count_user++;
          count_userProgress++;
          for (int i = 0; i < type.length; i++) {
            final QuerySnapshot querySnapshotTask = await FirebaseFirestore
                .instance
                .collection(type[i])
                .where('group', isEqualTo: group)
                .where('uid', isEqualTo: documentSnapshot.get('uid'))
                .orderBy('end')
                .get();

            for (DocumentSnapshot documentSnapshot_task
                in querySnapshotTask.docs) {
              final int page = documentSnapshot_task.get('page');
              final CellStyle cellStyle = CellStyle(
                  textWrapping: TextWrapping.WrapText,
                  verticalAlign: VerticalAlign.Center,
                  horizontalAlign: HorizontalAlign.Center);
              final cell = sheetObject.cell(CellIndex.indexByColumnRow(
                  columnIndex: page + countItem[i] + 1, rowIndex: count_user));
              cell.value = DateFormat('yyyy/MM/dd')
                  .format(documentSnapshot_task.get('end').toDate())
                  .toString();
              cell.cellStyle = cellStyle;
            }
          }
          notifyListeners();
        }
        excel.delete('Sheet1');
        final onValue = excel.encode();
        if (kIsWeb) {
          /*final content = base64Encode(onValue);
          final anchor = http.AnchorElement(
              href:
                  "data:application/octet-stream;charset=utf-16le;base64,$content")
            ..setAttribute("download", DateFormat('yyyyMMddhhmm').format(DateTime.now()).toString() +
                '.xlsx')
            ..click();*/
        } else {
          final Directory appDocDir = await getTemporaryDirectory();
          file_dir = appDocDir.path +
              '/cubook_' +
              DateFormat('yyyyMMddhhmm').format(DateTime.now()).toString() +
              '.xlsx';
          File(file_dir)
            ..createSync(recursive: true)
            ..writeAsBytesSync(onValue);
        }
        isExporting = false;
        isExported = true;
        count_user = 0;
        count_userAll = 0;
        count_userProgress = 0;
        notifyListeners();
      });
    }
  }

  void openFile() async {
    if (kIsWeb) {
    } else {
      await OpenFile.open(file_dir);
    }
  }

  void reExport() {
    isExported = false;
    export();
  }
}
