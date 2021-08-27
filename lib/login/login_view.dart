import 'package:cubook/home/home_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
                          return RaisedButton(
                            color: Colors.blue[900],
                            onPressed: () async {
                              final providers = [
                                AuthUiProvider.email,
                                AuthUiProvider.apple,
                                AuthUiProvider.google,
                              ];

                              final result = await FlutterAuthUi.startUi(
                                items: providers,
                                tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                                  tosUrl:
                                      "https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md",
                                  privacyPolicyUrl:
                                      'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Privacy_Policy.md',
                                ),
                                androidOption: AndroidOption(
                                  enableSmartLock: true, // default true
                                  showLogo: false, // default false
                                  overrideTheme: true, // default false
                                ),
                                emailAuthOption: EmailAuthOption(
                                  requireDisplayName: true,
                                  // default true
                                  enableMailLink: false,
                                  // default false
                                  handleURL: '',
                                  androidPackageName: '',
                                  androidMinimumVersion: '',
                                ),
                              );
                              print(result);
                              model.login();
                              /*FirebaseAuthUi.instance()
                                      .launchAuth(
                                    [
                                      AuthProvider.email(),
                                      // Login/Sign up with Email and password
                                      AuthProvider.google(),
                                      // Login with Google
                                    ],
                                    tosUrl:
                                    'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md',
                                    // Optional
                                    privacyPolicyUrl:
                                    'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Privacy_Policy.md', // Optional,
                                  )
                                      .then((firebaseUser) =>
                                      model.login())
                                      .catchError((dynamic error) =>
                                      print('Error $error'));*/
                            },
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'ログインしてはじめる',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          );
                        }),
                      ),
                    ),
                  ],
                ))));
  }
}
