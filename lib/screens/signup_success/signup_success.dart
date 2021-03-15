import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpSuccessScreen extends StatelessWidget {
  static String routeName = "/signup_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Sign Up"),
      ),
      body: Body(),
    );
  }
}
