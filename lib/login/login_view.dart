import 'dart:io';

import 'package:cubook/home/homeModel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
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
                    const Center(
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
                        child: const Center(
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
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        child: Consumer<HomeModel>(builder:
                            (BuildContext context, HomeModel model,
                                Widget? child) {
                          return FilledButton(
                            onPressed: () async {
                              dynamic providers;
                              if (!kIsWeb) {
                                if (Platform.isIOS) {
                                  providers = [
                                    AuthUiProvider.email,
                                    AuthUiProvider.apple,
                                    AuthUiProvider.google,
                                  ];
                                } else {
                                  providers = [
                                    AuthUiProvider.email,
                                    AuthUiProvider.google,
                                  ];
                                }
                              } else {
                                providers = [
                                  AuthUiProvider.email,
                                  AuthUiProvider.google,
                                ];
                              }

                              await FlutterAuthUi.startUi(
                                items: providers,
                                tosAndPrivacyPolicy: const TosAndPrivacyPolicy(
                                  tosUrl:
                                      'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Terms_of_Service.md',
                                  privacyPolicyUrl:
                                      'https://github.com/yamamotokotaro/cubook/blob/master/Terms/Privacy_Policy.md',
                                ),
                                androidOption: const AndroidOption(
                                  enableSmartLock: true, // default true
                                  showLogo: false, // default false
                                  overrideTheme: true, // default false
                                ),
                                emailAuthOption: const EmailAuthOption(
                                  requireDisplayName: true,
                                  // default true
                                  enableMailLink: false,
                                  // default false
                                  handleURL: '',
                                  androidPackageName: '',
                                  androidMinimumVersion: '',
                                ),
                              );
                              model.login();
                            },
                            child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'ログインしてはじめる',
                                  style: TextStyle(fontSize: 20),
                                )),
                          );
                        }),
                      ),
                    ),
                  ],
                ))));
  }
}
