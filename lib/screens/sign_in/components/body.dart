import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodymuch/components/no_account_text.dart';
import 'package:moodymuch/components/social_card.dart';
import 'package:moodymuch/screens/home/home_screen.dart';
import 'package:moodymuch/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';
import 'sign_form.dart';
import 'package:moodymuch/helper/authentication_service.dart';
import 'package:moodymuch/model/user.dart';

class Body extends StatelessWidget {
  AppUser user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () async {
                      },
                    ),
                    SocialCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () async {
                        final AuthenticationService auth = AuthenticationService();
                        auth.signInWithFacebook().then((value) => {
                          if(value == null){
                            print("Invalid facebook credentials"),
                          } else {
                            Navigator.pushNamed(context, HomeScreen.routeName),
                          }
                        });
                      },
                    ),
                    SocialCard(
                      icon: "assets/icons/twitter.svg",
                      press: ()  {},
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
