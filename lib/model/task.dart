import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  // implict-dynamicをどうにかしなきゃいけないらしいがよくわからないので放置なう

  List<Map<String, dynamic>> usagi = [
    {'number': '1', 'title': '笑顔', 'hasItem': 2},
    {'number': '2', 'title': '運動', 'hasItem': 1},
    {'number': '3', 'title': '安全', 'hasItem': 1},
    {'number': '4', 'title': '清潔', 'hasItem': 1},
    {'number': '5', 'title': '計測', 'hasItem': 1},
    {'number': '6', 'title': 'なわ結び', 'hasItem': 1},
    {'number': '7', 'title': '工作', 'hasItem': 1},
    {'number': '8', 'title': '表現', 'hasItem': 1},
    {'number': '9', 'title': '観察', 'hasItem': 1},
    {'number': '10', 'title': '野外活動', 'hasItem': 1},
    {'number': '11', 'title': '役に立つ', 'hasItem': 1},
    {'number': '12', 'title': '日本の国旗', 'hasItem': 1},
    {'number': '13', 'title': '世界の国々', 'hasItem': 1},
  ];

  List<Map<String, dynamic>> sika = [
    {'number': '1', 'title': '感謝', 'hasItem': 2},
    {'number': '2', 'title': '運動', 'hasItem': 1},
    {'number': '3', 'title': '事故の予防', 'hasItem': 1},
    {'number': '4', 'title': '健康', 'hasItem': 1},
    {'number': '5', 'title': '計測', 'hasItem': 1},
    {'number': '6', 'title': 'なわ結び', 'hasItem': 1},
    {'number': '7', 'title': '工作', 'hasItem': 1},
    {'number': '8', 'title': '表現', 'hasItem': 1},
    {'number': '9', 'title': '観察', 'hasItem': 1},
    {'number': '10', 'title': '野外活動', 'hasItem': 1},
    {'number': '11', 'title': '暮らしのマナー', 'hasItem': 1},
    {'number': '12', 'title': '役に立つ', 'hasItem': 1},
    {'number': '13', 'title': '日本の国旗', 'hasItem': 1},
    {'number': '14', 'title': '世界の国々', 'hasItem': 1},
  ];

  List<Map<String, dynamic>> kuma = [
    {'number': '1', 'title': '心がけ', 'hasItem': 2},
    {'number': '2', 'title': '成長', 'hasItem': 1},
    {'number': '3', 'title': '事故への対応', 'hasItem': 2},
    {'number': '4', 'title': '救急', 'hasItem': 2},
    {'number': '5', 'title': '計測', 'hasItem': 1},
    {'number': '6', 'title': 'なわ結び', 'hasItem': 1},
    {'number': '7', 'title': '工作', 'hasItem': 1},
    {'number': '8', 'title': '表現', 'hasItem': 1},
    {'number': '9', 'title': '観察', 'hasItem': 1},
    {'number': '10', 'title': '野外活動', 'hasItem': 4},
    {'number': '11', 'title': '暮らしのマナー', 'hasItem': 1},
    {'number': '12', 'title': '役に立つ', 'hasItem': 1},
    {'number': '13', 'title': '日本の国旗', 'hasItem': 1},
    {'number': '14', 'title': '世界の国々', 'hasItem': 1},
  ];

  List<Map<String, dynamic>> challnege = [
    {'number': '1-1', 'title': '国際', 'hasItem': 4},
    {'number': '1-2', 'title': '市民', 'hasItem': 6},
    {'number': '1-3', 'title': '友情', 'hasItem': 4},
    {'number': '1-4', 'title': '動物愛護', 'hasItem': 4},
    {'number': '1-5', 'title': '案内', 'hasItem': 4},
    {'number': '1-6', 'title': '自然保護', 'hasItem': 3},
    {'number': '1-7', 'title': '手伝い', 'hasItem': 5},
    {'number': '1-8', 'title': '災害救助員', 'hasItem': 3},
    {'number': '2-1', 'title': '天文学者', 'hasItem': 4},
    {'number': '2-2', 'title': '自然観察官', 'hasItem': 2},
    {'number': '2-3', 'title': 'ハイカー', 'hasItem': 4},
    {'number': '2-4', 'title': 'キャンパー', 'hasItem': 6},
    {'number': '2-5', 'title': '地質学者', 'hasItem': 3},
    {'number': '2-6', 'title': '気象学者', 'hasItem': 4},
    {'number': '2-7', 'title': '探検家', 'hasItem': 3},
    {'number': '3-1', 'title': '写真博士', 'hasItem': 4},
    {'number': '3-2', 'title': 'コンピュータ博士', 'hasItem': 3},
    {'number': '3-3', 'title': '自転車博士', 'hasItem': 3},
    {'number': '3-4', 'title': '工作博士', 'hasItem': 4},
    {'number': '3-5', 'title': '通信博士', 'hasItem': 5},
    {'number': '3-6', 'title': '修理博士', 'hasItem': 5},
    {'number': '3-7', 'title': '乗り物博士', 'hasItem': 4},
    {'number': '3-8', 'title': '技術博士', 'hasItem': 3},
    {'number': '3-9', 'title': '救急博士', 'hasItem': 6},
    {'number': '3-10', 'title': '特技博士', 'hasItem': 1},
    {'number': '4-1', 'title': '水泳選手', 'hasItem': 4},
    {'number': '4-2', 'title': '運動選手', 'hasItem': 5},
    {'number': '4-3', 'title': 'チームスポーツ選手', 'hasItem': 4},
    {'number': '4-4', 'title': 'スキー選手', 'hasItem': 6},
    {'number': '4-5', 'title': 'アイススケート選手', 'hasItem': 3},
    {'number': '5-1', 'title': '収集家', 'hasItem': 2},
    {'number': '5-2', 'title': '画家', 'hasItem': 4},
    {'number': '5-3', 'title': '音楽家', 'hasItem': 4},
    {'number': '5-4', 'title': '料理家', 'hasItem': 4},
    {'number': '5-5', 'title': 'フィッシャーマン', 'hasItem': 4},
    {'number': '5-6', 'title': '旅行家', 'hasItem': 4},
    {'number': '5-7', 'title': '園芸家', 'hasItem': 5},
    {'number': '5-8', 'title': '演劇家', 'hasItem': 5},
    {'number': '5-9', 'title': '読書家', 'hasItem': 6},
    {'number': '5-10', 'title': 'マジシャン', 'hasItem': 4},
  ];

  List<Map<String, dynamic>> syokyu = [
    {'number': '1', 'title': '基本', 'hasItem': 4},
    {'number': '2', 'title': '健康と発達', 'hasItem': 6},
    {'number': '3', 'title': 'スカウト技能', 'hasItem': 4},
    {'number': '4', 'title': '善行', 'hasItem': 4},
    {'number': '5', 'title': '信仰奨励', 'hasItem': 4},
    {'number': '6', 'title': '班長会議', 'hasItem': 3},
  ];

  List<Map<String, dynamic>> nikyu = [
    {'number': '1', 'title': '基本', 'hasItem': 4},
    {'number': '2', 'title': '健康と発達', 'hasItem': 6},
    {'number': '3', 'title': 'スカウト技能', 'hasItem': 4},
    {'number': '4', 'title': '奉仕', 'hasItem': 4},
    {'number': '5', 'title': '信仰奨励', 'hasItem': 4},
    {'number': '6', 'title': '班長会議', 'hasItem': 3},
  ];

  List<Map<String, dynamic>> ikkyu = [
    {'number': '1', 'title': '基本', 'hasItem': 4},
    {'number': '2', 'title': '健康と発達', 'hasItem': 6},
    {'number': '3', 'title': 'スカウト技能', 'hasItem': 4},
    {'number': '4', 'title': '奉仕', 'hasItem': 4},
    {'number': '5', 'title': '信仰奨励', 'hasItem': 4},
    {'number': '6', 'title': '班長会議', 'hasItem': 3},
  ];

  List<Map<String, dynamic>> kiku = [
    {'number': '1', 'title': '基本', 'hasItem': 4},
    {'number': '2', 'title': '健康と発達', 'hasItem': 3},
    {'number': '3', 'title': 'スカウト技能', 'hasItem': 3},
    {'number': '4', 'title': '奉仕', 'hasItem': 1},
    {'number': '5', 'title': '信仰奨励', 'hasItem': 1},
    {'number': '6', 'title': '班長会議', 'hasItem': 1},
  ];

  List<Map<String, dynamic>> hayabusa = [
    {'number': '1', 'title': '基本', 'hasItem': 1},
    {'number': '2', 'title': 'スカウト技能', 'hasItem': 3},
    {'number': '3', 'title': 'スカウト精神', 'hasItem': 1},
    {'number': '4', 'title': '奉仕', 'hasItem': 2},
    {'number': '5', 'title': '信仰奨励', 'hasItem': 2},
    {'number': '6', 'title': '成長と貢献', 'hasItem': 1},
  ];

  List<Map<String, dynamic>> fuji = [
    {'number': '1', 'title': '基本', 'hasItem': 2},
    {'number': '2', 'title': 'スカウト技能', 'hasItem': 2},
    {'number': '3', 'title': 'スカウト精神', 'hasItem': 1},
    {'number': '4', 'title': '奉仕', 'hasItem': 3},
    {'number': '5', 'title': '信仰奨励', 'hasItem': 1},
    {'number': '6', 'title': '成長と貢献', 'hasItem': 1},
  ];
  List<Map<String, dynamic>> gino = [
    {'number': '01', 'title': '野営章', 'hasItem': 8},
    {'number': '02', 'title': '野営管理章', 'hasItem': 7},
    {'number': '03', 'title': '救急章', 'hasItem': 3},
    {'number': '04', 'title': '野外炊事章', 'hasItem': 7},
    {'number': '05', 'title': '公民章', 'hasItem': 8},
    {'number': '06', 'title': 'パイオニアリング章', 'hasItem': 7},
    {'number': '07', 'title': 'リーダーシップ章', 'hasItem': 5},
    {'number': '08', 'title': 'ハイキング章', 'hasItem': 8},
    {'number': '09', 'title': 'スカウトソング章', 'hasItem': 4},
    {'number': '10', 'title': '通信章', 'hasItem': 5},
    {'number': '11', 'title': '計測章', 'hasItem': 8},
    {'number': '12', 'title': '観察章', 'hasItem': 6},
    {'number': '13', 'title': '水泳章', 'hasItem': 9},
    {'number': '14', 'title': '案内章', 'hasItem': 5},
    {'number': '15', 'title': 'エネルギー章', 'hasItem': 8},
    {'number': '16', 'title': '介護章', 'hasItem': 5},
    {'number': '17', 'title': '看護章', 'hasItem': 4},
    {'number': '18', 'title': '手話章', 'hasItem': 6},
    {'number': '19', 'title': '世界友情章', 'hasItem': 7},
    {'number': '20', 'title': '通訳章', 'hasItem': 4},
    {'number': '21', 'title': '点字章', 'hasItem': 4},
    {'number': '22', 'title': '園芸章', 'hasItem': 8},
    {'number': '23', 'title': '演無線通信', 'hasItem': 5},
    {'number': '24', 'title': '音楽章', 'hasItem': 7},
    {'number': '25', 'title': '絵画章', 'hasItem': 3},
    {'number': '26', 'title': '華道章', 'hasItem': 6},
    {'number': '27', 'title': '茶道章', 'hasItem': 5},
    {'number': '28', 'title': '写真章', 'hasItem': 5},
    {'number': '29', 'title': '書道章', 'hasItem': 7},
    {'number': '30', 'title': '竹細工章', 'hasItem': 3},
    {'number': '31', 'title': '伝統芸能章', 'hasItem': 2},
    {'number': '32', 'title': '文化財保護章', 'hasItem': 4},
    {'number': '33', 'title': '木工章', 'hasItem': 4},
    {'number': '34', 'title': '安全章', 'hasItem': 9},
    {'number': '35', 'title': '沿岸視察章', 'hasItem': 6},
    {'number': '36', 'title': '家庭修理章', 'hasItem': 7},
    {'number': '37', 'title': '環境衛生章', 'hasItem': 7},
    {'number': '38', 'title': 'コンピューター章', 'hasItem': 7},
    {'number': '39', 'title': '裁縫章', 'hasItem': 5},
    {'number': '40', 'title': '搾乳章', 'hasItem': 7},
    {'number': '41', 'title': '自動車章', 'hasItem': 3},
    {'number': '42', 'title': '事務章', 'hasItem': 6},
    {'number': '43', 'title': '珠算章', 'hasItem': 2},
    {'number': '44', 'title': '消防章', 'hasItem': 10},
    {'number': '45', 'title': '信号章', 'hasItem': 5},
    {'number': '46', 'title': '森林愛護章', 'hasItem': 9},
    {'number': '47', 'title': '洗濯章', 'hasItem': 7},
    {'number': '48', 'title': '測量章', 'hasItem': 7},
    {'number': '49', 'title': '測候章', 'hasItem': 8},
    {'number': '50', 'title': '鳥類保護章', 'hasItem': 4},
    {'number': '51', 'title': '釣り章', 'hasItem': 6},
    {'number': '52', 'title': '溺者救助章', 'hasItem': 5},
    {'number': '53', 'title': '電気章', 'hasItem': 6},
    {'number': '54', 'title': '天文章', 'hasItem': 7},
    {'number': '55', 'title': '土壌章', 'hasItem': 7},
    {'number': '56', 'title': '農機具章', 'hasItem': 5},
    {'number': '57', 'title': '農業経営章', 'hasItem': 5},
    {'number': '58', 'title': '簿記章', 'hasItem': 2},
    {'number': '59', 'title': '無線通信章', 'hasItem': 3},
    {'number': '60', 'title': '有線通信章', 'hasItem': 4},
    {'number': '61', 'title': '養鶏章', 'hasItem': 9},
    {'number': '62', 'title': '養豚章', 'hasItem': 7},
    {'number': '63', 'title': 'ラジオ章', 'hasItem': 6},
    {'number': '64', 'title': 'わら工章', 'hasItem': 3},
    {'number': '65', 'title': 'アーチェリー章', 'hasItem': 6},
    {'number': '66', 'title': 'オリエンテーリング章', 'hasItem': 7},
    {'number': '67', 'title': 'カヌー章', 'hasItem': 7},
    {'number': '68', 'title': '自転車章', 'hasItem': 4},
    {'number': '69', 'title': 'スキー章', 'hasItem': 3},
    {'number': '70', 'title': 'スケート章', 'hasItem': 5},
    {'number': '71', 'title': '漕艇章', 'hasItem': 8},
    {'number': '73', 'title': '馬事章', 'hasItem': 10},
    {'number': '74', 'title': 'パワーボート章', 'hasItem': 6},
    {'number': '75', 'title': 'ヨット章', 'hasItem': 7},
    {'number': '76', 'title': '武道・武術章', 'hasItem': 2},
    {'number': '77', 'title': '環境保護章', 'hasItem': 7},
    {'number': '78', 'title': '報道章', 'hasItem': 8},
    {'number': '79', 'title': '薬事章', 'hasItem': 8},
    {'number': '80', 'title': '防災章', 'hasItem': 10},
    {'number': '81', 'title': '情報処理章', 'hasItem': 8},
    {'number': '82', 'title': '情報通信章', 'hasItem': 8},
    {'number': '83', 'title': 'ネットユーザー章', 'hasItem': 8},
  ];

  List<List<dynamic>> content_syokyu = [
    [
      '「ちかい」と「おきて」が言える。そのうえで、隊長と話し合う。',
      '「スカウト章」、「モットー」、「スローガン」の意味を説明できる。',
      '日本の国旗の正しい様式を知り、集会で掲揚柱に掲揚する。',
      '「連盟歌」が歌える。',
      '普段の集会で必要なもの（訓練用具）を知り、携行する。',
      'スカウトサイン、敬礼、スカウトの握手ができる。',
    ],
    [
      '体温と脈拍を正しく測ることができる。',
    ],
    [
      '自分の体や身近にあるものを用いて簡単な計測を行う。'
          '集会で使う身ぶり信号（気をつけ、休め、すわれ、分かれと集合隊形の各種サイン）、笛の合図を覚える。',
      '次のロープ結びの使い道を理解し、実際に行う。\nア）本結び イ）一重つぎ ウ）ふた結び エ）もやい結び オ）8の字結び',
    ],
    [
      '集会などで行う社会奉仕活動へ積極的に参加する',
    ],
    [
      '隊集会やキャンプ、ハイキングで行うスカウツオウン・サービスに参加する。【信仰奨励章（2）と共通】',
    ],
    [
      '初級スカウトとして進級することを班長会議で認めてもらう。',
    ]
  ];

  List<List<dynamic>> content_nikyu = [
    [
      '「ちかい」と「おきて」について意味を説明でき、その実践に努力していることを隊長に認めてもらう。',
      '日本の国旗の意味、歴史、仕様を説明でき、班や隊の活動で国旗を正しく掲揚できる。',
      '外国旗およびその国のスカウト章を5か国以上見分ける。',
    ],
    [
      '体温、脈拍と体調との関係について説明する。',
      '日常遭遇しやすい次のような場合の応急手当や対応を説明できる。 \nア）鼻血 イ）目のちり ウ）やけど エ）指の切り傷 オ）立ちくらみ カ）頭痛 キ）蜂、ダニ、毛虫などの虫さされ ク）熱中症',
      '三角布で他の人の頭、手、ひざ、足に包帯を巻き、腕を吊る方法を実演する。',
      '隊または班の安全係を3か月以上担当する。',
    ],
    [
      '16方位と方位角の呼び方を覚え、コンパスで進路を発見する。',
      '2万5千分の1の地形図を用いて次のことをする。\ア）図上に示された２つの地点の間の方位角、直線距離、標高差、道路に沿った歩行距離を読む。\nイ）真北と磁北の違いを説明する。 \nウ）500m（または1km）ごとの方眼を正確に書き入れた地形図により、6桁（または8桁）座標読みを行い、示された地点に到達する。',
      '三角点、水準点、標高点、等高線とは何かを知り、三角点または水準点の標石を発見する。',
      '10個以上の地形図記号を覚える。',
      'コンパスを用い、バックベアリングができる。',
      '地図とコンパスを用いた10km程度のハイキングを計画し、隊長の指名する2級以上のスカウト（ただし、適任者がいない場合はベンチャースカウトも可）とともに、保護者の同意のもと実施し、報告する。このハイキングは1.基本（1）および6.班長会議（1）以外の課目を終了した後に、仕上げの課題として行う。',
      '次の野外料理を作る。\nア）複数人数分の米飯および味噌汁\nイ）複数人数分の野菜、肉、魚、玉子を材料とした2種類以上の料理',
      'かま、なた、のこぎりを安全に使用でき、手入れと保管ができる。',
      '火口、焚き火、薪を作り、マッチ2本で火を起こし、500mLの水を沸騰させる。',
      '次のロープ結びの使い道を理解し、実際に行う。\nア）巻き結び イ）ねじ結び\nウ）引きとけ結び エ）ちぢめ結び\nオ）腰掛け結び カ）てぐす結び\nキ）てこ結び ク）張り綱結び',
      '食用植物、有害植物をそれぞれ2種類以上見分ける。【観察章課題（1）と共通】',
      '24個の小さな物を1分間観察し、そのうちの16個以上を記憶によって答える。【観察章課目（2）と共通】',
      '100ｍの距離を誤差5％以内で歩測する。【計測章課目（3）と共通】',
      'スカウトペースで、2kmを15分で移動する。【計測章課題（4）と共通】',
      'はかりや計量器を使わずに、1合の米、１Lの水を15％以内の誤差で測る。【計測章課題（5）と共通】',
      '片かな手旗信号で15の原画を理解し、10文字程度の語句を発信、受信できる。',
      '追跡記号を10種類以上覚える。【通信章課目（3）と共通】',
    ],
    [
      'デンコーチとして3ヶ月以上の奉仕、または社会奉仕活動を３回以上実施する。',
    ],
    [
      'スカウツオウン・サービスで、自分ができる役割を果たし、「ちかい」と「おきて」を日常で実践したこと、感じたことを発表する。【信仰奨励章（3）と共通】',
    ],
    [
      '初級スカウトとして3か月以上、隊および班活動に進んで参加したことを班長会議で認めてもらう。',
    ]
  ];

  List<List<dynamic>> content_ikkyu = [
    [
      '「ちかい」と「おきて」の実践に努力していることを日常生活で示す。',
      '姉妹都市または自分が興味を持っている2か国の民族、文化、通過、言語を調べ、隊または班集会で話す。',
      '日本の国旗と外国旗を併用して掲揚および設置する時の注意事項を知る。',
      '半旗の意味と正しい掲揚の方法を知る。',
    ],
    [
      '50m泳ぐか1000mを走り、自己記録を更新できるように努力する。',
      '水分や食物の補給が体調に与える影響を知り、体調を管理するための準備ができる。',
      '班員1人と協力して、急造担架を作り、実際に人を運ぶ。',
      '直接圧迫止血法と間接圧迫止血法の違いを知り、直接圧迫止血による応急処置ができる。',
    ],
    [
      '班の炊事係として、2泊3日以上のキャンプの調理を担当する。',
      '自然物（石、木、竹等）を用いた、キャンプに役立つ工作を１つ以上作成する。',
      'マッチに防水加工を施し、携帯用の防水容器に入れて提出する。【野外炊事章課目（3）と共通】',
      '連続5泊以上の、隊キャンプか自団の隊または班で参加できる地区、県連盟、日本連盟のキャンプ大会に参加する。',
      'キャンプにおける用便、ゴミ処理ならびに食料保管について、衛生上注意する点を知り、実践できる。',
      '1級旅行（1泊24時間以上のハイキング）の計画書を作成し、必要な個人装備を携行して隊長の指名するベンチャースカウト（ただし適任者がいない場合は1級以上のスカウト）とともに、隊長より与えられた課題と方法によりキャンプを行い、報告する。このキャンプは1.基本（1）および6.班長会議（1）以外の課目を修了した後に、仕上げの課目として行う。',
      '日中、夜間においてコンパスを用いずに2種類の方法で方位を発見する。',
      '300m以上の距離に追跡記号を設置し、班員を誘導する。【通信章課目（4）と共通】',
      'クロスベアリングの手法を行い、地形図上で現在地を発見する。',
      '次のロープ結びの使いみちを理解し、実際に行う。ア）垣根結び イ）よろい結び ウ）バタフライノット エ）馬つなぎ オ）からみ止め カ）バックスプライス キ）角しばり ク）はさみしばり ケ）筋かいしばり',
      '樹木5種類以上をスケッチまたは写真で記録し、特徴を述べる。【観察章課目（4）と共通】',
      '北極星の発見方法を知り、北極星を発見できる。また、５つの星座を発見できる。【観察章課題（5）と共通】',
      '身近にいる動物（ほ乳類、鳥類、魚類など）について観察し、報告する、【観察章課目（6）と共通】',
      '自作の簡易測量器具を用いて、樹木などの高さを誤差10%以内で測る。【計測章課目（6）と共通】',
      '簡易測量法を用い、到達できない2点間の距離（長さ、高さ）を誤差10%以内で測る。【計測章課目（7）と共通】',
      'ハイキングで野帳をつけ、またその野帳によって略地図を作る。【ハイキング章（6）と共通】',
      '片かな手旗信号で20文字以上の文書を発信、受信できる。',
      '号笛を使って野外でできる簡単な通信ゲームを考え実施するか、号笛を使用した救難信号を覚える。',
      'ハイキング章取得',
      'スカウトソング章取得',
    ],
    [
      '班での奉仕活動を計画し、隊長の承認を得て実施、報告する。',
      '自分の住んでいる地域にある３つ以上の施設へ案内ができる。',
    ],
    [
      '隊集会やキャンプ、ハイキングで行うスカウツオウン・サービスで、主要な役割を果たす。【信仰奨励章（4）と共通】',
    ],
    [
      '2級スカウトとして3ヶ月以上、隊および班活動に進んで参加したことを班長会議で認めてもらう。',
    ],
  ];

  List<List<dynamic>> content_kiku = [
    [
      '「ちかい」と「おきて」の実践に努力して他のスカウトの模範となる。',
      '班長や次長（グリーンバー）、またはジュニアリーダーとして隊運営に6か月以上携わる。',
      'B・Pのラストメッセージを読み、隊長とその内容について話をする。',
      '外国スカウトの「おきて」を調べる。できれば外国スカウトや指導者に直接教えてもらう。',
    ],
    [
      '5分間泳ぐか1000メートルを走り、自己記録を更新できるように努力する。',
      'AED（自動体外式除細動器)について以下のことが説明できる。\nア)AEDとは何か　\nイ）どのような時に説明できるか　\nウ）使用の手順',
      'たばこ、アルコール、薬物が人体へ及ぼす害について知る。',
    ],
    [
      '技能章から「野営章」「野外炊事章」「リーダーシップ章」を取得する。',
      '班長や次長（グリーンバー）として班キャンプ、またはジュニアリーダーとして隊キャンプの計画を行い1泊以上の固定キャンプを実施し隊長に報告書を提出する。',
    ],
    [
      '団や地域で取り組んでいる奉仕活動に4日（1日1時間以上）参加する。',
    ],
    [
      '1. 信仰奨励章を取得する。',
    ],
    [
      '1級スカウトとして最低4か月、隊および班活動に進んで参加したことを班長会議で認めてもらう。',
    ]
  ];

  List<List<dynamic>> content_hayabusa = [
    [
      '菊スカウトとして最近6か月間、「ちかい」と「おきて」の実践に最善をつくす。',
    ],
    [
      '自分を含めた2以上のベンチャースカウトで、安全と衛生および環境に配慮した2泊3日以上の移動キャンプ(歩行距離20kmまたは自転車100km以上)を計画し、隊長の承認を得て実施、報告する。',
      '次のスカウト技能のいずれかをボーイスカウト隊で指導する。\n①計測　②通信　③ロープ結び',
      '救急章の取得',
      'パイオニアリング章の取得',
    ],
    [
      '『スカウティング・フォア・ボーイズ』のキャンプファイア物語21、22および26を読み、内容について隊長と話しあう。',
    ],
    [
      '他部門の活動へ6か月以上にわたり奉仕し、その実績を報告する。',
      '社会的弱者(高齢者、障がい者等)への支援活動を積極的に行い、隊長に活動記録を提出する。',
    ],
    [
      '自分の所属または興味をもった宗教派の歴史と教えを知る。',
      '自分の所属または興味をもった宗教派の宗教行事について知る。',
    ],
    [
      'チームプロジェクトのチーフか主要な役割としてプロジェクトを計画、実施し、隊長に報告書を提出する。または、3泊4日以上の隊キャンプの実施計画書を作成し、実際に運営を行い、隊長に報告する。',
    ],
  ];

  List<List<dynamic>> content_fuji = [
    [
      '隼スカウトとして最低6か月間、「ちかい」と「おきて」の実施に最善をつくす。',
      '現在の自分の考えと将来の進路についてまとめ、その内容について隊長と話し合う。',
    ],
    [
      '野営管理章を取得',
      '公民章を取得',
      '技能章を15個以上取得',
      '自ら設定する課題により、2泊3日の単独キャンプ(固定または移動)を計画し、隊長の承認を得て実施後、評価を報告書にまとめ隊長へ提出する。',
    ],
    [
      '『スカウティング・フォア・ボーイズ』を読み、感想文を提出する。',
    ],
    [
      '地域社会や学校などでの奉仕活動を企画し、隊長の承認を得て実施、報告する',
      '地区、県連盟、日本連盟の行事等に奉仕し、その実績を報告する。',
      '地区、県連盟、日本連盟の行事等に奉仕し、その実績を報告する。',
    ],
    [
      '地区、県連盟、日本連盟の行事等に奉仕し、その実績を報告する。',
    ],
    [
      '奉仕の意義について理解し、自身が今後の人生においてどのように社会に対して奉仕貢献できるかを文章にまとめ隊長と話し合う。',
    ],
    [
      '宗教章を取得するか、取得に対して努力したことを隊長に認めてもらう。',
    ],
    [
      '隼スカウトとして自己の成長と社会に役立つための課題を設定し、個人プロジェクト( 研究、製作、実験など) を自ら企画して隊長の承認を得たうえで、少なくとも１か月以上にわたって実施、完結させ、隊長に企画書、計画書、および報告書を提出する。',
    ]
  ];

  /*String call(String type, int number){
  }*/

  List<Map<String, dynamic>> getAllMap(String type) {
    List<Map<String, dynamic>> list_info;
    switch (type) {
      case 'usagi':
        list_info = usagi;
        break;
      case 'sika':
        list_info = sika;
        break;
      case 'kuma':
        list_info = kuma;
        break;
      case 'challenge':
        list_info = challnege;
        break;
      case 'syokyu':
        list_info = syokyu;
        break;
      case 'nikyu':
        list_info = nikyu;
        break;
      case 'ikkyu':
        list_info = ikkyu;
        break;
      case 'kiku':
        list_info = kiku;
        break;
      case 'hayabusa':
        list_info = kiku;
        break;
      case 'fuji':
        list_info = fuji;
        break;
      case 'gino':
        list_info = gino;
        break;
    }
    return list_info;
  }

  Map<String, dynamic> getPartMap(String type, int number) {
    Map<String, dynamic> map_info;
    switch (type) {
      case 'usagi':
        map_info = usagi[number];
        break;
      case 'sika':
        map_info = sika[number];
        break;
      case 'kuma':
        map_info = kuma[number];
        break;
      case 'challenge':
        map_info = challnege[number];
        break;
      case 'syokyu':
        map_info = syokyu[number];
        break;
      case 'nikyu':
        map_info = nikyu[number];
        break;
      case 'ikkyu':
        map_info = ikkyu[number];
        break;
      case 'kiku':
        map_info = kiku[number];
        break;
      case 'hayabusa':
        map_info = kiku[number];
        break;
      case 'fuji':
        map_info = fuji[number];
        break;
      case 'gino':
      case 'gino':
        map_info = gino[number];
        break;
    }
    return map_info;
  }

  String getContent(String type, int page, int number) {
    String content;
    switch (type) {
      case 'usagi':
        //map_info = usagi[number];
        break;
      case 'sika':
        //map_info = sika[number];
        break;
      case 'kuma':
        //map_info = kuma[number];
        break;
      case 'challenge':
        //map_info = challnege[number];
        break;
      case 'syokyu':
        content = content_syokyu[page][number];
        break;
      case 'nikyu':
        content = content_nikyu[page][number];
        break;
      case 'ikkyu':
        content = content_ikkyu[page][number];
        break;
      case 'kiku':
        content = content_kiku[page][number];
        break;
      case 'gino':
        //content = content_gino[page][number];
        break;
    }
    return content;
  }
}
