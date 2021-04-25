import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/model/music.dart';
import 'package:moodymuch/screens/music/components/nav_player.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';

class Body extends StatefulWidget {
  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {

  double mood = 77;
  Music selectedSong;
  String fileName = "assets/songs/veryhigh.json";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString(fileName),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final data = json.decode(snapshot.data.toString()).cast<String, dynamic>();
            List<Music> fullSongs = (data["tracks"] as List).map((e) => new Music.fromJson(e)).toList();
            fullSongs.shuffle();
            List<Music> songs = fullSongs.sublist(0, 10);
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
                    itemBuilder: (context, i) => musicCard(songs[i])
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  "You can tap on the photo to open the song on Spotify!",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                MusicBar(music: selectedSong)
              ],
            );
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
      ),
    );
  }

  Widget musicCard(Music item) {
    return ListTile(
      onTap: () => {
        setState(() {
          selectedSong = item;
        })
      },
      leading: Container(
        height: 60,
        width: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(item.imagePath, fit: BoxFit.fitHeight),
        ),   
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      subtitle: Text(item.artist),
      trailing: Text(
        '${item.duration.inMinutes}:${(item.duration.inSeconds % 60).toString().padLeft(2, '0')}'
      ),
    );
  }
}

// List<Music> songs = [
//   Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Call Me Maybe", "Carlee Lee Japsen", "https://i.scdn.co/image/2fb20bf4c1fb29b503bfc21516ff4b1a334b6372", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/335bede49342352cddd53cc83af582e2240303bb?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Call Me Maybe", "Carlee Lee Japsen", "https://i.scdn.co/image/2fb20bf4c1fb29b503bfc21516ff4b1a334b6372", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/335bede49342352cddd53cc83af582e2240303bb?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Call Me Maybe", "Carlee Lee Japsen", "https://i.scdn.co/image/2fb20bf4c1fb29b503bfc21516ff4b1a334b6372", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/335bede49342352cddd53cc83af582e2240303bb?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Call Me Maybe", "Carlee Lee Japsen", "https://i.scdn.co/image/2fb20bf4c1fb29b503bfc21516ff4b1a334b6372", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/335bede49342352cddd53cc83af582e2240303bb?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Call Me Maybe", "Carlee Lee Japsen", "https://i.scdn.co/image/2fb20bf4c1fb29b503bfc21516ff4b1a334b6372", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/335bede49342352cddd53cc83af582e2240303bb?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Cut to the Feeling", "Carlee Lee Japsen", "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86"),
//   Music("Call Me Maybe", "Carlee Lee Japsen", "https://i.scdn.co/image/2fb20bf4c1fb29b503bfc21516ff4b1a334b6372", Duration(minutes: 3, seconds: 32), "", "https://p.scdn.co/mp3-preview/335bede49342352cddd53cc83af582e2240303bb?cid=774b29d4f13844c495f206cafdad9c86"),
// ];
  
  