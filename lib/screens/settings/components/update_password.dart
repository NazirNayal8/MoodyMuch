import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moodymuch/components/custom_surfix_icon.dart';
import 'package:moodymuch/components/default_button.dart';
import 'package:moodymuch/components/form_error.dart';
import 'package:moodymuch/helper/authentication_service.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class UpdatePasswordScreen extends StatefulWidget {

  @override
  UpdatePasswordState createState() => UpdatePasswordState();
}

class UpdatePasswordState extends State<UpdatePasswordScreen> {

  final AuthenticationService auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  String oldPass;
  String newPass;
  String confirmPass;
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
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
                  Text("Change Password", style: headingStyle),
                  Text(
                    "Update your current password",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  signUpForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                ]
              )
            )
          )
        )
      )
    );
  }

  Form signUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildOldPassField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPassFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Update",
            press: () async {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                setState(() {
                    errors = [];
                    loading = true;
                });
                bool check = await auth.validatePassword(oldPass);
                if(check) {
                  auth.updatePassword(newPass).then((value) => {
                    if(value) {
                      Navigator.pop(context)
                    } else {
                      addError(error: "Internal Server Error")
                    }
                  });
                } else {
                  addError(error: "Old password is not correct");
                }

                setState(() {
                  loading = false;
                });
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          waitUpdate()
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

  TextFormField buildOldPassField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => oldPass = newValue,
      onChanged: (value) {
        removeError(error: "Old password is not correct");
        removeError(error: "Internal Server Error");
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        setState(() {
          oldPass = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Old Password",
        hintText: "Enter old password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => newPass = newValue,
      onChanged: (value) {
        removeError(error: "Internal Server Error");
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        } else if (validatePassword(value)){
          removeError(error: kWeakPassError);
        }
        setState(() {
          newPass = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        } else if(!validatePassword(value)){
          addError(error: kWeakPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "New Password",
        hintText: "Enter new password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirmPass = newValue,
      onChanged: (value) {
        removeError(error: "Internal Server Error");
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && newPass == confirmPass) {
          removeError(error: kMatchPassError);
        }
        setState(() {
          confirmPass = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((newPass != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Confirm your new password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}