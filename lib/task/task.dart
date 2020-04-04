import 'dart:core';

class Task {

  // implict-dynamicをどうにかしなきゃいけないらしいがよくわからないので放置なう

  List<Map<String, dynamic>> usagi = [
    {'number' : '1', 'title': '笑顔1', 'hasItem': 1},
    {'number' : '1', 'title': '笑顔2', 'hasItem': 2},
    {'number' : '2', 'title': '運動', 'hasItem': 3},
  ];

  List<Map<String, dynamic>> challnege = [
    {'number' : '1-1', 'title': '国際', 'hasItem': 5},
    {'number' : '1-2', 'title': '市民', 'hasItem': 4},
    {'number' : '1-3', 'title': '友情', 'hasItem': 5},
  ];

  /*String call(String type, int number){
  }*/

  List<Map<String, dynamic>> getAllMap(String type){
    if(type == 'usagi') {
      return usagi;
    } else if (type == 'challenge') {
      return challnege;
    }
  }

  Map<String, dynamic> getPartMap(String type, int number){
    if(type == usagi) {
      return usagi[number];
    } else if (type == 'challenge') {
      return challnege[number];
    }
  }
}