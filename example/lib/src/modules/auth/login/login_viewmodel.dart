import 'dart:developer';

import 'package:example/src/app/app.locator.dart';
import 'package:example/src/app/app.router.dart';
import 'package:example/src/modules/auth/login/login_view.form.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth_api/phoneauth_api.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends FormViewModel {
  LoginViewModel({required this.emptyInput});
  final VoidCallback emptyInput;

  final _auth = locator<FirebaseAuthApi>();
  final _navigation = locator<NavigationService>();

  bool showCode = false;
  String errorMessage = "";
  String verificationId = "";

  login() {
    if (showCode) return verifyPhone();

    if (phoneValue != null && phoneValue!.isNotEmpty) {
      showCode = true;

      log("+91$phoneValue");

      _auth
          .loginWithPhoneNumber(phone: "+91$phoneValue")
          .listen((trigerredEvent) {
        AuthResult event = trigerredEvent;

        if (event.hasUser) {
          _navigation.navigateTo(Routes.homeView);
        }

        if (event.hasToken) {
          verificationId = event.verificationId!;
        }
      }).onError((error) {
        errorMessage = error.toString();
        showCode = false;
        notifyListeners();
      });
    }
    emptyInput.call();
  }

  verifyPhone() async {
    var result = await _auth.verifyCode(
        verificationId: verificationId, codeSent: phoneValue!);

    if (result.hasUser) _navigation.navigateTo(Routes.homeView);
  }

  @override
  void setFormStatus() {}
}
