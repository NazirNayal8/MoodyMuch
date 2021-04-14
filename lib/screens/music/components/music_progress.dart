import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moodymuch/model/music.dart';

class MProgressIndicator extends StatefulWidget {
  final Music music;
  const MProgressIndicator({
    Key key,
    this.music,
  }) : super(key: key);

  @override
  _MProgressIndicatorState createState() => _MProgressIndicatorState(music: music);
}

class _MProgressIndicatorState extends State<MProgressIndicator> {

  Timer _timer;
  double _progress = 0; // current progress
  double _width = 0; // maximum width of progress bar
  int _elapsedSeconds;

  final Music music;
  _MProgressIndicatorState({this.music});

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = 0;

    Future.delayed(Duration.zero).then((value) {
      setState(() {
        _width = MediaQuery.of(context).size.width -
            30; // 30 - left and right padding
      });
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          _progress =
              1 + _elapsedSeconds * _width / music.duration.inSeconds;
          _elapsedSeconds++;
          print(_progress);
          print(_elapsedSeconds);
        });
      }
      if(_elapsedSeconds == music.duration.inSeconds) {
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        children: [
          Stack(
            children: [
              Container(
                height: 40,
                child: SvgPicture.asset(
                  'assets/icons/progress.svg',
                  color: Colors.black,
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  height: 40,
                  color: Colors.white.withOpacity(0.7),
                  width: _progress > _width ? 0 : _width - _progress,
                ),
              ),
            ],
          ),
          ElapsedDuration(
            elapsedSeconds: _elapsedSeconds,
            totalDuration: music.duration,
          ),
        ],
      ),
    );
  }
}

class ElapsedDuration extends StatelessWidget {
  final int elapsedSeconds;
  final Duration totalDuration;
  const ElapsedDuration({
    Key key, this.elapsedSeconds, this.totalDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${elapsedSeconds ~/ 60}:${(elapsedSeconds % 60).toString().padLeft(2, '0')}'),
        Text('${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}'),
      ],
    );
  }
}