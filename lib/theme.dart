import 'package:flutter/material.dart';

class ThemeApp {
  heading1Theme() {
    return TextStyle(fontFamily: 'raleway', fontSize: 35);
  }

  heading2Theme() {
    return TextStyle(
        fontFamily: 'raleway', fontSize: 18, fontWeight: FontWeight.bold);
  }

  heading3Theme() {
    return TextStyle(
        fontFamily: 'raleway',
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold);
  }

  heading4Theme() {
    return TextStyle(
        fontFamily: 'raleway', fontWeight: FontWeight.w600, fontSize: 22);
  }

  heading5Theme() {
    return TextStyle(
        fontFamily: 'raleway', fontWeight: FontWeight.w600, fontSize: 15);
  }

  heading6Theme() {
    return TextStyle(
        fontFamily: 'raleway', fontWeight: FontWeight.bold, fontSize: 18);
  }

  textTheme() {
    return TextStyle(fontFamily: 'raleway', color: Colors.black);
  }

  textThemeGrey() {
    return TextStyle(
      fontFamily: 'raleway',
      color: Colors.black54,
    );
  }

  textWhiteTheme() {
    return TextStyle(
      fontFamily: 'raleway',
      color: Colors.white,
    );
  }

  appBarTheme() {
    return TextStyle(
        fontFamily: 'raleway',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black);
  }

  textBoldTheme() {
    return TextStyle(fontFamily: 'raleway', fontWeight: FontWeight.bold);
  }

  textSemiBoldTheme() {
    return TextStyle(
        fontFamily: 'raleway',
        fontWeight: FontWeight.w600,
        color: Colors.black);
  }

  textSemiBoldThemeSmall() {
    return TextStyle(
        fontSize: 15,
        fontFamily: 'raleway',
        fontWeight: FontWeight.w600,
        color: Colors.black);
  }

  textBoldWhiteTheme() {
    return TextStyle(
        fontFamily: 'raleway',
        fontWeight: FontWeight.bold,
        color: Colors.white);
  }

  textBoldLinkTheme() {
    return TextStyle(
        fontFamily: 'raleway', fontWeight: FontWeight.bold, color: Colors.blue);
  }

  imageStackTextTheme() {
    return TextStyle(
        fontFamily: 'raleway',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 15);
  }

  buttonTextTheme() {
    return TextStyle(fontFamily: 'raleway', color: Colors.white);
  }
}
