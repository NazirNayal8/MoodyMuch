import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/music.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/screens/music/components/nav_player.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {

  Music selectedSong;
  String filePath = "assets/songs/";
  List<Music> songs;
  AppUser user;
  bool didSongsLoaded = false;

  @override
  Widget build(BuildContext context) {

    user = Provider.of<AppUser>(context);

    return Container(
      child: StreamBuilder<UserModel>(
        stream: DatabaseService(uid: user?.uid ?? "0").userData,
        builder: (context, snapshot) {
          if(!snapshot.hasError && snapshot.hasData) {

            if(snapshot.data.moods == null || snapshot.data.moods.length == 0) {
              return Center(
                child: Text(
                  "Sorry, you do not have any mood record yet.\nPlease, first record your mood to enjoy our picks for you!",
                  style: TextStyle(
                    color: kPrimaryColor.withOpacity(0.5),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            double mood = snapshot.data.moods[snapshot.data.moods.length - 1];

            if(!didSongsLoaded) {
              getJson(filePath + songFileByMood(mood)).then((value) => {
                didSongsLoaded = true
              });
              return Center(child: SizedBox(height: 0));
            }
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
                selectedSong != null ? Text(
                  "You can tap on the photo to open the song on Spotify!",
                  textAlign: TextAlign.center,
                ) : SizedBox(height: 0),
                SizedBox(height: getProportionateScreenHeight(10)),
                MusicBar(music: selectedSong)
              ],
            );
          } else if(snapshot.hasError) {
            return Center(child: Text("An error occurred" + snapshot.error.toString()));
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

  Future<void> getJson(String file) async {
    final snapshot = await DefaultAssetBundle.of(context).loadString(file);
    final data = json.decode(snapshot.toString()).cast<String, dynamic>();
    List<Music> fullSongs = (data["tracks"] as List).map((e) => new Music.fromJson(e)).toList();
    fullSongs.shuffle();
    setState(() {
      songs = fullSongs.sublist(0, 15);
    });
  }
}

  
  