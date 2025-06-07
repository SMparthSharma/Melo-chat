import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final TextInputType keybordType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
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
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        suffixIcon: Icon(suffixIcon, color: Colors.grey),
      ),
    );
  }
}
