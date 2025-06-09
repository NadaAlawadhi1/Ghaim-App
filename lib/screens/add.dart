import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/provider/userprovider.dart';
import 'package:social_media/services/cloud.dart';
import 'package:social_media/utils/picker.dart';
import 'package:social_media/widgets/PawPrintBackground.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Uint8List? file;
  TextEditingController descCon = TextEditingController();
  bool isLoading = false;

  upLoadPost() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserModel userData =
          Provider.of<Userprovider>(context, listen: false).userModel!;

      print('Profile image: ${userData.profileImage}');

      String response = await CloudMethods().uploadPost(
        description: descCon.text,
        userId: userData.id, 
        userName: userData.userName, 
        displayName:
            userData.displayName, 
        profileImage: userData.profileImage, 
        file: file!,
      );

      if (response == "Success") {
        setState(() {
          file = null; 
          descCon.clear(); 
        });
        // Success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Post uploaded successfully!"),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Error SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload post: $response"),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Exception SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<Userprovider>(context).userModel!;

    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: kWhiteColor,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.pets,
                color: kPrimaryColor
                    .withOpacity(0.3)),
          ),
          // title: Text(
          //   "Add post",
          //   // style: TextStyle(
          //   //   color: kBlackColor,
          //   //   fontWeight: FontWeight.bold,
          //   //   fontSize: 20,
          //   // ),
          // ),
          actions: [
            TextButton(
              onPressed: (file != null && descCon.text.trim().isNotEmpty)
                  ? () {
                      upLoadPost();
                    }
                  : null,
              child: Text(
                "Post",
                style: TextStyle(
                  color: (file != null && descCon.text.trim().isNotEmpty)
                      ? kPrimaryColor
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
        body: PawPrintBackground(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: (userData.profileImage != null &&
                              userData.profileImage.isNotEmpty)
                          ? NetworkImage(userData.profileImage)
                          : AssetImage("assets/images/women.jpg")
                              as ImageProvider,
                    ),
                    Gap(30),
                    Expanded(
                        child: TextField(
                      controller: descCon,
                      maxLines: 3,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Type here"),
                      onChanged: (value) {
                        setState(
                            () {});
                      },
                    )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10)),
                          onPressed: () async {
                            Uint8List myfile = await pickImage();
                            setState(() {
                              file = myfile;
                            });
                          },
                          child: Icon(Icons.image, color: kWhiteColor)),
                    )
                  ],
                ),
                Expanded(
                    child: file == null
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    image: MemoryImage(file!),
                                    fit: BoxFit.cover)),
                          )),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ));
  }
}
