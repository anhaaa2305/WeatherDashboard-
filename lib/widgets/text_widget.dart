import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  TextWidget({
    super.key,
    required this.text,
    required this.color,
    double? textSize,
    this.maxLines = 5,
    this.isTitle = false,
  }) : textSize = textSize ??
            (kIsWeb || !(Platform.isAndroid || Platform.isIOS) ? 16 : 12);
  final String text;
  final Color color;
  final double textSize;
  bool isTitle;
  int maxLines = 10;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: GoogleFonts.rubik(
          fontSize: isTitle ? 19 : textSize,
          color: color,
          fontWeight: isTitle ? FontWeight.w600 : FontWeight.w400),
    );
  }
}
