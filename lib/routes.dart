import 'package:flutter/widgets.dart';
import 'package:moodymuch/screens/complete_profile/complete_profile_screen.dart';
import 'package:moodymuch/screens/forgot_password/forgot_password_screen.dart';
import 'package:moodymuch/screens/home/home_screen.dart';
import 'package:moodymuch/screens/movie/movie_screen.dart';
import 'package:moodymuch/screens/music/music_screen.dart';
import 'package:moodymuch/screens/profile/profile_screen.dart';
import 'package:moodymuch/screens/sign_in/sign_in_screen.dart';
import 'package:moodymuch/screens/signup_success/signup_success.dart';
import 'package:moodymuch/screens/youtube/youtube_video_list_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  SignUpSuccessScreen.routeName: (context) => SignUpSuccessScreen(),
  YoutubeVideoListScreen.routeName: (context) => YoutubeVideoListScreen(),
  MovieScreen.routeName: (context) => MovieScreen(),
  MusicScreen.routeName: (context) => MusicScreen()
};
