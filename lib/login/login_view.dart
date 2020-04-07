import 'package:cubook/home/home_model.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'cubook',
                      style: TextStyle(
                          fontSize: 43,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Card(
                      child: Consumer<HomeModel>(
                        builder: (context, model, child) {
                          return FlatButton(
                            onPressed: () {
                              FirebaseAuthUi.instance()
                                  .launchAuth(
                                    [
                                      AuthProvider.email(),
                                      // Login/Sign up with Email and password
                                      AuthProvider.google(),
                                      // Login with Google
                                    ],
                                    tosUrl: "https://my-terms-url", // Optional
                                    privacyPolicyUrl:
                                        "https://my-privacy-policy", // Optional,
                                  )
                                  .then((firebaseUser) => model.login())
                                  .catchError((error) => print("Error $error"));
                            },
                            child: Text('ログイン'),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
