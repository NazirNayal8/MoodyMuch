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

        //database check
        bool value = await isUserExist(user.uid);
        if (!value) {
          // print("User does not exist");
          final response = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(480).height(480)&access_token=$token');
          Map<String, dynamic> json = jsonDecode(response.body);
          String firstName = json["first_name"];
          String lastName = json["last_name"];
          String profilePictureUrl = json["picture"]["data"]["url"];
          DatabaseService db = DatabaseService(uid: user.uid);
          db.updateUserData(firstName, lastName, "", "", profilePictureUrl);
          return user;
        }
        logout();
        // print("User exists");
        return null;
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

        //database check
        bool value = await isUserExist(user.uid);
        if (value) {
          // print("User exists");
          return user;
        }
        // print("User does not exist");
        logout();
        return null;
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

  @override
  Future<bool> isUserExist(String uid) async {
    DatabaseService db = DatabaseService(uid: uid);
    return db.isExist();
  }
}
