import 'package:cubook/home/home_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: SizedBox(
                height: kIsWeb ? 400:250,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Text(
                          'カブブックサインアプリ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                        label: 'カブック',
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'cubook',
                              style: TextStyle(
                                fontSize: 43,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        child: Consumer<HomeModel>(
                          builder: (context, model, child) {
                            if (kIsWeb) {
                              return Column(children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    controller: model.mailAddressController,
                                    enabled: true,
                                    // 入力数
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    maxLengthEnforced: false,
                                    decoration:
                                        InputDecoration(labelText: "メールアドレス"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    obscureText: true,
                                    controller: model.passwordController,
                                    enabled: true,
                                    // 入力数
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    maxLengthEnforced: false,
                                    decoration:
                                        InputDecoration(labelText: "パスワード"),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 14),
                                    child: RaisedButton(
                                      color: Colors.blue[900],
                                      onPressed: () async {
                                        final GoogleSignIn _googleSignIn =
                                            GoogleSignIn();
                                        final FirebaseAuth _auth =
                                            FirebaseAuth.instance;
                                        GoogleSignInAccount googleCurrentUser =
                                            _googleSignIn.currentUser;
                                        try {
                                          final result = await FirebaseAuth
                                              .instance
                                              .signInWithEmailAndPassword(
                                                  email: model
                                                      .mailAddressController
                                                      .text,
                                                  password: model
                                                      .passwordController.text);
                                          final User user = result.user;
                                          print(
                                              "signed in " + user.displayName);
                                          model.login();
                                          return user;
                                        } catch (e) {
                                          print(e);
                                          return null;
                                        }
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            'ログイン',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                    )),
                                RaisedButton(
                                  color: Colors.blue[900],
                                  onPressed: () async {
                                    if (kIsWeb) {
                                      final GoogleSignIn _googleSignIn =
                                          GoogleSignIn();
                                      final FirebaseAuth _auth =
                                          FirebaseAuth.instance;
                                      GoogleSignInAccount googleCurrentUser =
                                          _googleSignIn.currentUser;
                                      try {
                                        if (googleCurrentUser == null)
                                          googleCurrentUser =
                                              await _googleSignIn
                                                  .signInSilently();
                                        if (googleCurrentUser == null)
                                          googleCurrentUser =
                                              await _googleSignIn.signIn();
                                        if (googleCurrentUser == null)
                                          return null;

                                        GoogleSignInAuthentication googleAuth =
                                            await googleCurrentUser
                                                .authentication;
                                        final AuthCredential credential =
                                            GoogleAuthProvider.credential(
                                          accessToken: googleAuth.accessToken,
                                          idToken: googleAuth.idToken,
                                        );
                                        final User user =
                                            (await _auth.signInWithCredential(
                                                    credential))
                                                .user;
                                        print("signed in " + user.displayName);

                                        model.login();
                                        return user;
                                      } catch (e) {
                                        print(e);
                                        return null;
                                      }
                                    } else {
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
                                          .then((firebaseUser) =>
                                              model.login())
                                          .catchError((dynamic error) =>
                                              print('Error $error'));
                                    }
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Google でログイン',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                                ),
                              ]);
                            } else {
                              return RaisedButton(
                                color: Colors.blue[900],
                                onPressed: () async {
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
                                      .then((firebaseUser) =>
                                      model.login())
                                      .catchError((dynamic error) =>
                                      print('Error $error'));
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'ログインしてはじめる',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
