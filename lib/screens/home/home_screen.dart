import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:moodymuch/components/custom_bottom_nav_bar.dart';
import 'package:moodymuch/components/quote_widget.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/enums.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/quote_model.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/screens/profile/components/mood_tracks.dart';
import 'package:moodymuch/size_config.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String apiURL = "https://type.fit/api/quotes";
  bool didQuotesLoaded = false;
  List<QuoteModel> quotes;
  DatabaseService db;
  AppUser user;
  Random rng = new Random();
  TooltipBehavior _tooltipBehavior;
  final picker = ImagePicker(); //allows us to pick image from gallery or camera
  double prob;

  Future<List<QuoteModel>> getPost() async {
    final response = await http.get('$apiURL');
    return postFromJson(response.body);
  }

  List<QuoteModel> postFromJson(String str) {
    List<dynamic> jsonData = json.decode(str);
    jsonData.shuffle();
    return jsonData
        .sublist(0, 50)
        .map((e) => new QuoteModel.fromJson(e))
        .toList();
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Widget buildChart(List<MoodRecord> records) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SfCartesianChart(
          margin: EdgeInsets.all(0),
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          title: ChartTitle(
              text: 'Mood Tracks',
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            LineSeries<MoodRecord, dynamic>(
                name: 'Moods',
                color: Colors.green[400],
                dataSource: records,
                xValueMapper: (MoodRecord record, _) => record.date,
                yValueMapper: (MoodRecord record, _) => record.mood.toInt(),
                dataLabelSettings: DataLabelSettings(isVisible: false),
                dataLabelMapper: (MoodRecord record, _) => record.mood_comment,
                enableTooltip: true,
                animationDuration: 2000,
                markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: kPrimaryColor))
          ],
          primaryXAxis: CategoryAxis(
              labelPlacement: LabelPlacement.onTicks,
              labelStyle: TextStyle(fontWeight: FontWeight.bold)),
          primaryYAxis: NumericAxis(
              labelFormat: '{value}%',
              visibleMaximum: 100,
              maximum: 100,
              labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        ),
        records.length == 0
            ? Text("No Data Available",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
            : SizedBox(height: 0),
      ],
    );
  }

  Future<bool> classifyImage(File image) async {
    //this function runs the model on the image
    // List<int> imageBytes = image.readAsBytesSync();

    // ignore: deprecated_member_use
    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    //print(length);
    var uri = Uri.parse("https://moody-much-ml.herokuapp.com/predict");
    //print("connection established");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(image.path));
    // contentType: new MediaType(‘image’, ‘png’));
    // print("Sending Request ...");
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode != 200){
      return false;
    }
    await response.stream.transform(utf8.decoder).listen((value) {
      var jsonValue = jsonDecode(value);
      setState(() {
        prob = jsonValue["prob"];
      });
    });
    return true;
  }

  Future<bool> pickImage() async {
    //this function to grab the image from camera
    var image = await picker.getImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front, maxHeight: 480,
        maxWidth: 480,
        imageQuality: 25);
    if (image == null) return false;

    var _image = File(image.path);

    bool res = await classifyImage(_image);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    db = DatabaseService(uid: user?.uid ?? "0");

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: StreamBuilder<UserModel>(
        stream: db.userData,
        builder: (context, snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            if (!didQuotesLoaded) {
              getPost().then((value) => {
                    setState(() {
                      quotes = value;
                      didQuotesLoaded = true;
                    })
                  });
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    kPrimaryColor,
                  ),
                ),
              );
            }
            UserModel model = snapshot.data;
            return Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Welcome back\n" + model.firstname,
                                style: headingStyle),
                            Spacer(),
                            CircleAvatar(
                              backgroundImage:
                                  model.url != null && model.url != ""
                                      ? NetworkImage(model.url)
                                      : AssetImage("assets/images/user.png"),
                              backgroundColor: Colors.white,
                              radius: 50,
                            ),
                          ]),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: kPrimaryColor,
                                shadowColor: Colors.black,
                              ),
                              onPressed: () async {
                                bool success = await pickImage();
                                if (success){
                                  model.moods.add(prob*100);
                                  String date = DateTime.now().toString();
                                  date = date.substring(0, date.length - 7);
                                  model.dates.add(date);
                                  model.mood_comments.add('');

                                  db.recordMood(model.moods, model.dates, model.mood_comments).then((value) => {
                                    Fluttertoast.showToast(
                                      msg: "Submitted Successfully",
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: kPrimaryColor,
                                      textColor: Colors.white,
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT,
                                      fontSize: 16,
                                    ),
                                  });
                                }else{
                                  Fluttertoast.showToast(
                                    msg: "Something went wrong",
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_SHORT,
                                    fontSize: 16,
                                  );
                                }
                              },
                              icon: Icon(Icons.videocam,
                                  size: 25, color: Colors.white),
                              label: Text("RECORD MOOD",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: kPrimaryColor,
                                shadowColor: Colors.black,
                              ),
                              onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MoodTrackScreen()))
                              },
                              icon: Icon(Icons.analytics,
                                  size: 25, color: Colors.white),
                              label: Text("MOOD HISTORY",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            )
                          ]),
                      SizedBox(height: getProportionateScreenHeight(15)),
                      buildChart(recordsFromData(
                          model.moods, model.dates, model.mood_comments)),
                      SizedBox(height: getProportionateScreenHeight(15)),
                      Expanded(
                          child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: quotes.length,
                              itemBuilder: (context, index) {
                                return QuoteWidget(
                                    quote: quotes[index].text,
                                    author: quotes[index].author);
                              })),
                    ]));
          } else if (snapshot.hasError) {
            return Center(child: ErrorWidget(snapshot.error));
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  kPrimaryColor,
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  List<MoodRecord> recordsFromData(
      List<double> moods, List<String> dates, List<String> mood_comments) {
    List<MoodRecord> records = [];
    for (int i = 0; i < moods.length; i++) {
      records.add(new MoodRecord(
          mood: moods[i],
          date: (i + 1).toString(),
          mood_comment: mood_comments[i]));
    }
    return records;
  }
}

class MoodRecord {
  final double mood;
  final String date;
  final String mood_comment;

  MoodRecord({this.mood, this.date, this.mood_comment});
}
