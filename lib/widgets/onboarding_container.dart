import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingContainer extends StatelessWidget {
  String? imageUrl;
  String? desc;

  OnBoardingContainer({
    super.key,
    this.imageUrl,
    this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
              imageUrl!,
            ),
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            desc!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
