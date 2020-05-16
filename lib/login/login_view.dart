import 'package:cubook/home/home_model.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: SizedBox(
              height: 250,
                child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  'カブブックサインアプリ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'cubook',
                  style: TextStyle(
                      fontSize: 43,
                      fontWeight: FontWeight.bold,),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                child: Consumer<HomeModel>(
                  builder: (context, model, child) {
                    return RaisedButton(
                      color: Colors.blue[900],
                      onPressed: () {
                        FirebaseAuthUi.instance()
                            .launchAuth(
                              [
                                AuthProvider.email(),
                                // Login/Sign up with Email and password
                                AuthProvider.google(),
                                // Login with Google
                              ],
                              tosUrl:
                                  "https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md",
                              // Optional
                              privacyPolicyUrl:
                                  "https://github.com/yamamotokotaro/cubook/blob/master/Terms/Privacy_Policy.md", // Optional,
                            )
                            .then((firebaseUser) => model.login())
                            .catchError(
                                (dynamic error) => print('Error $error'));
                      },
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'ログインしてはじめる',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    );
                  },
                ),
              ),
            ),
          ],
        ))));
  }
}
