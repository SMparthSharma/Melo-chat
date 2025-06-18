import 'package:chat_app/core/theme/color.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  final Widget? child;
  const CustomButton({
    super.key,
    required this.onPressed,
    this.text,
    this.child,
  }) : assert(text != null || child != null, 'Either provied text or child');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () async {
                await onPressed?.call();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primery,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
        child:
            child ??
            Text(text!, style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}
