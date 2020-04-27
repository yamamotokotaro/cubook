import 'package:cubook/signup/create/createGroup_view.dart';
import 'package:cubook/signup/join/joinGroup_view.dart';
import 'package:cubook/signup/signup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupView extends StatelessWidget {
  static final list_select = [
    '登録コードを入力',
    'グループを新規作成',
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              '以下から操作する内容を選択してください',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  child: ListView.builder(
                      itemCount: list_select.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder:
                          (BuildContext context, int index) {
                        return Consumer<SignupModel>(
                            builder: (context, model,
                                child) =>
                                Container(
                                  child: Card(
                                    color:
                                    model.isSelect_type[
                                    index]
                                        ? Colors.blue[900]
                                        .withAlpha(60)
                                        : Colors.grey
                                        .withAlpha(
                                        20),
                                    elevation: 0,
                                    child: InkWell(
                                      onTap: () {
                                        model
                                            .clickPublicButton(
                                            index);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            EdgeInsets
                                                .all(10),
                                            child: Text(
                                              list_select[
                                              index],
                                              style:
                                              TextStyle(
                                                fontSize: 17,
                                                fontWeight:
                                                FontWeight
                                                    .bold,
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
              builder: (context, model, child) => model
                  .isSelect_type[1]
                  ? CreateGroupView()
                  : JoinGroup())
        ],
      ),
    );
  }
}