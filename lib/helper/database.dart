import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodymuch/model/user.dart';

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
      return "Done";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateField(String field, String data) async {
    try {
      await userCollection.doc(uid).update(
        {field: data},
      );
      return "Done";
    } catch (e) {
      return e.toString();
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