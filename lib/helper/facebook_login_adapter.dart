import 'package:flutter/material.dart';

import 'social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:moodymuch/helper/database.dart';
import 'dart:convert';

class Facebook implements SocialLogin {
  final FacebookLogin facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future signUp() async {
    try {
      final result = await facebookLogin.logIn(['email']);
      if (result.status == FacebookLoginStatus.loggedIn) {
        final token = result.accessToken.token;
        final credential = FacebookAuthProvider.credential(token);
        User user = (await _auth.signInWithCredential(credential)).user;

        final response = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(480).height(480)&access_token=${token}');
        Map<String, dynamic> json = jsonDecode(response.body);
        String firstName = json["first_name"];
        String lastName = json["last_name"];
        String profilePictureUrl = json["picture"]["data"]["url"];
        DatabaseService(uid: user.uid)
            .updateUserData(firstName, lastName, "", "", profilePictureUrl);
        return user;
      }
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  @override
  Future signIn() async {
    try {
      final result = await facebookLogin.logIn(['email']);
      if (result.status == FacebookLoginStatus.loggedIn) {
        final token = result.accessToken.token;
        final credential = FacebookAuthProvider.credential(token);
        User user = (await _auth.signInWithCredential(credential)).user;
        return user;
      }
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  @override
  Future<void> logout() async {
    facebookLogin.logOut();
    return _auth.signOut();
  }

}
