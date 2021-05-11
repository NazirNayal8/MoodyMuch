import 'package:flutter/material.dart';
import 'package:moodymuch/components/social_card.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/screens/home/home_screen.dart';
import 'package:moodymuch/size_config.dart';
import 'package:moodymuch/helper/authentication_service.dart';

import 'sign_up_form.dart';

class Body extends StatelessWidget {

  final AuthenticationService auth = AuthenticationService();

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
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Create Account", style: headingStyle),
                Text(
                  "Complete your details or continue \nwith social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () async {
                        auth.signUpWithGoogle().then((value) => {
                          if(value == null){
                            print("Invalid google credentials"),
                          } else {
                            Navigator.pushNamed(context, HomeScreen.routeName),
                          }
                        });
                      },
                    ),
                    SocialCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () async {
                        auth.signUpWithFacebook().then((value) => {
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
                      press: () async {
                        auth.signUpWithTwitter().then((value) => {
                          if(value == null){
                            print("Invalid twitter credentials"),
                          } else {
                            Navigator.pushNamed(context, HomeScreen.routeName),
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  'By continuing your confirm that you agree \nwith our Terms and Conditions',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
