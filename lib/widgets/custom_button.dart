import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final Color? color;
  final VoidCallback? onPress;
  final String? title;

  const CustomButton({
    super.key,
    this.width,
    this.color,
    this.title,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress!,
      child: Container(
        height: 56,
        width: width!,
        decoration: BoxDecoration(
          color: color!,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            title!,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
