import 'package:flutter/material.dart';
import 'package:moodymuch/components/mood_comment_dialog.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
              if(data.moods.length == 0 || data.dates.length == 0) {
                return  Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      kPrimaryColor,
                    ),
                  ),
                );
              }

              List<double> revMoods = data.moods.reversed.toList();
              List<String> revDates = data.dates.reversed.toList();
              List<String> revComments = data.mood_comments.reversed.toList();
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: revMoods.length,
                  itemBuilder: (context, i) => moodRecord(revMoods[i], revDates[i], revComments[i])
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

  Widget moodRecord(double mood, String date, String comment) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: getProportionateScreenWidth(10)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                moodText(mood), 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorByPercentage(mood),
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                date, 
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                comment,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }
}

void _showCommentDialog(BuildContext context, String uid) {
  final _dialog = MoodCommentDialog(
    title: 'Mood Record Comments',
    message:
    'Tap a star to rate us. Add more feedback if you want.',
    submitButton: 'Submit',
    onSubmitted: (response) async {
      bool success = await DatabaseService(uid: uid).recordRating(response.rating, response.comment);

      String text = success ? "Mood Comments Saved!" : "Failed to Save Comments";
      Color bgColor = success ? kPrimaryColor : Colors.red;
      Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        backgroundColor: bgColor,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16,
      );
    },
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => _dialog,
  );
}