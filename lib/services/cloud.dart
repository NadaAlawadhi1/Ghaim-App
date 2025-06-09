import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/services/storage.dart';
import 'package:uuid/uuid.dart';

class CloudMethods {
  CollectionReference posts = FirebaseFirestore.instance.collection("posts");
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  uploadPost({
    required String description,
    required String userId,
    required String userName,
    required String displayName,
    String? profileImage,
    required Uint8List file,
  }) async {
    String response = "ERROR";
    try {
      String postImage =
          await StorageMethods().uploadImageToStorage(file, "posts", true);
      String postId = Uuid().v1();
      PostModel postModel = PostModel(
          userId: userId,
          displayName: displayName,
          profileImage: profileImage ?? "",
          userName: userName,
          postId: postId,
          postImage: postImage,
          description: description,
          date: DateTime.now(),
          like: []);
      posts.doc(postId).set(postModel.tojson());

      response = "Success";
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  commentToPost(
      {required String postId,
      required String uId,
      required String comment,
      required String profileImage,
      required String displayName,
      required String userName}) async {
    String response = "Error";
    String commentId = Uuid().v1();
    try {
      if (comment.isNotEmpty) {
        posts.doc(postId).collection("comments").doc(commentId).set({
          "userId": uId,
          "postId": postId,
          "commentId": commentId,
          "comment": comment,
          "profileImage": profileImage,
          "displayName": displayName,
          "userName": userName,
          "date": DateTime.now(),
        });
        response = "success";
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  likePost(
    String postId,
    String uId,
    List? like,
  ) async {
    String response = "Error";

    if (like!.contains(uId)) {
      posts.doc(postId).update({
        "like": FieldValue.arrayRemove([uId])
      });
      response = "unliked";
    } else {
      posts.doc(postId).update({
        "like": FieldValue.arrayUnion([uId])
      });
      response = "liked";
    }
  }

  followUser(
    String uId,
    String followUserId,
  ) async {
    DocumentSnapshot documentSnapshot = await users.doc(uId).get();
    List following = (documentSnapshot.data()! as dynamic)["following"];

    try {
      if (following.contains(followUserId)) {
        await users.doc(uId).update({
          "following": FieldValue.arrayRemove([followUserId])
        });
        await users.doc(followUserId).update({
          "followers": FieldValue.arrayRemove([uId])
        });
      } else {
        users.doc(uId).update({
          "following": FieldValue.arrayUnion([followUserId])
        });
        users.doc(followUserId).update({
          "followers": FieldValue.arrayUnion([uId])
        });
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  editProfile({
    required String uId,
    required String displayName,
    required String userName,
    String bio = "",
    Uint8List? file,
    String profileImage = "",
  }) async {
    String response = "Error";

    try {
      profileImage = file != null
          ? await StorageMethods().uploadImageToStorage(file, "users", false)
          : "";
      if (displayName != "" && userName != "") {
        users.doc(uId).update({
          "displayName": displayName,
          "bio": bio,
          "profileImage": profileImage
        });
        response = "success";
      }
    } on Exception catch (e) {
      // TODO
    }
    return response;
  }

  deletePost(String postId) async {
    String response = "Error";
    try {
      await posts.doc(postId).delete();
      response = "success";
    } on Exception catch (e) {
      // TODO
    }
    return response;
  }

  Future<void> updateProfileInfoInPosts({
    required String userId,
    required String newProfileImage,
    required String newUserName,
    required String newDisplayName,
  }) async {
    final postsRef = FirebaseFirestore.instance.collection('posts');
    final querySnapshot =
        await postsRef.where('userId', isEqualTo: userId).get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        'profileImage': newProfileImage,
        'userName': newUserName,
        'displayName': newDisplayName,
      });
    }
  }
}
