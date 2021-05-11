import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'social_login.dart';
import 'facebook_login_adapter.dart';
import 'twitter_login_adapter.dart';
import 'google_login_adapter.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static SocialLogin socialLogin;

  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid, email: user.email) : null;
  }

  Stream<AppUser> get user {
    return this._auth.userChanges().map(_userFromFirebaseUser);
  }

  Future signOut() async {
    try {
      if (socialLogin != null) {
        print("Social logout");
        return socialLogin.logout();
      }
      print("AppUser logout");
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print("Error logout");
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
    socialLogin = Facebook();
    return socialLogin.signUp();
  }

  Future signInWithFacebook() async {
    socialLogin = Facebook();
    return socialLogin.signIn();
  }

  Future signUpWithTwitter() async {
    socialLogin = Twitter();
    return socialLogin.signUp();
  }

  Future signInWithTwitter() async {
    socialLogin = Twitter();
    return socialLogin.signIn();
  }

  Future signUpWithGoogle() async {
    socialLogin = Google();
    return socialLogin.signUp();
  }

  Future signInWithGoogle() async {
    socialLogin = Google();
    return socialLogin.signIn();
  }
}
