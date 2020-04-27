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
                    child: Center(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 5, top: 4),
                            child: Icon(
                              Icons.people,
                              color: Theme.of(context).accentColor,
                              size: 28,
                            ),
                          ),
                          Text(
                            '登録済み・登録コードをお持ちの方',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ]))),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Consumer<HomeModel>(
                      builder: (context, model, child) {
                        return RaisedButton(
                          color: Theme.of(context).accentColor,
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
                                'ログイン',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 5, top: 4),
                            child: Icon(
                              Icons.group_add,
                              color: Theme.of(context).accentColor,
                              size: 28,
                            ),
                          ),
                          Text(
                            '隊として初めて利用する',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ]))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        '正式配信開始までお待ちください',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    )),
              ],
            )));
  }
}
