import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MoodDeleteDialog extends StatelessWidget {
  /// The dialog's title
  final String title;

  /// The dialog's message/description text
  final String message;

  /// Disables the cancel button and forces the user to leave a rating
  final bool force;

  final double mood;
  final String date;

  final String comments;

  /// The initial rating of the rating bar
  final int initialRating;

  /// The comment's TextField hint text
  final String commentHint;

  final String prev;

  /// The submit button's label/text
  final String submitButton;

  /// Returns a RatingDialogResponse with user's rating and comment values
  final Function(RatingDialogResponse) onSubmitted;

  /// called when user cancels/closes the dialog
  final Function onCancelled;

  const MoodDeleteDialog({
    @required this.title,
    @required this.mood,
    @required this.date,
    @required this.comments,
    @required this.message,
    @required this.submitButton,
    @required this.onSubmitted,
    @required this.prev,
    this.onCancelled,
    this.force = false,
    this.initialRating = 1,
    this.commentHint =
        'What were you doing when you recorded this mood? Anything specific that happened?',
  });

  @override
  Widget build(BuildContext context) {
    final _commentController =
        TextEditingController.fromValue(TextEditingValue(text: prev));
    final _response = RatingDialogResponse();

    final _content = Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 5),
                Text(
                  date,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  comments,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.red),
                ),
                const SizedBox(height: 10),
                SizedBox(height: getProportionateScreenHeight(10)),
                TextButton(
                  child: Text(
                    submitButton,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () {
                    if (!force) Navigator.pop(context);
                    _response.comment = _commentController.text;
                    onSubmitted.call(_response);
                  },
                ),
              ],
            ),
          ),
        ),
        if (!force) ...[
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              Navigator.pop(context);
              // onCancelled.call();
            },
          )
        ]
      ],
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: _content,
    );
  }
}

class RatingDialogResponse {
  /// The user's comment response
  String comment = '';

  /// The user's rating response
  int rating = 1;
}
