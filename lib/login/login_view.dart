import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Card(
              child: FlatButton(
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
                      .then((firebaseUser) =>
                      print(
                          "Logged in user is ${firebaseUser.displayName}"))
                      .catchError((error) => print("Error $error"));
                },
                child: Text('ログイン'),
              ),
            ),
          ),
    );
  }
}