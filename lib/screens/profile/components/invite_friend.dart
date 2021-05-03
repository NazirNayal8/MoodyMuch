import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:moodymuch/components/custom_surfix_icon.dart';
import 'package:moodymuch/components/default_button.dart';
import 'package:moodymuch/components/form_error.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
import 'package:moodymuch/utilities/keys.dart';
import 'package:provider/provider.dart';

class InviteFriendScreen extends StatefulWidget {

  @override
  InviteFriendScreenState createState() => InviteFriendScreenState();
}

class InviteFriendScreenState extends State<InviteFriendScreen> {

  final _formKey = GlobalKey<FormState>();
  String email = "";

  AppUser user;
  bool loading = false;

  List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<bool> mail(String recipient, String userEmail) async {

    // ignore: deprecated_member_use
    final smtpServer = gmail(our_email, our_password);
    // Create our message.
    final message = Message()
      ..from = Address(our_email, 'MoodyMuch Team')
      ..recipients.add(recipient)
      ..subject = 'You are Invited to Join MoodyMuch Journey!'
      ..text = 'Hi there!\n\nYour friend ' + userEmail + ' has invited you to start your MoodyMuch Journey'
                + '\nDownload our app and enjoy our personally specialized features!\n\n' +
                'Best.\nMoodyMuch Team';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<AppUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Invite a Friend"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                  Text("Invite a Friend", style: headingStyle),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    "invite your friend by entering an email address",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  buildForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                ]
              )
            )
          )
        )
      )
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Invite",
            press: () async {
              _formKey.currentState.save();
              
              setState(() {
                  errors = [];
                  loading = true;
              });

              bool success = await mail(email, user.email);
              String text = success ? "Invitation Sent!" : "Failed to Send Invitation";
              Color bgColor = success ? kPrimaryColor : Colors.red;

              setState(() {
                loading = false;
              });

              Fluttertoast.showToast(
                msg: text,
                timeInSecForIosWeb: 2,
                backgroundColor: bgColor,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT,
                fontSize: 16,
              );
              Navigator.pop(context);
            }
            
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          waitUpdate(),
        ],
      ),
    );
  }

  Widget waitUpdate() {
    if(loading) {
      return SpinKitCircle(color: kPrimaryColor, size: 100);
    } else {
      return SizedBox(height: 0);
    }
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        removeError(error: kServerError);
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
       if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Friend's Email",
        hintText: "Enter email address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}