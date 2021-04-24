import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodymuch/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<String> updateUserData(String firstname, String lastname, String phone, String address, String url, List<double> moods) async {
    try {
      await userCollection.doc(uid).set({
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'address': address,
        'url': url,
        'moods': moods
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

  Future<bool> recordMood(double mood) async {
    try {
      await userCollection.doc(uid).update({'moods': FieldValue.arrayUnion([mood])});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
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
      url: userdata['url'] ?? '',
      moods: List.castFrom(userdata['moods'] ?? [])
    );
  }

  Stream<UserModel> get userData {
    return userCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }
}