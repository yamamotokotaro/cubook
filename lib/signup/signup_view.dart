import 'package:cubook/home/homeModel.dart';
import 'package:cubook/signup/create/createGroup_view.dart';
import 'package:cubook/signup/join/joinGroup_view.dart';
import 'package:cubook/signup/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupView extends StatelessWidget {
  static final List<String> list_select = [
    '招待を受けている',
    '隊全体の中で初めて登録する',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Consumer<HomeModel>(builder:
                      (BuildContext context, HomeModel model, Widget? child) {
                    return TextButton(
                        child: const Text('ログアウト'),
                        onPressed: () {
                          model.logout();
                        });
                  })),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              'あてはまる項目を選択してください',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  child: ListView.builder(
                      itemCount: list_select.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Consumer<SignupModel>(
                            builder: (BuildContext context, SignupModel model,
                                    Widget? child) =>
                                Container(
                                  child: Card(
                                    color: model.isSelect_type[index]
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                        : Colors.grey.withAlpha(20),
                                    elevation: 0,
                                    child: InkWell(
                                      onTap: () {
                                        model.clickPublicButton(index);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              list_select[index],
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      }))),
          Consumer<SignupModel>(
              builder:
                  (BuildContext context, SignupModel model, Widget? child) =>
                      model.isSelect_type[0] || model.isSelect_type[1]
                          ? model.isSelect_type[1]
                              ? CreateGroupView()
                              : JoinGroup()
                          : Container())
        ],
      ),
    );
  }
}
