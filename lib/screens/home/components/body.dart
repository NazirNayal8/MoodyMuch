import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moodymuch/components/default_button.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    AppUser user = Provider.of<AppUser>(context);
    DatabaseService db = DatabaseService(uid: user?.uid ?? "0");
    var rng = new Random();

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Center(
            child: DefaultButton(
              text: "Generate Mood Record",
              press: () async {
                await db.recordMood(rng.nextDouble() * 100);
              },
            )
          )
        )
      )
    );
  }
}
