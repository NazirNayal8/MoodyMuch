import 'package:flutter/material.dart';
import 'package:moodymuch/screens/movie_details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  final int id;
  final String backdrop;

  const DetailsScreen({Key key, this.id, this.backdrop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(id: id, backdrop: backdrop),
    );
  }
}
