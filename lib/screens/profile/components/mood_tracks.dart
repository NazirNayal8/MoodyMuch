import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class MoodTrackScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    AppUser user = Provider.of<AppUser>(context);
    DatabaseService db = DatabaseService(uid: user?.uid ?? "0");
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Mood Track History"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [StreamBuilder<UserModel>(
          stream: db.userData,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              UserModel data = snapshot.data;
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: data.moods.length,
                  itemBuilder: (context, i) => moodRecord(data.moods[i])
                ),
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
          }
        ),
        ]
      )
    );
  }

  Widget moodRecord(double mood) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      padding: EdgeInsets.all(10.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 8.0,
            percent: mood / 100,
            center: Text(
                mood.toInt().toString() + "%",
                style: TextStyle(
                  fontSize: 15,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                moodText(mood), 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorByPercentage(mood),
                ),
              ),
              Text(
                'Some Date', 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}