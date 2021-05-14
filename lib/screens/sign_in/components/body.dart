import 'package:flutter/material.dart';
import 'package:moodymuch/components/form_error.dart';
import 'package:moodymuch/components/no_account_text.dart';
import 'package:moodymuch/components/social_card.dart';
import 'package:moodymuch/screens/home/home_screen.dart';
import '../../../size_config.dart';
import 'sign_form.dart';
import 'package:moodymuch/helper/authentication_service.dart';

class Body extends StatelessWidget {

  final AuthenticationService auth = AuthenticationService();
  String socialError = "";

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
                SizedBox(height: getProportionateScreenHeight(60)),
                SignForm(),
                SizedBox(height: getProportionateScreenHeight(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () async {
                        auth.signInWithGoogle().then((value) => {
                          if(value == null){
                            print("Invalid google credentials while logging in"),
                            socialError = "You need to register with your google account!",
                          } else {
                            Navigator.pushNamed(context, HomeScreen.routeName),
                          }
                        });
                      },
                    ),
                    SocialCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () async {
                        auth.signInWithFacebook().then((value) => {
                          if(value == null){
                            print("Invalid facebook credentials while logging in"),
                          } else {
                            Navigator.pushNamed(context, HomeScreen.routeName),
                          }
                        });
                      },
                    ),
                    SocialCard(
                      icon: "assets/icons/twitter.svg",
                      press: ()  async {
                        auth.signInWithTwitter().then((value) => {
                          if(value == null){
                            print("Invalid twitter credentials while logging in"),
                          } else {
                            Navigator.pushNamed(context, HomeScreen.routeName),
                          }
                        });
                      },
                    ),
                  ],
                ),
                Text(socialError),
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
