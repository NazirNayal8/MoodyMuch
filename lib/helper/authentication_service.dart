import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:http/http.dart' as http;
import 'package:random_color/random_color.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookLogin = FacebookLogin();

  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid, email: user.email) : null;
  }

  Stream<AppUser> get user {
    return this._auth.userChanges().map(_userFromFirebaseUser);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future signIn({String email, String password}) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = res.user;
      return user;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future signUp({String email, String password}) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = res.user;
      DatabaseService(uid: user.uid).updateUserData("John", "Doe", "", "", "");
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = _auth.currentUser;

    var authCredentials = EmailAuthProvider.credential(
        email: firebaseUser.email, password: password);
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePassword(String password) async {
    try {
      await _auth.currentUser.updatePassword(password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future signUpWithFacebook() async {
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

  Future signInWithFacebook() async {
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

  Future signUpWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        consumerKey: 'Y90fsPI8VRYuTAscOzCayqQPK',
        consumerSecret: 'Jr1aEXagQONVzlVx6DfdYM2iS1qp71gK8P9nqLKGwCZHUHc3Pb',
      );
      final TwitterLoginResult result = await twitterLogin.authorize();
      if(result.status == TwitterLoginStatus.loggedIn) {
        final token = result.session.token;
        final secret = result.session.secret;
        final credential = TwitterAuthProvider.credential(accessToken: token, secret: secret);
        User user = (await _auth.signInWithCredential(credential)).user;

        String firstName = user.displayName;
        String profilePictureUrl = user.photoURL;
        DatabaseService(uid: user.uid)
            .updateUserData(firstName, "", "", "", profilePictureUrl);

        return user;
      }
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future signInWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        consumerKey: 'Y90fsPI8VRYuTAscOzCayqQPK',
        consumerSecret: 'Jr1aEXagQONVzlVx6DfdYM2iS1qp71gK8P9nqLKGwCZHUHc3Pb',
      );
      final TwitterLoginResult result = await twitterLogin.authorize();
      if(result.status == TwitterLoginStatus.loggedIn) {
        final token = result.session.token;
        final secret = result.session.secret;
        final credential = TwitterAuthProvider.credential(accessToken: token, secret: secret);
        User user = (await _auth.signInWithCredential(credential)).user;
        print(user.photoURL);
        return user;
      }
    } catch (e) {
      print(e.message);
      return null;
    }
  }

}
