import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moodymuch/components/custom_surfix_icon.dart';
import 'package:moodymuch/components/default_button.dart';
import 'package:moodymuch/components/form_error.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
import 'package:provider/provider.dart';

class UpdateNameScreen extends StatefulWidget {

  @override
  UpdateNameState createState() => UpdateNameState();
}

class UpdateNameState extends State<UpdateNameScreen> {

  final _formKey = GlobalKey<FormState>();
  String firstname = "";
  String lastname = "";

  AppUser user;
  DatabaseService db;
  bool loading = false;
  bool success = false;

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

  @override
  Widget build(BuildContext context) {

    user = Provider.of<AppUser>(context);
    db = DatabaseService(uid: user.uid ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Full Name"),
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
                  Text("Change Full Name", style: headingStyle),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    "Update your current first and last name",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    "You can update either first or last name, or both",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  nameForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                ]
              )
            )
          )
        )
      )
    );
  }

  Form nameForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Update",
            press: () async {
              _formKey.currentState.save();
              
              setState(() {
                  errors = [];
                  loading = true;
              });
                
              if(lastname != "" || firstname != ""){
                if(firstname != "") {
                  await db.updateField("firstname", firstname).then((value) => {
                    if(value != "Done"){
                      addError(error: kServerError),
                      setState(() {
                        success = false;
                      })
                    } else {
                      setState(() {
                        success = true;
                      })
                    }
                  });
                }

                if(lastname != "") {
                  await db.updateField("lastname", lastname).then((value) => {
                    if(value != "Done"){
                      addError(error: kServerError),
                      setState(() {
                        success = false;
                      })
                    } else {
                      setState(() {
                        success = true;
                      })
                    }
                  });
                }

                if(success){
                  setState(() {
                    loading = false;
                  });
                  Fluttertoast.showToast(
                    msg: "Updated Successfully!",
                    timeInSecForIosWeb: 2,
                    backgroundColor: kPrimaryColor,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT,
                    fontSize: 16,
                  );
                  Navigator.pop(context);
                }
              }
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

  TextFormField buildNameFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => firstname = newValue,
      onChanged: (value) {
        removeError(error: kServerError);
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }

        setState(() {
          success = false;
          firstname = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "New First Name",
        hintText: "Enter new first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/user.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => lastname = newValue,
      onChanged: (value) {
        removeError(error: kServerError);
        if (value.isNotEmpty) {
          removeError(error: kLastNamelNullError);
        }

        setState(() {
          success = false;
          lastname = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kLastNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "New Last Name",
        hintText: "Enter new last name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/user.svg"),
      ),
    );
  }
}