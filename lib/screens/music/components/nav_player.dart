import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/model/music.dart';

class MusicBar extends StatelessWidget {
  final Music music;
  const MusicBar({
    Key key,
    this.music,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          Container(
            height: 70,
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
            padding: const EdgeInsets.only(right: 80), // width of cirlce
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RotatedBox(
                  quarterTurns: 2,
                  child: Icon(Icons.skip_next, size: 30, color: Colors.black.withOpacity(0.1)),
                ),
                SizedBox(width: 25),
                Icon(Icons.play_arrow, size: 40, color: kPrimaryColor),
                SizedBox(width: 25),
                Icon(Icons.skip_next, size: 30, color: Colors.black.withOpacity(0.1))
              ],
            ),
          ),
          Positioned(
            left: 60,
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
                backgroundImage: NetworkImage(music.imagePath)
              )
            ),
          ),
        ],
      ),
    );
  }
}