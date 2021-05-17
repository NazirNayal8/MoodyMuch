import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moodymuch/components/mood_comment_dialog.dart';
import 'package:moodymuch/components/mood_delete_dialog.dart';
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
            children: [
              StreamBuilder<UserModel>(
                  stream: db.userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel data = snapshot.data;
                      if (data.moods.length == 0 || data.dates.length == 0) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              kPrimaryColor,
                            ),
                          ),
                        );
                      }

                      List<double> revMoods = data.moods.reversed.toList();
                      List<String> revDates = data.dates.reversed.toList();
                      List<String> revComments =
                          data.mood_comments.reversed.toList();
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(top: 20),
                          itemCount: revMoods.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () => _showCommentDialog(
                                    context,
                                    user.uid,
                                    index,
                                    revMoods,
                                    revDates,
                                    revComments),
                                onLongPress: () => _showDeleteDialog(
                                    context,
                                    user.uid,
                                    index,
                                    revMoods,
                                    revDates,
                                    revComments),
                                child: moodRecord(revMoods[index],
                                    revDates[index], revComments[index]));
                          },
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
                  }),
            ]));
  }

  Widget moodRecord(double mood, String date, String comment) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  progressColor: colorByPercentage(mood)),
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
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(width: getProportionateScreenWidth(10))
            ],
          ),
        ));
  }
}

Dialog _showCommentDialog(BuildContext context, String uid, int index,
    List<double> revMoods, List<String> revDates, List<String> revComments) {
  final _dialog = MoodCommentDialog(
    prev: revComments[index],
    mood: revMoods[index],
    date: revDates[index],
    title: 'Comment for record:',
    message: 'Add comments to this mood record.',
    submitButton: 'Save',
    onSubmitted: (response) async {
      revComments[index] = response.comment;
      revComments = revComments.reversed.toList();
      bool success =
          await DatabaseService(uid: uid).recordMoodComments(revComments);

      String text = success ? "Mood Comment Saved!" : "Failed to Save Comment";
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

Dialog _showDeleteDialog(BuildContext context, String uid, int index,
    List<double> revMoods, List<String> revDates, List<String> revComments) {
  final _dialog = MoodDeleteDialog(
    prev: revComments[index],
    mood: revMoods[index],
    date: revDates[index],
    comments: revComments[index],
    title: 'Are you sure you want to delete this record?',
    message: 'Mood record will be deleted permanently!',
    submitButton: 'Delete',
    onSubmitted: (response) async {
      revMoods.removeAt(index);
      revMoods = revMoods.reversed.toList();
      revDates.removeAt(index);
      revDates = revDates.reversed.toList();
      revComments.removeAt(index);
      revComments = revComments.reversed.toList();
      bool successM = await DatabaseService(uid: uid).updateField('moods', revMoods) == 'Done' ? true : false;

      bool successD = await DatabaseService(uid: uid).updateField('record_date', revDates) == 'Done' ? true : false;

      bool successC = await DatabaseService(uid: uid).updateField('mood_comments', revComments) == 'Done' ? true : false;

      bool success = successM && successD && successC;
      String text = success ? "Mood Deleted!" : "Failed to Delete Comment";
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
