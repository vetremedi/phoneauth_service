import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:phoneauth_api/src/result.dart';

const String kGenericErrorMessage =
    "error occurred during phone number verification";

class FirebaseAuthApi {
  /// [timeOut] in seconds
  FirebaseAuthApi({int timeout = 30}) : seconds = timeout;

  final int seconds;

  final _firebaseAuth = FirebaseAuth.instance;

  /// Broadcasts [AuthResult] to all the subscribed listeners
  final StreamController<AuthResult> _controller =
      StreamController<AuthResult>.broadcast();

  User? get authUser => _firebaseAuth.currentUser;

  bool get hasAuthUser => _firebaseAuth.currentUser != null;

  Future<AuthResult> verifyCode(
      {required String verificationId, required String codeSent}) async {
    var credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: codeSent);

    try {
      var result = await _firebaseAuth.signInWithCredential(credential);

      log("phone number verified manually");
      return AuthResult(user: result.user, smsCode: credential.smsCode);
    } catch (e) {
      log("manual phone verification failed with error", error: e);
      return AuthResult.error(
          errorMessage: 'The code you entered is invalid, please try again');
    }
  }

  Stream loginWithPhoneNumber({required String phone}) {
    _phoneLogin(phone);
    return _controller.stream;
  }

  _phoneLogin(String phone) {
    try {
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: _handlePhoneVerified,
        verificationFailed: _handleVerificationFailed,
        codeSent: (String verificationId, int? forceResendingToken) {
          log("code has been sent to $phone");
          _controller.add(AuthResult.tokenSent(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("timed out auto-detecting code");
          _controller.add(AuthResult.tokenSent(verificationId: verificationId));
        },
      );
    } on FirebaseAuthException catch (e) {
      _handleVerificationFailed(e);
    } on Exception catch (e) {
      log(kGenericErrorMessage, error: e);
      _controller
          .addError(AuthResult.error(errorMessage: kGenericErrorMessage));
    }
  }

  _handlePhoneVerified(PhoneAuthCredential authCredential) async {
    var result = await _firebaseAuth.signInWithCredential(authCredential);

    log("phone number verified successfully");
    _controller
        .add(AuthResult(user: result.user, smsCode: authCredential.smsCode));
  }

  _handleVerificationFailed(FirebaseAuthException e) {
    log('error occurred during phone number verification', error: e);
    _controller.addError(AuthResult.error(errorMessage: e.message));
  }
}
