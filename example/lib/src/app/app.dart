import 'package:example/src/global/home/home_view.dart';
import 'package:example/src/global/splash/splash_view.dart';
import 'package:example/src/modules/auth/login/login_view.dart';
import 'package:phoneauth_service/phoneauth_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: SplashView, initial: true),
  MaterialRoute(page: HomeView),
  MaterialRoute(page: LoginView)
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: SnackbarService),
  LazySingleton(classType: FirebaseAuthApi)
], logger: StackedLogger())
class StackedSetup {}
