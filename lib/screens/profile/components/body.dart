import 'package:flutter/material.dart';
import 'package:moodymuch/helper/authentication_service.dart';
import 'package:moodymuch/screens/settings/settings.dart';
import 'package:moodymuch/screens/sign_in/sign_in_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {

  final AuthenticationService auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/user.svg",
            press: () => {
            },
          ),
          ProfileMenu(
            text: "Mood Track History",
            icon: "assets/icons/analytics.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () => {
              Navigator.pushNamed(context, SettingsScreen.routeName)
            },
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              await auth.signOut().then((value) => {
                Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (Route<dynamic> route) => false)
              });
            },
          ),
        ],
      ),
    );
  }
}
