import 'package:cubook/addLump_ScoutList//addLumpScoutList_view.dart';
import 'package:cubook/invite/invite_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeLumpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('一括サイン'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushNamed('/addLumpScoutList');
            },
            label: Text('サインを始める'),
            icon: Icon(Icons.edit),
        ),
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 800),
                        child:
                        Consumer<InviteModel>(builder: (context, model, child) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 5),
                                child: Container(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed('/addLumpScoutList');
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add_circle,
                                                  color: Theme.of(context).accentColor,
                                                  size: 35,
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: Material(
                                                      type: MaterialType.transparency,
                                                      child: Text(
                                                        ' 新規サイン',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.normal, fontSize: 30),
                                                      ),
                                                    )),
                                              ]),
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          );
                        })),
                  )));
        }));
  }
}
