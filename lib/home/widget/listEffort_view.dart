import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/widget/listEffort_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_model.dart';

class listEffort extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5, top: 4),
                child: Icon(
                  //ああああ
                  Icons.assignment,
                  color: Theme.of(context).accentColor,
                  size: 32,
                ),
              ),
              Text(
                'みんなの取り組み',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ])),
        Consumer<ListEffortModel>(builder: (context, model, child) {
          if (!model.isGet) {
            model.getSnapshot();
          }

          if(model.effortSnapshot != null) {
            List<DocumentSnapshot> listSnapshot = model.effortSnapshot.documents;
            return Padding(
              padding: EdgeInsets.all(0),
              child: ListView.builder(
                  itemCount: listSnapshot.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot documentSnapshot = listSnapshot[index];
                    String body = documentSnapshot['family'] +
                        documentSnapshot['call'] +
                        documentSnapshot['body'];
                    int congrats = documentSnapshot['congrats'];
                    String documentID = documentSnapshot.documentID;
                    Color color;
                    if (documentSnapshot['type'] == 'usagi') {
                      color = Colors.orange;
                    } else if (documentSnapshot['type'] == 'sika') {
                      color = Colors.green;
                    } else if (documentSnapshot['type'] == 'kuma') {
                      color = Colors.blue;
                    } else if (documentSnapshot['type'] == 'challenge') {
                      color = Colors.green[900];
                    }
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 220,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 120,
                                color: color,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  body,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              FlatButton.icon(
                                  onPressed: () {
                                    model.increaseCount(documentID);
                                  },
                                  icon: Icon(Icons.favorite_border),
                                  label: Text('おめでとう！' + congrats.toString()))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        })
      ],
    );
  }
}
