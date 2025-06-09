import 'package:flutter/material.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/widgets/PawPrintBackground.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  void _onActionTap() {
    print("Notification action tapped!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.pets,
                  color: kPrimaryColor
                      .withOpacity(0.3)), 
            ),
            title: const Text('Notifications')),
        body: PawPrintBackground(child: Container()));
  }
}
