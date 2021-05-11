import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodymuch/size_config.dart';

class QuoteWidget extends StatelessWidget {
  final String quote;
  final String author;

  QuoteWidget({this.quote, this.author});

  @override
  Widget build(BuildContext context) {

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/quote.png",
            height: 23,
            width: 23,
            color: Colors.black,
          ),
          SizedBox(
            height: getProportionateScreenHeight(5),
          ),
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Text(
              quote,
              maxLines: 5,
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(5),
          ),
          Text(
            author,
            style: GoogleFonts.lato(
              textStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
  }
}