import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:moodymuch/components/custom_bottom_nav_bar.dart';
import 'package:moodymuch/components/quote_widget.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/enums.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/quote_model.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
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

  Future<List<QuoteModel>> getPost() async {
    final response = await http.get('$apiURL');
    return postFromJson(response.body);
  }

  List<QuoteModel> postFromJson(String str) {
    List<dynamic> jsonData = json.decode(str);
    jsonData.shuffle();
    return jsonData.sublist(0, 50).map((e) => new QuoteModel.fromJson(e)).toList();
  }

  @override 
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
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
          if(!snapshot.hasError && snapshot.hasData) {
            if(!didQuotesLoaded){
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
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Welcome back\n${model.firstname}", style: headingStyle),
                      Spacer(),
                      CircleAvatar(
                        backgroundImage: model.url != null && model.url != "" ? NetworkImage(model.url): AssetImage("assets/images/user.png"),
                        backgroundColor: Colors.white,
                        radius: 50,
                      ),
                    ]
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                    ),
                    onPressed: () {
                      db.recordMood(rng.nextDouble() * 100).then((value) => {
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
                    },
                    icon: Icon(Icons.videocam, size: 25, color: Colors.white),
                    label: Text("RECORD MOOD", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SfCartesianChart(
                    borderWidth: 0,
                    plotAreaBorderWidth: 0,
                    title: ChartTitle(text: 'Mood Tracks'),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      LineSeries<MoodRecord, dynamic>(
                          name: 'Moods',
                          dataSource: recordsFromData(model.moods, model.dates),
                          xValueMapper: (MoodRecord record, _) => record.date,
                          yValueMapper: (MoodRecord record, _) => record.mood.toInt(),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true)
                    ],
                    primaryXAxis: CategoryAxis(
                      labelPlacement: LabelPlacement.onTicks,
                    ),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}%',
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Expanded(
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        return QuoteWidget(
                          quote: quotes[index].text,
                          author: quotes[index].author
                        );
                      }
                    )
                  ),
                ]
              )
            );
          } else if(snapshot.hasError){
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

  List<MoodRecord> recordsFromData(List<double> moods, List<String> dates){
    List<MoodRecord> records = [];
    for(int i = 0; i < moods.length; i++) {
      records.add(new MoodRecord(mood: moods[i], date: (i + 1).toString()));
    }
    return records;
  }
}

class MoodRecord {
  final double mood;
  final String date;

  MoodRecord({
    this.mood,
    this.date
  });
}