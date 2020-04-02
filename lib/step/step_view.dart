import 'package:cubook/step_detail/stepDetail_model.dart';
import 'package:cubook/step_detail/stepDetail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepView extends StatelessWidget {
  var list_number = [
    '1',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '14'
  ];
  var list_title = [
    '笑顔１',
    '笑顔２',
    '運動',
    '安全',
    '清潔',
    '計測',
    'なわ結び',
    '工作',
    '表現',
    '観察',
    '野外活動',
    '役に立つ',
    '日本国旗',
    '世界の国々'
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
      appBar: AppBar(elevation: 0, iconTheme: IconThemeData(color: Colors.white),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
                  tag: 'card_step',
                  child: Container(
                    height: 56,
                    color: Colors.orange,
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
                                        'うさぎのカブブック',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 30,
                                            color: Colors.white),
                                      ),
                                    ))),
                          ]),
                    ),
                  )),
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
                              height: 120,
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
                                                topLeft:
                                                    const Radius.circular(5),
                                                bottomLeft:
                                                    const Radius.circular(5)),
                                            color: Colors.orange),
                                        width: 65,
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
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text('達成度'),
                                                            Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          300],
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
                                ),
                              ),
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
    StepDetailView(),
    StepSignView(),
    StepAddView()
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StepDetailModel(),
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
