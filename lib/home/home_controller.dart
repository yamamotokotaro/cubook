import 'package:cubook/home/home_model.dart';
import 'package:cubook/home/home_view_new.dart';
import 'package:cubook/login/login_view.dart';
import 'package:cubook/signup/joinGroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: SingleChildScrollView(
        child:Consumer<HomeModel>(
            builder: (context, model, child) {
              if(model.isLoaded){
                if(model.currentUser !=null){
                  if(model.tokenMap['group'] != null) {
                    return HomeViewNew();
                  } else {
                    return JoinGroup();
                  }
                } else {
                  return LoginView();
                }
              } else {
                model.login();
                return Padding(padding: EdgeInsets.all(20),child:Center(child: CircularProgressIndicator(),));
              }
            }
          )
        )));
  }
}