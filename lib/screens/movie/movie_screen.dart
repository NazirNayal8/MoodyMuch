import 'package:flutter/material.dart';
import 'package:moodymuch/components/custom_bottom_nav_bar.dart';
import 'package:moodymuch/enums.dart';
import 'package:moodymuch/screens/movie/components/body.dart';

class MovieScreen extends StatelessWidget {
  static String routeName = '/movies';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"), 
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.movie),
    );
  }
}