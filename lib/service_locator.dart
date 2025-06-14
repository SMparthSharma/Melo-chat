import 'package:chat_app/features/auth/data/repositories/auth_repository.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerLazySingleton(
    () => AuthCubit(authRepository: AuthRepository()),
  );
}
