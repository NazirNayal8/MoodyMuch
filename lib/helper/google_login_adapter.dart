import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';
import 'social_login.dart';

class Google implements SocialLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future signUp() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final accessToken = googleSignInAuthentication.accessToken;
        final idToken = googleSignInAuthentication.idToken;
        final credential = GoogleAuthProvider.credential(
            idToken: idToken, accessToken: accessToken);
        User user = (await _auth.signInWithCredential(credential)).user;

        //database check
        bool value = await isUserExist(user.uid);
        if (!value) {
          print("User does not exist");
          String firstName = user.displayName;
          String profilePictureUrl = user.photoURL;
          DatabaseService db = DatabaseService(uid: user.uid);
          db.updateUserData(firstName, "", "", "", profilePictureUrl);
          return user;
        }
        logout();
        print("User exists");
        return null;
      }
    } catch (e) {
      logout();
      print(e.message);
      return null;
    }
  }

  @override
  Future signIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        User user = (await _auth.signInWithCredential(credential)).user;

        //database check
        bool value = await isUserExist(user.uid);
        if (value) {
          print("User exists");
          return user;
        }
        print("User does not exist");
        logout();
        return null;
      }
    } catch (e) {
      print(e.message);
      logout();
      return null;
    }
  }

  @override
  Future<void> logout() async {
    googleSignIn.disconnect();
    googleSignIn.signOut();
    return _auth.signOut();
  }

  @override
  Future<bool> isUserExist(String uid) async {
    DatabaseService db = DatabaseService(uid: uid);
    return db.isExist();
  }
}
