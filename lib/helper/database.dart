import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodymuch/model/UserModel.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<String> updateUserData(String firstname, String lastname, String phone, String address, String url) async {
    try {
      await userCollection.doc(uid).set({
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'address': address,
        'url': url
      });
      return "saved";
    } catch (e) {
      return "Error while saving user data ${e.message}";
    }
  }

  Future<UserModel> getUserData() async {
    try {
      DocumentSnapshot ds = await userCollection.doc(uid).get();
      dynamic data = ds.data();
      return UserModel(
        firstname: data['firstname'] ?? '',
        lastname: data['lastname'] ?? '',
        phone: data['phone'] ?? '',
        address: data['address'] ?? '',
        url: data['url'] ?? ''
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final userdata = snapshot.data();
    return UserModel(
      uid: uid,
      firstname: userdata['firstname'] ?? '',
      lastname: userdata['lastname'] ?? '',
      phone: userdata['phone'] ?? '',
      address: userdata['address'] ?? '',
      url: userdata['url'] ?? ''
    );
  }

  Stream<UserModel> get userData {
    return userCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }
}