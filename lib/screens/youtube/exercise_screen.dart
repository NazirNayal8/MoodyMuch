import 'package:flutter/material.dart';
import 'package:moodymuch/components/custom_bottom_nav_bar.dart';
import 'package:moodymuch/enums.dart';
import 'package:moodymuch/screens/youtube/components/exercise_pick.dart';

class MeditationScreen extends StatelessWidget {
  static String routeName = '/exercises';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercises"), 
      ),
      body: ExercisePickScreen(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.meditation),
    );
  }
}
