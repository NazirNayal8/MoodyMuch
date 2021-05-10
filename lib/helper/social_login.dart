import 'package:firebase_auth/firebase_auth.dart';

abstract class SocialLogin {
  Future signIn();

  Future signUp();

  Future<void> logout();
}
