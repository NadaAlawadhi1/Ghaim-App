import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/provider/userprovider.dart';
import 'package:social_media/screens/auth/loginScreen.dart';
import 'package:social_media/services/cloud.dart';
import 'package:social_media/utils/picker.dart';
import 'package:social_media/widgets/PawPrintBackground.dart';
import 'package:social_media/widgets/textfield.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  Uint8List? file;

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<Userprovider>(context).userModel!;
    TextEditingController displayNameCon = TextEditingController();
    TextEditingController userNameCon = TextEditingController();
    TextEditingController bioCon = TextEditingController();
    // TextEditingController passwordCon = TextEditingController();
    displayNameCon.text = userData.displayName;
    userNameCon.text = userData.userName;
    bioCon.text = userData.bio;

    update() async {
      try {
        String response = await CloudMethods().editProfile(
          uId: userData.id,
          displayName: displayNameCon.text,
          userName: userNameCon.text,
          bio: bioCon.text,
          file: file,
        );

        // Fetch the latest user data from Firestore to get the new profileImage
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userData.id)
            .get();

        String newProfileImage = userDoc['profileImage'];
        String newUserName = userDoc['userName'];
        String newDisplayName = userDoc['displayName'];

        // Update all posts with the new info
        await CloudMethods().updateProfileInfoInPosts(
          userId: userData.id,
          newProfileImage: newProfileImage,
          newUserName: newUserName,
          newDisplayName: newDisplayName,
        );

        if (response == "success") {
          Navigator.pop(context);
        }
      } on Exception catch (e) {
        // TODO: handle error
      }
      Provider.of<Userprovider>(context, listen: false).getDetails();
    }

    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile details"),
      ),
      body: PawPrintBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Center(
                    child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: file == null && userData.profileImage == ""
                          ? AssetImage("assets/images/women.jpg")
                          : (file != null
                              ? MemoryImage(file!)
                              : NetworkImage(userData.profileImage)),
                    ),
                    Positioned(
                        child: CircleAvatar(
                      radius: 60,
                      backgroundColor: kWhiteColor.withOpacity(0.3),
                      child: IconButton(
                        onPressed: () async {
                          Uint8List _file = await pickImage();
                          setState(() {
                            file = _file;
                          });
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: kWhiteColor,
                          size: 40,
                        ),
                      ),
                    ))
                  ],
                )),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData.email,
                      style: TextStyle(color: kPrimaryColor),
                    )
                  ],
                ),
                Gap(10),
                CustomTextField(
                    controller: displayNameCon,
                    hintText: "Display Name",
                    prefixIcon: Icons.person_2_outlined 
                    ),
                Gap(10),
                CustomTextField(
                  controller: userNameCon,
                  hintText: "User Name",
                  prefixIcon: Icons.alternate_email_outlined,
                ),
                Gap(10),
                CustomTextField(
                  controller: bioCon,
                  hintText: "Bio",
                  prefixIcon: Icons.info_outlined,
                ),
                // Gap(10),
                // CustomTextField(
                //   controller: passwordCon,
                //   hintText: "Password",
                //   prefixIcon: Icons.lock,
                //   obscureText: true,
                // ),
                Gap(20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: kWhiteColor,
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          update();
                        },
                        child: Text("Update".toUpperCase()),
                      ),
                    ),
                  ],
                ),
        
                TextButton(
                    onPressed: () async {
                      await auth.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                    child: Column(
                      children: [
                        Gap(50),
                        Divider(),
                        Text(
                          "Logout".toUpperCase(),
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
