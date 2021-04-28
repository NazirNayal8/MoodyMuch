import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/screens/youtube/components/category_card.dart';
import 'package:moodymuch/screens/youtube/components/youtube_video_list_screen.dart';
import 'package:moodymuch/size_config.dart';

class ExercisePickScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[               
                Text("Exercises", style: headingStyle),
                Text(
                  "Pick one to strengthen your mental health",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: <Widget>[
                      CategoryCard(
                        title: "Pilates",
                        svgSrc: "assets/icons/pilates.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Pilates', playlistID: "PLIPPel3MuDjD-VKUzAQuABrx71VWMoNAf")));
                        },
                      ),
                      CategoryCard(
                        title: "Stretching",
                        svgSrc: "assets/icons/exercises.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Stretching', playlistID: "PLIGRWGt8y4NR4AJJeWD5sBkIsG-MExtQG")));
                        },
                      ),
                      CategoryCard(
                        title: "Focused Meditation",
                        svgSrc: "assets/icons/meditation.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Focused Meditation', playlistID: "PLcjgXQkHWH44d-sh-5JWjtWPCVpX5X-Si")));
                        },
                      ),
                      CategoryCard(
                        title: "Mindfullness Meditation",
                        svgSrc: "assets/icons/meditation.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Mindfullness Meditation', playlistID: "PLCQACBUblTbXAgZG7cxMYUddUlvTDO6v1")));        
                        },
                      ),
                      CategoryCard(
                        title: "Hatha Yoga",
                        svgSrc: "assets/icons/yoga.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Hatha Yoga', playlistID: "PLEs9dX8UXFZpezpFe_xfN6KCTImjTXf3u")));        
                        },
                      ),
                      CategoryCard(
                        title: "Yin Yoga",
                        svgSrc: "assets/icons/yoga.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Yin Yoga', playlistID: "PLW0v0k7UCVrnG4BpUD7bou96XFxnHMwQ3")));        
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}