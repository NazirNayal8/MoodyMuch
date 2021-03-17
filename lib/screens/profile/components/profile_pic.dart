import 'dart:io';
import 'package:moodymuch/helper/authentication_service.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/UserModel.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  @override
  ProfilePicState createState() => ProfilePicState();
}

class ProfilePicState extends State<ProfilePic> {

  File _imageFile;
  final picker = ImagePicker();

  String uid;
  UserModel user;
  DatabaseService db;

  Future pickImage(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });

    uploadImageToFirebase(context);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename( _imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
      (value) => {
        print("Done")
      },
    );
  }

  void initUserInfo(BuildContext context) {
    setState(() {
      context.read<AuthenticationService>().getUser().then((value) => uid = value);
      context.read<AuthenticationService>().getCurrentUser().then((value) => user = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    initUserInfo(context);

    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: _imageFile != null ? FileImage(_imageFile): AssetImage("assets/images/user.png"),
            backgroundColor: Colors.white,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 45,
              width: 45,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  pickImage(context);
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
