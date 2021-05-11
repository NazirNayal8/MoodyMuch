import 'package:flutter/material.dart';
import 'package:moodymuch/size_config.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kTextLightColor = Color(0xFF9A9BB2);
const kFillStarColor = Color(0xFFFCC419);
const kShadowColor = Color.fromRGBO(242, 200, 213, 1);

const kDefaultPadding = 20.0;

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 4,
  color: Colors.black26,
);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kWeakPassError = "Password is too weak";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kLastNamelNullError = "Please Enter your last name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kWrongEmailorPass = "Wrong email or password";
const String kServerError = "Internal Server Error";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

bool validatePassword(String pass){
  String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(pass);
}

Color colorByPercentage(double percentage) {
  if(percentage <= 25){
    return Colors.red;
  } else if(percentage > 25 && percentage <= 50) {
    return Colors.orange[600];
  } else if(percentage > 50 && percentage <= 75) {
    return Colors.lightGreen;
  } else {
    return Colors.green;
  }
}

List<int> movieGenreByMood(double mood) {
  if(mood <= 10) {
    return [18,10751];
  } else if(mood > 10 && mood <= 20) {
    return [18];
  } else if(mood > 20 && mood <= 30) {
    return [36];
  } else if(mood > 30 && mood <= 40) {
    return [18,36];
  } else if(mood > 40 && mood <= 50) {
    return [37];
  } else if(mood > 50 && mood <= 60) {
    return [10402,10749];
  } else if(mood > 60 && mood <= 70) {
    return [28];
  } else if(mood > 70 && mood <= 80) {
    return [16,35];
  } else if(mood > 80 && mood <= 90) {
    return [80,53];
  } else {
    return [12,28];
  }
}

String songFileByMood(double mood) {
  if(mood >= 75.0) {
    return "veryhigh.json";
  } else if(mood < 75 && mood >= 50){
    return "high.json";
  } else if(mood < 50 && mood >= 25) {
    return "low.json";
  } else {
    return "verylow.json";
  }
}

String moodText(double mood)
{
  if(mood >= 75.0) {
    return "Very Positive!";
  } else if(mood < 75 && mood >= 50){
    return "Quite Positive!";
  } else if(mood < 50 && mood >= 25) {
    return "Quite Negative!";
  } else {
    return "Very Negative";
  }
}

