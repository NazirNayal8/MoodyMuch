import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/UserModel.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<String> getUser() async {
    final user = _firebaseAuth.currentUser;
    if(user != null){
      return user.uid;
    }

    return "Not found";
  }

  Future<UserModel> getCurrentUser() async {

    String uid = await getUser();
    try {
      return await DatabaseService(uid: uid).getUserData();
    } catch(e) {
      print(e.message);
      return null;
    }
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Signed out";
    } on FirebaseAuthException catch(e) { 
      return e.message;
    } 
  }

  Future<String> signIn({String email, String password}) async {
    try {
      UserCredential res = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      String uid = res.user.uid;
      DatabaseService(uid: uid).updateUserData("", "", "", "", "");
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}