import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/data/service/service_locator.dart';
import 'package:chat_app/presentation/auth/login_page.dart';
import 'package:flutter/material.dart';

class GetStartPage extends StatelessWidget {
  const GetStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 50,
        children: [
          Center(child: Image.asset('assets/image/melo_logo.png')),
          //  const SizedBox(height: 50),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: CustomButton(
              onPressed: () {
                getIt<AppRouter>().push(LoginPage());
              },
              text: 'Get started',
            ),
          ),
        ],
      ),
    );
  }
}
