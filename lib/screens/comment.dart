import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/provider/userprovider.dart';
import 'package:social_media/services/cloud.dart';
import 'package:social_media/widgets/PawPrintBackground.dart';

class CommentScreen extends StatefulWidget {
  final postId;

  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentCon = TextEditingController();
  postComment(String uId, String profileImage, String displayName,
      String userName) async {
    String response = await CloudMethods().commentToPost(
        postId: widget.postId,
        uId: uId,
        comment: commentCon.text,
        profileImage: profileImage,
        displayName: displayName,
        userName: userName);
    if (response == "success") {
      setState(() {
        commentCon.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<Userprovider>(context).userModel!;
    CollectionReference posts = FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postId)
        .collection("comments");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: PawPrintBackground(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: posts.orderBy("date", descending: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.docs
                            .length, // Replace with the actual number of comments
                        itemBuilder: (context, index) {
                          dynamic data = snapshot.data.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data["profileImage"] == ""
                                      ? CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage(
                                              "assets/images/women.jpg"),
                                        )
                                      : CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              NetworkImage(data["profileImage"]),
                                        ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[
                                              "displayName"], 
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          data[
                                              "comment"], 
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
              //////
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: commentCon,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(4),
                            hintText: 'Write a comment...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: kWhiteColor,
                        shape: CircleBorder()),
                    onPressed: () {
                      postComment(userData.id, userData.profileImage,
                          userData.displayName, userData.userName);
                    },
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
