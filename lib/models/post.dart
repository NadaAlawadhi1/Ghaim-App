import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String userId;
  String displayName;
  String profileImage;
  String userName;
  String postId;
  String postImage;
  String description;
  DateTime date;
  dynamic like;

  PostModel({
    required this.userId,
    required this.displayName,
    required this.profileImage,
    required this.userName,
    required this.postId,
    required this.postImage,
    required this.description,
    required this.date,
    required this.like,
  });

  factory PostModel.fromDocument(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;

    return PostModel(
      userId: data['userId'],
      displayName: data['displayName'],
      profileImage: data['profileImage'],
      userName: data['userName'],
      postId: data['postId'],
      postImage: data['postImage'],
      description: data['description'],
      date: data['date'],
      like: data['like'],
    );
  }

  Map<String, dynamic> tojson() => {
        'userId': userId,
        'displayName': displayName,
        'profileImage': profileImage,
        'userName': userName,
        'postId': postId,
        'postImage': postImage,
        'description': description,
        'date': Timestamp.fromDate(date),
        'like': like,
      };
}
