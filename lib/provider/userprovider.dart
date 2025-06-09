import 'package:flutter/material.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/services/auth.dart';

class Userprovider with ChangeNotifier {
  UserModel? userModel;
  bool isLoad = true;
  getDetails() async {
    userModel = await AuthMethods().getUserDetails();
    isLoad = false; 
    notifyListeners();
  }
}
