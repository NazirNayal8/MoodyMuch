import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/screens/settings/components/update_location.dart';
import 'package:moodymuch/screens/settings/components/update_password.dart';
import 'package:moodymuch/screens/settings/components/update_phone.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:moodymuch/screens/settings/components/language.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = "/settings";
  final int language;
  SettingsScreen({Key key, @required this.language}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  bool useFingerprint = true;
  bool emailEnabled = true;

  int language;

  @override
  void initState() {
    super.initState();
    language = widget.language;
  }

  void awaitLanguagePick(BuildContext context) async {
    final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesScreen(languageIndex: language)));
    setState(() {
      language = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Common',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: indexToLanguage(),
              leading: Icon(Icons.language),
              onPressed: (context) {
                awaitLanguagePick(context);
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(title: 'Email', leading: Icon(Icons.email)),
            SettingsTile(
              title: 'Phone number', 
              leading: Icon(Icons.phone),
              onPressed: (context) => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePhoneScreen()))
              },
            ),
            SettingsTile(
              title: 'Location', 
              leading: Icon(Icons.location_city_sharp),
              onPressed: (context) => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LocationUpdate()))
              },
            ),
            SettingsTile(
              title: 'Change Password', 
              leading: Icon(Icons.exit_to_app),
              onPressed: (context) => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePasswordScreen()))
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Security',
          tiles: [
            SettingsTile.switchTile(
              title: 'Lock app in background',
              leading: Icon(Icons.phonelink_lock),
              switchValue: lockInBackground,
              switchActiveColor: kPrimaryColor,
              onToggle: (bool value) {
                setState(() {
                  lockInBackground = value;
                });
              },
            ),
            SettingsTile.switchTile(
              title: 'Use fingerprint',
              subtitle: 'Allow application to use fingerprint IDs.',
              leading: Icon(Icons.fingerprint),
              switchValue: useFingerprint,
              switchActiveColor: kPrimaryColor,
              onToggle: (bool value) {
                setState(() {
                  useFingerprint = value;
                });
              },
            ),
            SettingsTile.switchTile(
              title: 'Enable Email Notifications',
              leading: Icon(Icons.lock),
              switchValue: emailEnabled,
              switchActiveColor: kPrimaryColor,
              onToggle: (bool value) {
                setState(() {
                  emailEnabled = value;
                });
              },
            ),
            SettingsTile.switchTile(
              title: 'Enable Notifications',
              leading: Icon(Icons.notifications_active),
              switchValue: notificationsEnabled,
              switchActiveColor: kPrimaryColor,
              onToggle: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Misc',
          tiles: [
            SettingsTile(
              title: 'Terms of Service',
              leading: Icon(Icons.description)
            ),
            SettingsTile(
              title: 'Privacy Policy',
              leading: Icon(Icons.privacy_tip_outlined)
            ),
          ],
        ),
        CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22, bottom: 8),
                child: SvgPicture.asset(
                  'assets/icons/Settings.svg',
                  height: 40,
                  width: 40,
                  color: kPrimaryColor,
                ),
              ),
              Text(
                'Version: 1.0.0 (17)',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String indexToLanguage() {
    switch(language) { 
      case 0:
        return "English"; 
      case 1:
        return "Turkish";
      case 2:
        return "Spanish"; 
      case 3:
        return "German"; 
      default:
        return "English";
    }
  }
}
