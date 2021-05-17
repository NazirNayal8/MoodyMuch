import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodymuch/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<String> updateUserData(String firstname, String lastname, String phone,
      String address, String url) async {
    try {
      await userCollection.doc(uid).set({
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'address': address,
        'url': url,
        'moods': [],
        'record_date': [],
        'mood_comment': [],
        'language': 0,
      });
      return "Done";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateField(String field, dynamic data) async {
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
      String date = DateTime.now().toString();
      date = date.substring(0, date.length - 7);
      String mood_comment = ' ';
      await userCollection.doc(uid).update({
        'moods': FieldValue.arrayUnion([mood]),
        "record_date": FieldValue.arrayUnion([date]),
        "mood_comments": FieldValue.arrayUnion([mood_comment])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> recordRating(int rating, String comment) async {
    try {
      await userCollection.doc(uid).update({'ratings': FieldValue.arrayUnion([rating]), "comments": FieldValue.arrayUnion([comment])});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> recordMoodComments(List<String> comments) async {
    try {
      await userCollection.doc(uid).update({"mood_comments": comments});
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
        moods: List.castFrom(userdata['moods'] ?? []),
        dates: List.castFrom(userdata["record_date"] ?? []),
        mood_comments: List.castFrom(userdata["mood_comments"] ?? []),
        language: userdata['language'] ?? 0);
  }

  Stream<UserModel> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<bool> isExist() async {
    DocumentReference documentReference = userCollection.doc(uid);
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      return true;
    }
    return false;
  }
}
