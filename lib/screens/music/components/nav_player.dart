import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/model/music.dart';
import 'package:moodymuch/size_config.dart';

class MusicBar extends StatefulWidget {
  final Music music;
  const MusicBar({
    Key key,
    this.music,
  }) : super(key: key);
  MusicBarState createState() => MusicBarState();
}

class MusicBarState extends State<MusicBar> {

  bool playing = false;
  AudioPlayer player = AudioPlayer();
  Duration position = Duration();
  Duration duration = Duration(seconds: 30);

  @override
  void didUpdateWidget(covariant MusicBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    player.stop();
    playing = false;
  }

  @override
  void initState() {
    super.initState();
    // duration = widget.music.duration;
    player.onDurationChanged.listen((updatedDuration) {
      setState(() {
        duration = updatedDuration;
      });
    });

    player.onAudioPositionChanged.listen((updatedPosition) {
        setState(() {
          position = updatedPosition;
        });
    });
  }

  @override
  void dispose(){
    player.stop();
    player.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return Container(
      height: 110,
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          Container(
            height: 90,
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
            padding: const EdgeInsets.only(left: 30, right: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: kShadowColor.withOpacity(0.5),
                  offset: Offset(0, 10),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: getProportionateScreenWidth(220),
                      height: 40,
                      child: slider(),
                    ),
                  ]
                ),
                Padding(
                  padding: EdgeInsets.only(right: getProportionateScreenWidth(50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RotatedBox(
                        quarterTurns: 2,
                        child: Icon(Icons.skip_next, size: 30, color: Colors.black.withOpacity(0.1)),
                      ),
                      SizedBox(width: 25),
                      IconButton(icon: !playing 
                                  ? Icon(Icons.play_arrow_rounded) 
                                  : Icon(Icons.pause_circle_outline), 
                        onPressed: getAudio,
                        iconSize: 30,
                        color: kPrimaryColor,
                      ),
                      SizedBox(width: 25),
                      Icon(Icons.skip_next, size: 30, color: Colors.black.withOpacity(0.1))
                    ],
                  ),
                ),
              ],
            )
          ),
          Positioned(
            left: 45,
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kShadowColor.withOpacity(0.5),
                    offset: Offset(0, 15),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(widget.music.imagePath)
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget slider() {
    return Slider.adaptive(
      min: 0.0,
      max: duration.inSeconds.toDouble(),
      value: position.inSeconds.toDouble(),
      activeColor: kPrimaryColor,
      inactiveColor: kPrimaryColor.withOpacity(0.5),
      onChanged: (double value) {
        player.seek(new Duration(seconds: value.toInt()));
      }
    );
  }

  void getAudio() async {
    if(playing){
      int res = await player.pause();
      if(res == 1){
        setState(() {
          playing = false;
        });
      }
    } else {
      int res = await player.play(widget.music.previewUrl, isLocal: false);
      if(res == 1){
        setState(() {
          playing = true;
        });
      }
    }
  }
}