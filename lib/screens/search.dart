import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/screens/profile.dart';
import 'package:social_media/widgets/PawPrintBackground.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  TextEditingController searchCon = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchCon.addListener(() {
      searchUsers();
    });
  }

  void searchUsers() async {
    if (searchCon.text.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    QuerySnapshot querySnapshot = await users
        .where("userName", isGreaterThanOrEqualTo: searchCon.text)
        .where("userName", isLessThanOrEqualTo: searchCon.text + '\uf8ff')
        .get();

    setState(() {
      searchResults = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(Icons.pets,
              color:
                  kPrimaryColor.withOpacity(0.3)), 
        ),
        title: Text("Search Page"),
      ),
      body: PawPrintBackground(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              SearchBar(
                controller: searchCon,
                onChanged: (value) => setState(() {
                  searchCon.text = value;
                }),
                trailing: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                  )
                ],
                hintText: "Search by user name",
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) => kWhiteColor,
                ),
                elevation: WidgetStateProperty.resolveWith(
                  (states) => 0,
                ),
                shape: WidgetStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                      side: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    var item = searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uId: item["id"],
                              ),
                            ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: item["profileImage"] == ""
                              ? AssetImage("assets/images/women.jpg")
                              : NetworkImage(item["profileImage"]),
                        ),
                        title: Text(item['displayName']),
                        subtitle: Text("@" + item['userName']),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
