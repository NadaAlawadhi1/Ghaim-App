import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/widgets/PawPrintBackground.dart';
import 'package:social_media/widgets/postcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection("posts");
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ghaim",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: kPrimaryColor, 
                  fontFamily: "Montserrat", 
                ),
              ),
              Text(
                "For those who love paws and claws",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.pets,
                color: kPrimaryColor
                    .withOpacity(0.3)), // or use a heart or paw icon
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Your action
              },
              icon: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor, // The fill color
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(6), // Controls size of circle behind
                child: Icon(
                  LucideIcons.messagesSquare,
                  size: 24,
                  color: kWhiteColor, // Icon color contrasting with background
                ),
              ),
            ),
          ],
        ),
        body: PawPrintBackground(
          child: StreamBuilder(
              stream: posts.orderBy("date", descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("ERROR"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ));
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    dynamic data = snapshot.data!;

                    dynamic item = data.docs[index];

                    return PostCard(item: item);
                  },
                );
              }),
        ));
  }
}
