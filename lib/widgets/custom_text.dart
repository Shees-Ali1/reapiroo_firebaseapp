
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LexendCustomText extends StatelessWidget {
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String text;
  final Color textColor;
  final double? fontsize;
  final FontWeight fontWeight;
  final double? height;
  final bool underline;
  final Color? decorationColor; // New property for decoration color
  final double? decorationThickness; // New property for decoration thickness

  const LexendCustomText(
      {super.key,
        required this.text,
        required this.textColor,
        this.fontsize,
        required this.fontWeight,
        this.height,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.underline = false,
        this.decorationColor, // Initialize new property
        this.decorationThickness}); // Initialize new property

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.lexend(
        textStyle: TextStyle(
          color: textColor,
          fontSize: fontsize,
          fontWeight: fontWeight,
          height: height,
          decoration:
          underline ? TextDecoration.underline : TextDecoration.none,
          decorationColor: underline
              ? decorationColor
              : null, // Conditional decoration color
          decorationThickness: underline
              ? decorationThickness
              : null, // Conditional decoration thickness
        ),
      ),
    );
  }
}

class WorkSansCustomText extends StatelessWidget {
  final TextOverflow? overflow;
  final String text;
  final Color textColor;
  final double? fontsize;
  final FontWeight fontWeight;
  final double? height;
  const WorkSansCustomText(
      {super.key,
        required this.text,
        required this.textColor,
        this.fontsize,
        required this.fontWeight,
        this.height, this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.workSans(
        textStyle: TextStyle(
            overflow: overflow,
            color: textColor,
            fontSize: fontsize,
            fontWeight: fontWeight,
            height: height),
      ),
    );
  }
}