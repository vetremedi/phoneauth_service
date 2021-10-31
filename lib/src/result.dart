import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;

  /// error message for the given auth request
  final String? errorMessage;

  /// phone auth verification id
  final String? verificationId;

  /// The code sent to and entered by the user.
  final String? smsCode;

  AuthResult({this.user, this.smsCode})
      : errorMessage = null,
        verificationId = null;

  /// Triggered when verification fails and
  /// stores [errorMessage]
  AuthResult.error({this.errorMessage})
      : user = null,
        smsCode = null,
        verificationId = null;

  /// Triggered when SMS sent or time out and
  /// stores [verificationId] sent by firebase
  AuthResult.tokenSent({this.verificationId})
      : user = null,
        smsCode = null,
        errorMessage = null;

  bool get hasUser => smsCode != null && smsCode!.isNotEmpty;

  bool get hasToken => verificationId != null && verificationId!.isNotEmpty;

  @override
  String toString() {
    return "AuthResult(error: $errorMessage, smsCode: $smsCode, user: $user, verificationId: $verificationId)";
  }
}
