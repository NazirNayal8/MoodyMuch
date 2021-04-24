import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:moodymuch/constants.dart';

class LanguagesScreen extends StatefulWidget {
  static String routeName = "/languages";
  final int languageIndex;
  LanguagesScreen({Key key, @required this.languageIndex}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex;
  AppUser user;

  @override
  void initState() {
    super.initState();
    languageIndex = widget.languageIndex;
  }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<AppUser>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Languages')),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
            SettingsTile(
              title: "English",
              trailing: trailingWidget(0),
              iosChevron: null,
              onPressed: (BuildContext context) async {
                await changeLanguage(0);
                Navigator.pop(context, languageIndex);
              },
            ),
            SettingsTile(
              title: "Turkish",
              trailing: trailingWidget(1),
              iosChevron: null,
              onPressed: (BuildContext context) async {
                await changeLanguage(1);
                Navigator.pop(context, languageIndex);
              },
            ),
            SettingsTile(
              title: "Spanish",
              trailing: trailingWidget(2),
              iosChevron: null,
              onPressed: (BuildContext context) async {
                await changeLanguage(2);
                Navigator.pop(context, languageIndex);
              },
            ),
            SettingsTile(
              title: "German",
              trailing: trailingWidget(3),
              iosChevron: null,
              onPressed: (BuildContext context) async {
                await changeLanguage(3);
                Navigator.pop(context, languageIndex);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: kPrimaryColor)
        : Icon(null);
  }

  Future changeLanguage(int index) async{
    await DatabaseService(uid: user?.uid ?? '0').updateField('language', index);
    Fluttertoast.showToast(
      msg: "Updated Successfully",
      timeInSecForIosWeb: 3,
      backgroundColor: kPrimaryColor,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16,
    );
  }
}
