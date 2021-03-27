import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/UserModel.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePic extends StatefulWidget {
  @override
  ProfilePicState createState() => ProfilePicState();
}

class ProfilePicState extends State<ProfilePic> {

  File _imageFile;
  final picker = ImagePicker();

  AppUser user;
  String downloadUrl;
  bool loading = false;

  Future pickImage() async {
    final pickedFile = await picker.getImage(
                              source: ImageSource.gallery,
                              maxHeight: 480,
                              maxWidth: 480,
                              imageQuality: 25);                   

    setState(() {
      _imageFile = File(pickedFile.path);
      loading = true;
    });
  }

  // Future uploadImageToFirebase(BuildContext context) async {
  //   String fileName = basename( _imageFile.path);
  //   Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('uploads/$fileName');
  //   UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
  //   TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
  //   taskSnapshot.ref.getDownloadURL().then(
  //     (value) => {
  //       setState(() {
  //         downloadUrl = value;
  //       })
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<AppUser>(context);
    DatabaseService db = DatabaseService(uid: user?.uid ?? "0");

    return StreamBuilder<UserModel>(
      stream: db.userData,
      builder: (context, snapshot) {
        if(snapshot.hasData && !loading){
          return SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                  backgroundImage: snapshot.data.url != null && snapshot.data.url != "" ? NetworkImage(snapshot.data.url): AssetImage("assets/images/user.png"),
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
                      onPressed: () async {
                        await pickImage();
                        String fileName = basename( _imageFile.path);
                        Reference firebaseStorageRef =
                            FirebaseStorage.instance.ref().child('uploads/$fileName');
                        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
                        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
                        taskSnapshot.ref.getDownloadURL().then(
                          (value) => {
                            db.updateUserData(snapshot.data.firstname, snapshot.data.lastname, 
                              snapshot.data.phone, snapshot.data.address, value).then((value) => {
                                if(value != "Done"){
                                  print(value)
                                }
                              }
                            ),

                            setState(() {
                              loading = false;
                            })
                          },
                        );
                      },
                      child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: SpinKitChasingDots(
                    color: kPrimaryColor,
                    size: 100,
                  ),
                ),
              ],
            )
          );
        }
      }
    );
  }
}
