import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';
import 'social_login.dart';
import 'package:moodymuch/model/user.dart';

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
        String firstName = user.displayName;
        String profilePictureUrl = user.photoURL;

        DatabaseService db = DatabaseService(uid: user.uid);
        db.updateUserData(firstName, "", "", "", profilePictureUrl);
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
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        User user = (await _auth.signInWithCredential(credential)).user;
       /* DatabaseService db = DatabaseService(uid: user.uid);
        UserModel userModel = await db.userData.first;
        if(userModel.firstname != "") {
          return user;
        } */
        return user;
      }
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  @override
  Future<void> logout() async {
    googleSignIn.disconnect();
    googleSignIn.signOut();
    return _auth.signOut();
  }
}
