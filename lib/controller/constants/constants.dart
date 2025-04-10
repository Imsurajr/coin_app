import 'package:flutter/material.dart';

const Color greyColor = Colors.grey;
const Color redColor = Colors.red;
const Color greenColor = Colors.green;
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color darkBlueColor = Color(0xff113F68);

late Size mediaQuery;
const String appName = 'Coin App';

const constantTextStyle =
    TextStyle(fontSize: 20, color: whiteColor, fontFamily: "MulishBold");

const buttonTextStyle =
    TextStyle(fontSize: 20, color: whiteColor, fontFamily: "MulishBold");

const productTextStyle = TextStyle(
    fontSize: 17.5, color: darkBlueColor, fontFamily: "MulishExtraBold");

TextStyle headingTextStyle(Size mq) {
  return TextStyle(
      fontSize: mq.height * 0.03,
      fontFamily: "MulishExtraBold",
      color: darkBlueColor);
}

TextStyle alertTextStyle(Size mq) {
  return TextStyle(
      fontSize: mq.height * 0.03,
      fontFamily: "MulishExtraBold",
      color: darkBlueColor);
}

TextStyle subtitleTextStyle(Size mq) {
  return TextStyle(
      fontSize: mq.height * 0.02,
      letterSpacing: 0.5,
      fontFamily: "MulishMedium",
      color: Colors.black54);
}
