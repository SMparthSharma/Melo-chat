import 'package:flutter/cupertino.dart';

class AppRouter {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigatorKey.currentState!;

  void pop<T>([T? result]) {
    return _navigator.pop(result);
  }

  Future<T?> push<T>(Widget page) {
    return _navigator.push<T>(CupertinoPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return _navigator.pushReplacement<T, dynamic>(
      CupertinoPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return _navigator.pushAndRemoveUntil<T>(
      CupertinoPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return _navigator.pushNamed<T>(routeName, arguments: arguments);
  }
}
