import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:moodymuch/components/default_button.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class UpdatePhoneScreen extends StatefulWidget {

  @override
  UpdatePhoneState createState() => UpdatePhoneState();
}

class UpdatePhoneState extends State<UpdatePhoneScreen> {

  bool loading = false;
  bool success = false;
  String phone;
  AppUser user;

  @override
  Widget build(BuildContext context) {

    user = Provider.of<AppUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Phone Number"),
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
                  Text("Change Phone Number", style: headingStyle),
                  Text(
                    "Update your mobile phone number",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: "TR",
                    onChanged: (value) {
                      setState(() {
                        phone = value.completeNumber;
                        success = false;
                      });
                    },
                    onCountryChanged: (value) {
                      setState(() {
                        phone = value.completeNumber;
                        success = false;
                      });
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  DefaultButton(
                    text: "Update",
                    press: () => {

                      setState(() {
                        loading = true;
                      }),

                      DatabaseService(uid: user.uid).updateField("phone", phone).then((value) => {
                        if(value != "Done"){
                          print(value)
                        } else {
                          setState(() {
                            success = true;
                          })
                        }
                      }),

                      setState(() {
                        loading = false;
                      })
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  waitUpdate(),
                  showSuccess()
                ]
              )
            )
          )
        )
      )
    );
  }

  Widget waitUpdate() {
    if(loading) {
      return SpinKitCircle(color: kPrimaryColor, size: 100);
    } else {
      return SizedBox(height: 0);
    }
  }

  Widget showSuccess() {
    if(success) {
      return Column(
        children: [
          Image.asset(
            "assets/images/success.png",
            height: SizeConfig.screenHeight * 0.1, 
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          Text(
            "Updated Successfully",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(12),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      );
      
    } else {
      return SizedBox(height: 0);
    }
  }
}