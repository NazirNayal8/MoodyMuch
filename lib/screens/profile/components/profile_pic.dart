import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/helper/database.dart';
import 'package:moodymuch/model/user.dart';
import 'package:moodymuch/size_config.dart';
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

  @override
  Widget build(BuildContext context) {

    user = Provider.of<AppUser>(context);
    DatabaseService db = DatabaseService(uid: user?.uid ?? "0");

    return StreamBuilder<UserModel>(
      stream: db.userData,
      builder: (context, snapshot) {
        if(snapshot.hasData && !loading){
          return Column(
            children: [
               SizedBox(
                height: getProportionateScreenHeight(140),
                width: getProportionateScreenWidth(140),
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
                        height: getProportionateScreenHeight(45),
                        width: getProportionateScreenWidth(45),
                        // ignore: deprecated_member_use
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

                                db.updateField("url", value).then((value) => {
                                  if(value != "Done"){
                                    print(value)
                                  }
                                }),

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
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                snapshot.data.firstname + " " + snapshot.data.lastname,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                snapshot.data.address,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                snapshot.data.phone,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          );
        } else {
          return SizedBox(
            width: getProportionateScreenWidth(200),
            height: getProportionateScreenHeight(200),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: SpinKitCircle(
                    color: kPrimaryColor,
                    size: getProportionateScreenHeight(100),
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
