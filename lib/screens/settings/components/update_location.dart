import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moodymuch/components/default_button.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
import 'package:provider/provider.dart';

class LocationUpdate extends StatefulWidget {

  @override
  LocationUpdateState createState() => LocationUpdateState();
}

class LocationUpdateState extends State<LocationUpdate> {
  /// Variables to store country state city data in onChanged method.
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  bool loading = false;

  AppUser user;

  @override
  Widget build(BuildContext context) {

    user = Provider.of<AppUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Address"),
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
                  Text("Change Address", style: headingStyle),
                  Text(
                    "Update your current address",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  CSCPicker(
                    ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only)
                    flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                    layout: Layout.vertical,
                    ///triggers once country selected in dropdown
                    onCountryChanged: (value) {
                      setState(() {
                        ///store value in country variable
                        countryValue = value ?? "";
                      });
                    },

                    ///triggers once state selected in dropdown
                    onStateChanged: (value) {
                      setState(() {
                        ///store value in state variable
                        stateValue = value ?? "";
                      });
                    },

                    ///triggers once city selected in dropdown
                    onCityChanged: (value) {
                      setState(() {
                        ///store value in city variable
                        cityValue = value ?? "";
                      });
                    },
                  ),

                  SizedBox(height: getProportionateScreenHeight(20)),

                  DefaultButton(
                    text: "Update",
                    press: () => {

                      setState(() {
                        String temp = cityValue + ", " + stateValue + ", " + countryValue;
                        if(temp[0] == ','){
                          temp = temp.substring(2);
                        }
                        address = temp;
                        loading = true;
                      }),

                      DatabaseService(uid: user.uid).updateField("address", address).then((value) => {
                        if(value != "Done"){
                          print(value)
                        } else {
                          setState(() {
                            loading = false;
                          }),
                          Fluttertoast.showToast(
                            msg: "Updated Successfully",
                            timeInSecForIosWeb: 2,
                            backgroundColor: kPrimaryColor,
                            textColor: Colors.white,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_SHORT,
                            fontSize: 16,
                          ),
                          Navigator.pop(context)
                        }
                      }),
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  waitUpdate(),
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
}




    