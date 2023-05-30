import 'package:cubook/home/homeModel.dart';
import 'package:cubook/home/homeView.dart';
import 'package:cubook/login/login_view.dart';
import 'package:cubook/signup/join/joinGroup_view.dart';
import 'package:cubook/signup/signup_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // エラー時に表示するWidget
          if (snapshot.hasError) {
            return Container(color: Colors.white);
          }
          // Firebaseのinitialize完了したら表示したいWidget
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                body: SafeArea(
                    child: SingleChildScrollView(
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 800),
                                child: Consumer<HomeModel>(builder:
                                    (BuildContext context, HomeModel model,
                                        Widget? child) {
                                  if (model.isLoaded) {
                                    if (model.currentUser != null) {
                                      if (model.userSnapshot != null) {
                                        if (model.userSnapshot!.get('group') !=
                                            null) {
                                          return HomeView(
                                              model.userSnapshot!.get('group'),
                                              model.userSnapshot!
                                                  .get('position'));
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
                                    return const Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    CircularProgressIndicator())));
                                  }
                                }))))));
          }

          return Container();
        });
  }
}
