import 'package:flutter/material.dart';
import 'package:moodymuch/model/cast.dart';
import 'package:moodymuch/size_config.dart';

import '../../../constants.dart';

class CastCard extends StatelessWidget {
  final Cast cast;

  const CastCard({Key key, this.cast}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: kDefaultPadding),
      width: 75,
      child: Column(
        children: <Widget>[
          Container(
            height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  cast.img,
                ),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Text(
            cast.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
            maxLines: 2,
          ),
          //SizedBox(height: getProportionateScreenHeight(5)),
          Text(
            cast.character,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(color: kTextLightColor),
          ),
        ],
      ),
    );
  }
}
