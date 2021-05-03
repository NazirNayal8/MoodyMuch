import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
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

  Future  signUpWithFacebook() async {
    try {
      final result = await facebookLogin.logIn(['email']);
      final token = result.accessToken.token;
      final response = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(480).height(480)&access_token=${token}');
      if (result.status == FacebookLoginStatus.loggedIn) {
        final credential = FacebookAuthProvider.credential(token);
        User user = (await _auth.signInWithCredential(credential)).user;
        Map<String, dynamic> json = jsonDecode(response.body);
        DatabaseService(uid: user.uid).updateUserData(json["first_name"], json["last_name"], "", "",  "");
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
      final token = result.accessToken.token;
      if (result.status == FacebookLoginStatus.loggedIn) {
        final credential = FacebookAuthProvider.credential(token);
        User user = (await _auth.signInWithCredential(credential)).user;
        return user;
      }
    } catch (e) {
      print(e.message);
      return null;
    }
  }
}
