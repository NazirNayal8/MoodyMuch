import 'package:flutter/material.dart';
import 'package:moodymuch/bloc/get_casts.dart';
import 'package:moodymuch/model/cast.dart';
import 'package:moodymuch/model/cast_response.dart';
import 'package:moodymuch/size_config.dart';
import 'package:moodymuch/constants.dart';
import 'cast_card.dart';

class Casts extends StatefulWidget {
  final int id;
  Casts({Key key, @required this.id}) : super(key: key);
  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;
  _CastsState(this.id);

  @override
  void initState() {
    super.initState();
    castsBloc..getCasts(id);
  }

  @override
  void dispose() {
    super.dispose();
    castsBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CastResponse>(
      stream: castsBloc.subject.stream,
      builder: (context, AsyncSnapshot<CastResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return buildBody(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor:
                new AlwaysStoppedAnimation<Color>(kPrimaryColor),
              strokeWidth: 4.0,
            ),
          )
        ],
      )
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error occured: $error"),
        ],
      )
    );
  }

  Widget buildBody(CastResponse data) {
    List<Cast> casts = data.casts;
    if(casts.length == 0) {
      return Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Casts",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Column(
              children: <Widget>[
                Text(
                  "No cast provided",
                  style: TextStyle(color: Colors.black),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Casts",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: casts.length,
                itemBuilder: (context, index) => CastCard(cast: casts[index]),
              ),
            )
          ],
        ),
      );
    }
  }
}
