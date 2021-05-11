abstract class SocialLogin {
  Future signIn();

  Future signUp();

  Future<void> logout();

  Future<bool> isUserExist(String uid);
}
