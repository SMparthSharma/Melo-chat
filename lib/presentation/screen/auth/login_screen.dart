import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/common/custom_text_field.dart';
import 'package:chat_app/presentation/screen/auth/signUp_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginScreen());
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Form(
        child: Column(
          spacing: 20,
          children: [
            Center(
              child: Image.asset(
                'assets/image/icon.png',
                height: 120,
                width: 120,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Enter Email',
                      keybordType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_rounded,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      keybordType: TextInputType.text,
                      prefixIcon: Icons.lock_open_rounded,
                      obscure: true,
                      suffixIcon: Icons.visibility_rounded,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('forgot password?  ')],
                    ),
                    const SizedBox(height: 40),
                    CustomButton(onPressed: () {}, text: 'Sign in'),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1.5, color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or'),
                        ),
                        Expanded(
                          child: Divider(thickness: 1.5, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/image/google.png',
                          height: 50,
                          width: 50,
                        ),
                        Image.asset(
                          'assets/image/apple.png',
                          height: 50,
                          width: 50,
                        ),
                        Image.asset(
                          'assets/image/facebook.png',
                          height: 50,
                          width: 50,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Do not have an account?',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, SignupScreen.route());
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
