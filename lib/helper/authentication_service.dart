import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/UserModel.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  Stream<AppUser> get user {
    return this._auth.userChanges().map(_userFromFirebaseUser);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch(e) { 
      print(e.message);
      return null;
    } 
  }

  Future signIn({String email, String password}) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = res.user;
      return user;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future signUp({String email, String password}) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = res.user;
      DatabaseService(uid: user.uid).updateUserData("John", "Doe", "", "", "");
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }
}