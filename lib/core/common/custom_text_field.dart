import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final TextInputType keybordType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keybordType,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keybordType,
      obscureText: obscure,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.grey,
      cursorErrorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
