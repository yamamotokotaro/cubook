import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/addLump_ScoutList/addLumpScoutList_model.dart';
import 'package:cubook/addLump_SelectItem/addLumpSelectItem_view.dart';
import 'package:cubook/invite/invite_model.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLumpScoutListView extends StatelessWidget {
  var theme = new ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('対象のスカウトを選択'),
      ),
      floatingActionButton: Consumer<AddLumpScoutListModel>(
        builder: (context, model, child) => FloatingActionButton.extended(
          onPressed: () {
            List<String> list_uid = new List<String>();
            for(int i=0; i < model.userSnapshot.length; i++){
              if(model.list_isTarget[i]){
                list_uid.add(model.userSnapshot[i]['uid']);
              }
            }
            print(list_uid);
            Navigator.push(context, MaterialPageRoute<AddLumpSelectItemView>(
                builder: (BuildContext context) {
                  return AddLumpSelectItemView(list_uid);
                }));
          },
          label: Text('次へ'),
          icon: Icon(Icons.arrow_forward),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 80),
                      child: Consumer<AddLumpScoutListModel>(
                          builder: (context, model, child) {
                        if (!model.isGet) {
                          model.getSnapshot();
                        }
                        if (model.userSnapshot != null) {
                          if (model.userSnapshot.length != 0) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: model.userSnapshot.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot snapshot =
                                      model.userSnapshot[index];
                                  return Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              model.onPressedCheck(index);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            theme.getThemeColor(
                                                                snapshot[
                                                                    'age']),
                                                        shape: BoxShape.circle),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        snapshot['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25),
                                                      )),
                                                  Spacer(),
                                                  Checkbox(
                                                    value: model
                                                        .list_isTarget[index],
                                                    onChanged: (bool e) {
                                                      model.onPressedCheck(
                                                          index);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                                });
                          } else {
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: 5, left: 10, right: 10),
                              child: Container(
                                  child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.bubble_chart,
                                          color: Theme.of(context).accentColor,
                                          size: 35,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: Text(
                                                'スカウトを招待しよう',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            )),
                                      ]),
                                ),
                              )),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
