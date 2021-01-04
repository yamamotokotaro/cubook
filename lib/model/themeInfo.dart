import 'package:flutter/material.dart';

class ThemeInfo {
  List<Color> colors = [
    Colors.lightBlue[400],
    Colors.yellow[800],
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.blueAccent[700],
    Colors.green[900],
    Colors.green,
    Colors.blue[700],
    Colors.red[700],
    Colors.blue[900],
    Colors.green[600],
    Colors.red[900],
    Colors.yellow[800],
    Colors.indigo[900],
    Colors.green[900],
  ];
  List<Color> colors_indicator = [
    Colors.lightBlue[500],
    Colors.yellow[600],
    Colors.orange[300],
    Colors.green[300],
    Colors.blue[300],
    Colors.blueAccent[400],
    Colors.green[700],
    Colors.green[400],
    Colors.blue[500],
    Colors.red[500],
    Colors.blue[700],
    Colors.green[400],
    Colors.red[700],
    Colors.yellow[700],
    Colors.indigo[800],
    Colors.green[800],
  ];

  List<String> titles = [
    'ビーバーノート',
    'りすの道',
    'うさぎのカブブック',
    'しかのカブブック',
    'くまのカブブック',
    '月の輪',
    'チャレンジ章',
    '初級スカウト章',
    '2級スカウト章',
    '1級スカウト章',
    '菊スカウト章',
    '隼スカウト章',
    '富士スカウト章',
    '信仰奨励章',
    '宗教章',
    '技能章'
  ];

  List<String> type = [
//    'beaver',
    'risu',
    'usagi',
    'sika',
    'kuma',
    'tukinowa',
    'challenge',
    'syokyu',
    'nikyu',
    'ikkyu',
    'kiku',
    'hayabusa',
    'fuji',
    'syorei',
    'syukyo',
    'gino'
  ];

  Color getThemeColor(String type) {
    Color color;
    switch (type) {
      case 'beaver':
        color = colors[0];
        break;
      case 'risu':
        color = colors[1];
        break;
      case 'usagi':
        color = colors[2];
        break;
      case 'sika':
        color = colors[3];
        break;
      case 'kuma':
        color = colors[4];
        break;
      case 'tukinowa':
        color = colors[5];
        break;
      case 'challenge':
        color = colors[6];
        break;
      case 'syokyu':
        color = colors[7];
        break;
      case 'nikyu':
        color = colors[8];
        break;
      case 'ikkyu':
        color = colors[9];
        break;
      case 'kiku':
        color = colors[10];
        break;
      case 'hayabusa':
        color = colors[11];
        break;
      case 'fuji':
        color = colors[12];
        break;
      case 'syorei':
        color = colors[13];
        break;
      case 'syukyo':
        color = colors[14];
        break;
      case 'gino':
        color = colors[15];
        break;
    }
    return color;
  }

  Color getUserColor(String type) {
    Color color;
    switch (type) {
      case 'beaver':
        color = colors[0];
        break;
      case 'risu':
        color = colors[1];
        break;
      case 'usagi':
        color = colors[2];
        break;
      case 'sika':
        color = colors[3];
        break;
      case 'kuma':
        color = colors[4];
        break;
      case 'challenge':
        color = colors[5];
        break;
      case 'syokyu':
        color = colors[7];
        break;
      case 'nikyu':
        color = colors[8];
        break;
      case 'ikkyu':
        color = colors[9];
        break;
      case 'kiku':
        color = colors[10];
        break;
      case 'hayabusa':
        color = colors[11];
        break;
      case 'fuji':
        color = colors[12];
        break;
      case 'gino':
        color = colors[15];
        break;
      case 'leader':
        color = Colors.green[900];
        break;
    }
    return color;
  }

  Color getIndicatorColor(String type) {
    Color color;
    switch (type) {
      case 'beaver':
        color = colors_indicator[0];
        break;
      case 'risu':
        color = colors_indicator[1];
        break;
      case 'usagi':
        color = colors_indicator[2];
        break;
      case 'sika':
        color = colors_indicator[3];
        break;
      case 'kuma':
        color = colors_indicator[4];
        break;
      case 'tukinowa':
        color = colors_indicator[5];
        break;
      case 'challenge':
        color = colors_indicator[6];
        break;
      case 'syokyu':
        color = colors_indicator[7];
        break;
      case 'nikyu':
        color = colors_indicator[8];
        break;
      case 'ikkyu':
        color = colors_indicator[9];
        break;
      case 'kiku':
        color = colors_indicator[10];
        break;
      case 'hayabusa':
        color = colors_indicator[11];
        break;
      case 'fuji':
        color = colors_indicator[12];
        break;
      case 'syorei':
        color = colors_indicator[13];
        break;
      case 'syukyo':
        color = colors_indicator[14];
        break;
      case 'gino':
        color = colors_indicator[15];
        break;
    }
    return color;
  }

  String getTitle(String type) {
    String title;
    switch (type) {
      case 'beaver':
        title = titles[0];
        break;
      case 'risu':
        title = titles[1];
        break;
      case 'usagi':
        title = titles[2];
        break;
      case 'sika':
        title = titles[3];
        break;
      case 'kuma':
        title = titles[4];
        break;
      case 'tukinowa':
        title = titles[5];
        break;
      case 'challenge':
        title = titles[6];
        break;
      case 'syokyu':
        title = titles[7];
        break;
      case 'nikyu':
        title = titles[8];
        break;
      case 'ikkyu':
        title = titles[9];
        break;
      case 'kiku':
        title = titles[10];
        break;
      case 'hayabusa':
        title = titles[11];
        break;
      case 'fuji':
        title = titles[12];
        break;
      case 'syorei':
        title = titles[13];
        break;
      case 'syukyo':
        title = titles[14];
        break;
      case 'gino':
        title = titles[15];
        break;
    }
    return title;
  }
}
