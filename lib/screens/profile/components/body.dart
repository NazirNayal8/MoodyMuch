import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moodymuch/components/rating_dialog.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/authentication_service.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/screens/profile/components/invite_friend.dart';
import 'package:moodymuch/screens/profile/components/mood_tracks.dart';
import 'package:moodymuch/screens/settings/settings.dart';
import 'package:moodymuch/screens/sign_in/sign_in_screen.dart';
import 'package:moodymuch/size_config.dart';
import 'package:provider/provider.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {

  final AuthenticationService auth = AuthenticationService();

  void _showRatingDialog(BuildContext context, String uid) {
    final _dialog = RatingDialog(
      title: 'Rate Us',
      message:
          'Tap a star to rate us. Add more feedback if you want.',
      image: const FlutterLogo(size: 70),
      submitButton: 'Submit',
      onSubmitted: (response) async {
        bool success = await DatabaseService(uid: uid).recordRating(response.rating, response.comment);

        String text = success ? "Thanks for Your Feedback!" : "Failed to Submit Rating";
        Color bgColor = success ? kPrimaryColor : Colors.red;
        Fluttertoast.showToast(
          msg: text,
          timeInSecForIosWeb: 2,
          backgroundColor: bgColor,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16,
        );
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _dialog,
    );
  }


  @override
  Widget build(BuildContext context) {

    AppUser user = Provider.of<AppUser>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: getProportionateScreenHeight(10)),
          ProfileMenu(
            text: "Mood Track History",
            icon: "assets/icons/analytics.svg",
            press: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MoodTrackScreen()))
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(language: 0)))
            },
          ),
          ProfileMenu(
            text: "Invite a Friend",
            icon: "assets/icons/user.svg",
            press: () => {
               Navigator.push(context, MaterialPageRoute(builder: (context) => InviteFriendScreen()))
            },
          ),
          ProfileMenu(
            text: "Rate Us",
            icon: "assets/icons/star.svg",
            press: () {
              _showRatingDialog(context, user?.uid);
            },
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
