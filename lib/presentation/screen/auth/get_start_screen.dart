import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/data/services/service_locator.dart';
import 'package:chat_app/presentation/screen/auth/login_screen.dart';
import 'package:chat_app/router/app_router.dart';
import 'package:flutter/material.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 50,
        children: [
          Center(child: Image.asset('assets/image/icon.png')),
          //  const SizedBox(height: 50),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: CustomButton(
              onPressed: () {
                getIt<AppRouter>().push(LoginScreen());
              },
              text: 'Get started',
            ),
          ),
        ],
      ),
    );
  }
}
