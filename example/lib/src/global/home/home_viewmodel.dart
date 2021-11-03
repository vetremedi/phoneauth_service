import 'package:example/src/app/app.locator.dart';
import 'package:phoneauth_service/phoneauth_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final _auth = locator<FirebaseAuthApi>();

  String get user => _auth.authUser?.phoneNumber ?? "";
}
