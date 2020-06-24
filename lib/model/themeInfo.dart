import 'package:flutter/material.dart';

class ThemeInfo {
  List<Color> colors = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.green[900]
  ];
  List<Color> colors_indicator = [
    Colors.orange[300],
    Colors.green[300],
    Colors.blue[300],
    Colors.green[700]
  ];

  List<String> titles = [
    'うさぎのカブブック',
    'しかのカブブック',
    'くまのカブブック',
    '技能章'
  ];

  Color getThemeColor(String type) {
    Color color;
    switch (type) {
      case 'usagi':
        color = colors[0];
        break;
      case 'sika':
        color = colors[1];
        break;
      case 'kuma':
        color = colors[2];
        break;
      case 'challenge':
        color = colors[3];
        break;
    }
    return color;
  }

  Color getIndicatorColor(String type) {
    Color color;
    switch (type) {
      case 'usagi':
        color = colors_indicator[0];
        break;
      case 'sika':
        color = colors_indicator[1];
        break;
      case 'kuma':
        color = colors_indicator[2];
        break;
      case 'challenge':
        color = colors_indicator[3];
        break;
    }
    return color;
  }

  String getTitle(String type) {
    String title;
    switch (type) {
      case 'usagi':
        title = titles[0];
        break;
      case 'sika':
        title = titles[1];
        break;
      case 'kuma':
        title = titles[2];
        break;
      case 'challenge':
        title = titles[3];
        break;
    }
    return title;
  }
}