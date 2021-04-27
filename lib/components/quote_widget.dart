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
            height: 30,
            width: 30,
            color: Colors.black,
          ),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          Container(
            width: SizeConfig.screenWidth - 60,
            alignment: Alignment.center,
            child: Text(
              quote,
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.black, fontSize: 30),
              ),
              maxLines: 4,
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(30),
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