class AppUser {
  final String uid;
  final String email;
  AppUser({this.uid, this.email});
}

class UserModel {

  final String uid;
  final String firstname;
  final String lastname;
  final String phone;
  final String address;
  final String url;
  final List<double> moods;
  final List<String> dates;
  final int language;

  UserModel({this.uid, this.firstname, this.lastname, this.phone, this.address, this.url, this.moods, this.dates, this.language});
}