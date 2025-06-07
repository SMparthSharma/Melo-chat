import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/common/custom_text_field.dart';
import 'package:chat_app/presentation/screen/auth/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignupScreen());
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController rePasswoerdController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Sign up'), centerTitle: true),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Text(
                'Hello!',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: nameController,
                hintText: 'Name',
                keybordType: TextInputType.text,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                keybordType: TextInputType.text,
                prefixIcon: Icons.email_rounded,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                keybordType: TextInputType.text,
                prefixIcon: Icons.lock_open_rounded,
                suffixIcon: Icons.visibility_rounded,
                obscure: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: rePasswoerdController,
                hintText: 'Confirm Password',
                keybordType: TextInputType.text,
                prefixIcon: Icons.lock_open_rounded,
                suffixIcon: Icons.visibility_rounded,
                obscure: true,
              ),
              const SizedBox(height: 30),
              CustomButton(onPressed: () {}, text: 'Sign up'),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1.5, color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider(thickness: 1.5, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/google.png', height: 50, width: 50),
                  Image.asset('assets/image/apple.png', height: 50, width: 50),
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
                      text: ' Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context, LoginScreen.route());
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
