import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'movie_carousel.dart';

class Body extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    AppUser user = Provider.of<AppUser>(context);
    DatabaseService db = DatabaseService(uid: user?.uid ?? "0");

    return Container(
      child: StreamBuilder<UserModel>(
        stream: db.userData,
        builder: (context, snapshot) {
          if(!snapshot.hasError && snapshot.hasData) {
            double mood = snapshot.data.moods[snapshot.data.moods.length - 1];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Mood", style: headingStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 8.0,
                      percent: mood / 100,
                      center: Text(
                          mood.toInt().toString() + "%",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorByPercentage(mood),
                          ),
                        ),
                      circularStrokeCap: CircularStrokeCap.square,
                      backgroundColor: Colors.black12,                         
                      maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                      progressColor: colorByPercentage(mood)
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    Text(
                      moodText(mood), 
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorByPercentage(mood),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                Text("Movies", style: headingStyle),
                Text(
                  "Enjoy with our picks for you",
                  textAlign: TextAlign.center,
                ),
                MovieCarousel(genreIDs: movieGenreByMood(mood)),
                Spacer()
              ],
            );
          } else if(snapshot.hasError) {
            return Center(child: Text("An error occurred"));
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  kPrimaryColor,
                ),
              ),
            );
          }
        },
      )
    );
  }
}
