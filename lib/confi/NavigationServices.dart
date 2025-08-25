



import 'package:finance_app/confi/routes/routes.dart';

class NavigatorServices {
  static final NavigatorServices _instance = NavigatorServices._internal();

  NavigatorServices._internal();

  factory NavigatorServices() {
    return _instance;
  }

  static Future<dynamic> NavigationTo(String routename) async {
    return AppRoutes.router.push(routename);
  }

  static Future<dynamic> Navigatetowithparamters(
      String routename, Object arguments) async {
    return AppRoutes.router.pushNamed(routename, extra: arguments);
  }

  static void GoTo(String routeName) {
    AppRoutes.router.go(routeName);
  }

  static void GoToWithParameters(String routeName, Object arguments) {
    AppRoutes.router.goNamed(routeName, extra: arguments);
  }

  static void goBack() {
    return AppRoutes.router.pop();
  }
}

