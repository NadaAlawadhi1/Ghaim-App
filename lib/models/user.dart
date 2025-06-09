import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String displayName;
  String profileImage;

  String email;
  String password;
  String userName;
  String bio;
  List followers;
  List following;

  UserModel(
      {required this.id,
      required this.displayName,
      required this.profileImage,
      required this.email,
      required this.password,
      required this.userName,
      required this.bio,
      required this.followers,
      required this.following});

  factory UserModel.fromSnap(DocumentSnapshot snap) {
    //snapshot
    var data = snap.data() as Map<String, dynamic>;

    return UserModel(
      id: data['id'], 
      displayName: data['displayName'],
      profileImage: data['profileImage'],
      email: data['email'],
      password: data['password'],
      userName: data['userName'],
      bio: data['bio'],
      followers: data['followers'],
      following: data['following'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'profileImage': profileImage,
        'email': email,
        'password': password,
        'userName': userName,
        'bio': bio,
        'followers': followers,
        'following': following,
      };
}
