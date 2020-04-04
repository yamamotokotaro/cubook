import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubook/home/home_model.dart';
import 'package:cubook/home_leader/homeLeader_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeLeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            child: Card(
              elevation: 8,
              color: Colors.blue[900],
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.edit, color: Colors.white, size: 35,),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                'サイン待ち11件',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                            )),
                      ]),
                ),
              ),
            )),
      ),
      Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Container(
            child: Card(
              color: Colors.white,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.edit, color: Colors.blue[900], size: 35,),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                '個別にサイン',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 30,
                                    color: Colors.black),
                              ),
                            )),
                      ]),
                ),
              ),
            )),
      ),
      Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 20),
        child: Container(
            child: Card(
              color: Colors.white,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.edit, color: Colors.blue[900], size: 35,),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                '一括サイン',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 30,
                                    color: Colors.black),
                              ),
                            )),
                      ]),
                ),
              ),
            )),
      ),
    ]);
  }
}
