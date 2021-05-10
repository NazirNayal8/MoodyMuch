import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class Twitter implements SocialLogin {
  final twitterLogin = TwitterLogin(
    consumerKey: 'Y90fsPI8VRYuTAscOzCayqQPK',
    consumerSecret: 'Jr1aEXagQONVzlVx6DfdYM2iS1qp71gK8P9nqLKGwCZHUHc3Pb',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future signUp() async {
    try {
      final TwitterLoginResult result = await twitterLogin.authorize();
      if (result.status == TwitterLoginStatus.loggedIn) {
        final token = result.session.token;
        final secret = result.session.secret;
        final credential =
            TwitterAuthProvider.credential(accessToken: token, secret: secret);
        User user = (await _auth.signInWithCredential(credential)).user;
        user.linkWithCredential(credential);

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

  @override
  Future signIn() async {
    try {
      final TwitterLoginResult result = await twitterLogin.authorize();
      if (result.status == TwitterLoginStatus.loggedIn) {
        final token = result.session.token;
        final secret = result.session.secret;
        final credential =
            TwitterAuthProvider.credential(accessToken: token, secret: secret);
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
    twitterLogin.logOut();
    return _auth.signOut();
  }

}
