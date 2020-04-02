import 'package:cubook/challenge_detail/challengeDetail_model.dart';
import 'package:cubook/challenge_detail/challengeDetail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeView extends StatelessWidget {
  var list_number = [
    '1-1',
    '1-2',
    '1-3',
    '1-4',
    '1-5',
    '1-6',
    '1-7',
    '1-8',
    '2-1',
    '2-2',
    '2-3',
    '2-4',
    '2-5',
    '2-6'
  ];
  var list_title = [
    '国際',
    '市民',
    '友情',
    '動物愛護',
    '案内',
    '自然保護',
    '手伝い',
    '災害援助',
    '天文学者',
    '自然観察',
    'ハイカー',
    'キャンプ',
    '地質学者',
    '気象学者'
  ];
  var list_percentage = [
    1.0,
    1.0,
    0.8,
    0.3,
    0.6,
    0.1,
    0.0,
    0.4,
    0.0,
    0.66,
    1.0,
    0.2,
    0.0,
    0.4
  ];

  @override
  Widget build(BuildContext context) {
    var list_isCompleted =
        new List.generate(list_percentage.length, (index) => false);
    for (int i = 0; i < list_percentage.length; i++) {
      if (list_percentage[i] == 1.0) {
        list_isCompleted[i] = true;
      }
    }
    return Scaffold(
      appBar: AppBar(elevation: 0, iconTheme: IconThemeData(color: Colors.white),backgroundColor: Colors.green[900],),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
                tag: 'card_challenge',
                child: Container(
                  color: Colors.green[900],
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Center(
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 13),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      'チャレンジ章',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 30,
                                          color: Colors.white),
                                    ),
                                  ))),
                        ]),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list_title.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              child: Card(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MyPageRoute(
                                          page: _ModalPage(), dismissible: true));
                                    },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(5),
                                              bottomLeft:
                                                  const Radius.circular(5)),
                                          color: Colors.green[900]),
                                      width: 85,
                                      height: 120,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(),
                                          child: Text(
                                            list_number[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      list_title[index],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25),
                                                    ))),
                                            list_isCompleted[index]
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          'かんしゅう🎉',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 20),
                                                        )),
                                                  )
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text('達成度'),
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        300],
                                                                valueColor:
                                                                    new AlwaysStoppedAnimation<
                                                                        Color>(Colors
                                                                            .green[
                                                                        900]),
                                                                value:
                                                                    list_percentage[
                                                                        index],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        )),
                                  ],
                                ),
                              )),
                            ));
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalPage extends StatelessWidget {
  PageController controller =
  PageController(initialPage: 0, viewportFraction: 0.8);
  int currentPage = 0;
  bool test = false;
  List<Widget> pages = <Widget>[
    ChallengeDetailView(),
    ChallengeSignView(),
    ChallengeAddView()
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChallengeDetailModel(),
        child: Container(
            height: MediaQuery.of(context).size.height - 200,
            child: PageView(
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
              },
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: pages,
            )));
  }
}
