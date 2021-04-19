import 'package:flutter/material.dart';
import 'package:moodymuch/components/custom_bottom_nav_bar.dart';
import 'package:moodymuch/enums.dart';
import 'package:moodymuch/screens/youtube/youtube_video_list_screen.dart';

class MeditationScreen extends StatelessWidget {
  static String routeName = '/meditation';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meditation"), 
      ),
      body: YoutubeVideoListScreen(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.meditation),
    );
  }
}