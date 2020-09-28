import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/home_view.dart';
import 'package:cubook/login/login_view.dart';
import 'package:cubook/signup/join/joinGroup_view.dart';
import 'package:cubook/signup/signup_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // エラー時に表示するWidget
          if (snapshot.hasError) {
            return Container(color: Colors.white);
          }
          // Firebaseのinitialize完了したら表示したいWidget
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                body: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: Theme
                        .of(context)
                        .accentColor == Colors.white
                        ? SystemUiOverlayStyle.light
                        : SystemUiOverlayStyle.dark, // Detect dark mode
                    child: SafeArea(
                        child: SingleChildScrollView(
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 800),
                                    child: Consumer<HomeModel>(
                                        builder: (context, model, child) {
                                          if (model.isLoaded) {
                                            if (model.currentUser != null) {
                                              if (model.userSnapshot != null) {
                                                if (model.userSnapshot
                                                    .data()['group'] != null) {
                                                  return HomeView(
                                                      model.userSnapshot
                                                          .data()['group'],
                                                      model.userSnapshot
                                                          .data()['position']);
                                                } else {
                                                  return JoinGroup();
                                                }
                                              } else {
                                                return SignupView();
                                              }
                                            } else {
                                              return LoginView();
                                            }
                                          } else {
                                            model.login();
                                            return Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Center(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child:
                                                        CircularProgressIndicator())));
                                          }
                                        })))))));
          }

          return Container();
        });
  }
}
