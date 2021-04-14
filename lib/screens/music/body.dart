import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/model/music.dart';
import 'package:moodymuch/screens/music/music_item.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double mood = 77;
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
        Text("Songs", style: headingStyle),
        Text(
          "Enjoy with our picks for you",
          textAlign: TextAlign.center,
        ),
        // MovieCarousel(genreIDs: genreIDs, bannedIDs: bannedIDs),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(top: 20),
            itemCount: songs.length,
            itemBuilder: (_, i) => MusicItem(item: songs[i]),
          ),
        ),
        //Spacer()
      ],
    );
  }
}

List<Music> songs = [

  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
  Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", ""),
];
  
  