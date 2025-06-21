import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/data/repositories/chat_repository.dart';
import 'package:chat_app/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/auth_cubit/auth_state.dart';
import 'package:chat_app/logic/observer/app_lifecycle_observer.dart';
import 'package:chat_app/presentation/splash/splash_page.dart';
import 'package:chat_app/data/service/service_locator.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifeCycleObserver _lifeCycleObserver;

  @override
  void initState() {
    getIt<AuthCubit>().stream.listen((state) {
      if (state.status == AuthStatus.authenticated && state.user != null) {
        _lifeCycleObserver = AppLifeCycleObserver(
          userId: state.user!.uid,
          chatRepository: getIt<ChatRepository>(),
        );
        WidgetsBinding.instance.addObserver(_lifeCycleObserver);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<AppRouter>().navigatorKey,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}
