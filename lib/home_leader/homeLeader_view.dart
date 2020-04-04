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
                      padding: EdgeInsets.all(40),
                      child: Text(
                        'リーダー',
                        style: GoogleFonts.notoSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            )),
                      ),
                    ),
          ]
              );
  }
}
