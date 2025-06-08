import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/common/custom_text_field.dart';
import 'package:chat_app/data/services/service_locator.dart';
import 'package:chat_app/router/app_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  bool isPasswordVisible = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _passwordFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Name';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter phone number';
    }
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number (e.g., +1234567890)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter valid Email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address (e.g., example@email.com)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Sign up'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
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
                  controller: _nameController,
                  hintText: 'Name',
                  keybordType: TextInputType.text,
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  focusNode: _nameFocus,
                  validator: _validateName,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keybordType: TextInputType.text,
                  prefixIcon: Icon(Icons.email_rounded, color: Colors.grey),
                  focusNode: _emailFocus,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _phoneController,
                  hintText: 'phone number',
                  keybordType: TextInputType.text,
                  prefixIcon: Icon(Icons.phone, color: Colors.grey),

                  obscure: true,
                  focusNode: _phoneFocus,
                  validator: _validatePhone,
                ),

                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  keybordType: TextInputType.text,
                  prefixIcon: Icon(Icons.lock_open_rounded, color: Colors.grey),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  obscure: !isPasswordVisible,
                  focusNode: _passwordFocus,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState?.validate() ?? false) {}
                  },
                  text: 'Sign up',
                ),
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
                        text: ' Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            getIt<AppRouter>().pop(context);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
