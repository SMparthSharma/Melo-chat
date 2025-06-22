import 'package:chat_app/core/theme/color.dart';
import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/common/custom_text_field.dart';
import 'package:chat_app/core/util/custom_snack_bar.dart';
import 'package:chat_app/logic/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/auth_cubit/auth_state.dart';
import 'package:chat_app/data/service/service_locator.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/presentation/auth/signup_page.dart';
import 'package:chat_app/presentation/home/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool isPasswordVisible = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address (e.g., example@email.com)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Password';
    }

    return null;
  }

  Future<void> loginHandler() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      try {
        getIt<AuthCubit>().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } catch (e) {
        throw e.toString();
      }
    } else {
      if (kDebugMode) {
        print('from validation failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          getIt<AppRouter>().pushAndRemoveUntil(const HomePage());
        } else if (state.status == AuthStatus.error && state.error != null) {
          CustomSnackBar.snackBar(context, state.error!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorPalette.primery,
          appBar: AppBar(),
          body: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                Center(
                  child: Image.asset(
                    'assets/image/melo_logo.png',
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Welcome back',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            keybordType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              color: Colors.grey,
                            ),
                            focusNode: _focusEmail,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            keybordType: TextInputType.text,
                            prefixIcon: Icon(
                              Icons.lock_open_rounded,
                              color: Colors.grey,
                            ),
                            obscure: !isPasswordVisible,
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
                            focusNode: _focusPassword,
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text('forgot password?  ')],
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            onPressed: loginHandler,
                            child: state.status == AuthStatus.loading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text('or'),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1.5,
                                  color: Colors.grey,
                                ),
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
                                    color: ColorPalette.primery,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      getIt<AppRouter>().push(SignupPage());
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
              ],
            ),
          ),
        );
      },
    );
  }
}
