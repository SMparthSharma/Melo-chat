import 'package:chat_app/config/theme/color.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/features/auth/presentation/screen/auth/login_screen.dart';
import 'package:chat_app/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/auth_cubit/auth_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          getIt<AppRouter>().pushAndRemoveUntil(LoginScreen());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Melo'),
            actions: [
              IconButton(
                onPressed: () async => await getIt<AuthCubit>().signOut(),
                icon: Icon(Icons.logout_rounded),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.chat_rounded, color: Colors.white),
          ),
          body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Image.asset('assets/image/google.png'),
                ),
                title: Text('parth'),
                subtitle: Text('new message'),
                trailing: Card(
                  shape: CircleBorder(),
                  color: ColorPalette.primery,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
