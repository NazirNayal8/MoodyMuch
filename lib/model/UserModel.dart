class AppUser {
  final String uid;
  AppUser({this.uid});
}

class UserModel {

  final String uid;
  final String firstname;
  final String lastname;
  final String phone;
  final String address;
  final String url;

  UserModel({ this.uid, this.firstname, this.lastname, this.phone, this.address, this.url });
}