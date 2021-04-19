import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodymuch/screens/home/home_screen.dart';
import 'package:moodymuch/screens/movie/movie_screen.dart';
import 'package:moodymuch/screens/music/music_screen.dart';
import 'package:moodymuch/screens/profile/profile_screen.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/enums.dart';
import 'package:moodymuch/screens/youtube/exercise_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/home.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : Colors.black,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/spotify.svg",
                  color: MenuState.music == selectedMenu
                      ? kPrimaryColor
                      : Colors.black
                ),
                onPressed: () => {
                  Navigator.pushNamed(context, MusicScreen.routeName),
                },
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/video.svg",
                  color: MenuState.movie == selectedMenu
                      ? kPrimaryColor
                      : Colors.black,
                ),
                onPressed: () => {
                  Navigator.pushNamed(context, MovieScreen.routeName),
                },
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/exercise.svg",
                color: MenuState.meditation == selectedMenu
                      ? kPrimaryColor
                      : Colors.black
                ),
                onPressed: () =>
                    Navigator.pushNamed(context,  MeditationScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/user.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : Colors.black,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
            ],
          )),
    );
  }
}
