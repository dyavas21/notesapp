import 'package:flutter/material.dart';

class TextInputContainer extends StatelessWidget {
  final double? sizeWidth;
  final String? hintText;
  final bool? isIconEmpty;
  final bool? obscureText;
  final void Function()? isPasswordShwon;
  final IconData? iconName;
  final TextEditingController? controller;

  const TextInputContainer({
    super.key,
    this.sizeWidth,
    this.hintText,
    this.isIconEmpty,
    this.iconName,
    this.controller,
    this.isPasswordShwon,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 56,
      width: sizeWidth!,
      decoration: BoxDecoration(
        color: Color(0xffF1F1F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: obscureText!,
              controller: controller!,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText!,
              ),
            ),
          ),
          if (isIconEmpty == false)
            GestureDetector(
              onTap: isPasswordShwon!,
              child: Icon(
                iconName!,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
