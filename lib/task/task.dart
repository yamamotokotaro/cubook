import 'dart:core';

class Task {

  // implict-dynamicをどうにかしなきゃいけないらしいがよくわからないので放置なう

  List<Map<String, dynamic>> usagi = [
    {'number' : '1', 'title': '笑顔', 'hasItem': 2},
    {'number' : '2', 'title': '運動', 'hasItem': 1},
    {'number' : '3', 'title': '安全', 'hasItem': 1},
    {'number' : '4', 'title': '清潔', 'hasItem': 1},
    {'number' : '5', 'title': '計測', 'hasItem': 1},
    {'number' : '6', 'title': 'なわ結び', 'hasItem': 1},
    {'number' : '7', 'title': '工作', 'hasItem': 1},
    {'number' : '8', 'title': '表現', 'hasItem': 1},
    {'number' : '9', 'title': '観察', 'hasItem': 1},
    {'number' : '10', 'title': '野外活動', 'hasItem': 1},
    {'number' : '11', 'title': '役に立つ', 'hasItem': 1},
    {'number' : '12', 'title': '日本の国旗', 'hasItem': 1},
    {'number' : '13', 'title': '世界の国々', 'hasItem': 1},
  ];

  List<Map<String, dynamic>> sika = [
    {'number' : '1', 'title': '感謝', 'hasItem': 2},
    {'number' : '2', 'title': '運動', 'hasItem': 1},
    {'number' : '3', 'title': '事故の予防', 'hasItem': 1},
    {'number' : '4', 'title': '健康', 'hasItem': 1},
    {'number' : '5', 'title': '計測', 'hasItem': 1},
    {'number' : '6', 'title': 'なわ結び', 'hasItem': 1},
    {'number' : '7', 'title': '工作', 'hasItem': 1},
    {'number' : '8', 'title': '表現', 'hasItem': 1},
    {'number' : '9', 'title': '観察', 'hasItem': 1},
    {'number' : '10', 'title': '野外活動', 'hasItem': 1},
    {'number' : '11', 'title': '暮らしのマナー', 'hasItem': 1},
    {'number' : '12', 'title': '役に立つ', 'hasItem': 1},
    {'number' : '13', 'title': '日本の国旗', 'hasItem': 1},
    {'number' : '14', 'title': '世界の国々', 'hasItem': 1},
  ];

  List<Map<String, dynamic>> kuma = [
    {'number' : '1', 'title': '心がけ', 'hasItem': 2},
    {'number' : '2', 'title': '成長', 'hasItem': 1},
    {'number' : '3', 'title': '事故への対応', 'hasItem': 1},
    {'number' : '4', 'title': '救急', 'hasItem': 1},
    {'number' : '5', 'title': '計測', 'hasItem': 1},
    {'number' : '6', 'title': 'なわ結び', 'hasItem': 1},
    {'number' : '7', 'title': '工作', 'hasItem': 1},
    {'number' : '8', 'title': '表現', 'hasItem': 1},
    {'number' : '9', 'title': '観察', 'hasItem': 1},
    {'number' : '10', 'title': '野外活動', 'hasItem': 1},
    {'number' : '11', 'title': '暮らしのマナー', 'hasItem': 1},
    {'number' : '12', 'title': '役に立つ', 'hasItem': 1},
    {'number' : '13', 'title': '日本の国旗', 'hasItem': 1},
    {'number' : '14', 'title': '世界の国々', 'hasItem': 1},
  ];

  List<Map<String, dynamic>> challnege = [
    {'number' : '1-1', 'title': '国際', 'hasItem': 4},
    {'number' : '1-2', 'title': '市民', 'hasItem': 6},
    {'number' : '1-3', 'title': '友情', 'hasItem': 4},
    {'number' : '1-4', 'title': '動物愛護', 'hasItem': 4},
    {'number' : '1-5', 'title': '案内', 'hasItem': 4},
    {'number' : '1-6', 'title': '自然保護', 'hasItem': 3},
    {'number' : '1-7', 'title': '手伝い', 'hasItem': 5},
    {'number' : '1-8', 'title': '災害救助員', 'hasItem': 3},
    {'number' : '2-1', 'title': '天文学者', 'hasItem': 4},
    {'number' : '2-2', 'title': '自然観察官', 'hasItem': 2},
    {'number' : '2-3', 'title': 'ハイカー', 'hasItem': 4},
    {'number' : '2-4', 'title': 'キャンパー', 'hasItem': 6},
    {'number' : '2-5', 'title': '地質学者', 'hasItem': 3},
    {'number' : '2-6', 'title': '気象学者', 'hasItem': 4},
    {'number' : '2-7', 'title': '探検家', 'hasItem': 3},
    {'number' : '3-1', 'title': '写真博士', 'hasItem': 4},
    {'number' : '3-2', 'title': 'コンピュータ博士', 'hasItem': 3},
    {'number' : '3-3', 'title': '自転車博士', 'hasItem': 3},
    {'number' : '3-4', 'title': '工作博士', 'hasItem': 4},
    {'number' : '3-5', 'title': '通信博士', 'hasItem': 5},
    {'number' : '3-6', 'title': '修理博士', 'hasItem': 5},
    {'number' : '3-7', 'title': '乗り物博士', 'hasItem': 4},
    {'number' : '3-8', 'title': '技術博士', 'hasItem': 3},
    {'number' : '3-9', 'title': '救急博士', 'hasItem': 6},
    {'number' : '3-10', 'title': '特技博士', 'hasItem': 1},
    {'number' : '4-1', 'title': '水泳選手', 'hasItem': 4},
    {'number' : '4-2', 'title': '運動選手', 'hasItem': 5},
    {'number' : '4-3', 'title': 'チームスポーツ選手', 'hasItem': 4},
    {'number' : '4-4', 'title': 'スキー選手', 'hasItem': 6},
    {'number' : '4-5', 'title': 'アイススケート選手', 'hasItem': 3},
    {'number' : '5-1', 'title': '収集家', 'hasItem': 2},
    {'number' : '5-2', 'title': '画家', 'hasItem': 4},
    {'number' : '5-3', 'title': '音楽家', 'hasItem': 4},
    {'number' : '5-4', 'title': '料理家', 'hasItem': 4},
    {'number' : '5-5', 'title': 'フィッシャーマン', 'hasItem': 4},
    {'number' : '5-6', 'title': '旅行家', 'hasItem': 4},
    {'number' : '5-7', 'title': '園芸家', 'hasItem': 5},
    {'number' : '5-8', 'title': '演劇家', 'hasItem': 5},
    {'number' : '5-9', 'title': '読書家', 'hasItem': 6},
    {'number' : '5-10', 'title': 'マジシャン', 'hasItem': 4},
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
    if(type == 'usagi') {
      return usagi[number];
    } else if (type == 'challenge') {
      return challnege[number];
    }
  }
}