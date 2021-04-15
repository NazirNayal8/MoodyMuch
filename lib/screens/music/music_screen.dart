import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodymuch/components/coustom_bottom_nav_bar.dart';
import 'package:moodymuch/enums.dart';
import 'package:moodymuch/screens/music/components/body.dart';

class MusicScreen extends StatelessWidget {
  static String routeName = '/musics';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Songs"), 
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.music),
    );
  }
}