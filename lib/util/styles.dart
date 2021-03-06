import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle? kHeadingTextStyle = GoogleFonts.montserrat(
  color: AppColors.headingColor,
  fontWeight: FontWeight.w900,
  fontSize: 30.0,
  letterSpacing: -0.7,
);

final kButtonLightTextStyle = GoogleFonts.montserrat(
  color: AppColors.textColor,
  fontSize: 20.0,
  letterSpacing: -0.7,
);

final kButtonDarkTextStyle = GoogleFonts.montserrat(
  color: AppColors.darkButtonTextColor,
  fontSize: 20.0,
  letterSpacing: -0.7,
);

final kAppBarTitleTextStyle = GoogleFonts.montserrat(
  color: AppColors.appBarTitleTextColor,
  fontSize: 20.0,
);

final kBoldLabelStyle = GoogleFonts.montserrat(
  fontSize: 17.0,
  color: AppColors.textColor,
  fontWeight: FontWeight.w600,
);

final kLabelStyle = GoogleFonts.montserrat(
  fontSize: 14.0,
  color: AppColors.textColor,
);

final kAppViewTitleTextStyle = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.black
);




