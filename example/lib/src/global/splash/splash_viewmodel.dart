import 'package:example/src/app/app.locator.dart';
import 'package:example/src/app/app.router.dart';
import 'package:phoneauth_service/phoneauth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  final _auth = locator<FirebaseAuthApi>();
  final _navigation = locator<NavigationService>();

  onStart() {
    if (_auth.hasAuthUser) {
      //
      _navigation.navigateTo(Routes.homeView);
    } else {
      //
      _navigation.navigateTo(Routes.loginView);
    }
  }
}
