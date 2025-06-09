import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/models/user.dart';

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot = await users.doc(currentUser.uid).get();
    return UserModel.fromSnap(documentSnapshot);
  }

  register({
    required String email,
    required String password,
    required String userName,
    required String displayName,
  }) async {
    String response = "ERROR";
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        userName.isNotEmpty &&
        displayName.isNotEmpty) {
      // Creating a user in Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create a UserModel instance
      UserModel userModel = UserModel(
        id: userCredential.user!.uid, // Get the UID of the newly created user
        displayName: displayName,
        email: email,
        profileImage: '', // Placeholder for image, adjust as needed
        password: password, // Storing passwords is not recommended
        userName: userName,
        bio: '', // Placeholder for bio, adjust as needed
        followers: [],
        following: [],
      );
      users.doc(userCredential.user!.uid).set(userModel.toJson());

      response = "Success"; // Registration successful
    } else {
      response = "Enter all fields"; // Inform user to fill all fields
    }
    return response; // Return the response
  }

  login({
    required String email,
    required String password,
  }) async {
    String response = "ERROR";
    if (email.isNotEmpty && password.isNotEmpty) {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      response = "Success";
    } else {
      response = "Enter all fields";
    }
    return response;
  }
}
