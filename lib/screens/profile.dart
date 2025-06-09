import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/provider/userprovider.dart';
import 'package:social_media/screens/edituser.dart';
import 'package:social_media/services/cloud.dart';
import 'package:social_media/widgets/PawPrintBackground.dart';
import 'package:social_media/widgets/postcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  String? uId;
  ProfileScreen({super.key, this.uId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  String myId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    widget.uId = widget.uId ?? myId;
    Provider.of<Userprovider>(context, listen: false).getDetails();
    getUserData();
    _loadBackgroundIndex();
  }

  int backgroundIndex = 0; // 0 to 4 for 5 backgrounds
  final List<String> backgrounds = [
    "assets/images/background1.jpg",
    "assets/images/background2.jpg",
    "assets/images/background3.jpg",
    "assets/images/background4.jpg",
    "assets/images/background5.jpg",
    "assets/images/background6.jpg",
    "assets/images/background7.jpg",
    "assets/images/background8.jpg",
    "assets/images/background9.jpg",
    "assets/images/background10.jpg",
    "assets/images/background11.jpg",
    "assets/images/background12.jpg",
    "assets/images/background13.jpg",
    "assets/images/background14.jpg",
    "assets/images/background15.jpg",
    "assets/images/background16.jpg",
    "assets/images/background17.jpg",
    "assets/images/background18.jpg",
    "assets/images/background19.jpg",
    "assets/images/background20.jpg",
  ];

  bool isFollowing = true;
  bool isloading = true;
  int followerCount = 0;
  int followingCount = 0;
  var userInfo = {};
  getUserData() async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uId)
          .get();
      userInfo = userData.data()!;
      isFollowing = (userData.data()! as dynamic)["followers"].contains(myId);
      followerCount = userData.data()!["followers"].length;
      followingCount = userData.data()!["following"].length;
      if (!mounted) return; // <-- add this line

      setState(() {
        isloading = false;
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  void _setBackgroundIndex(int index) async {
    setState(() {
      backgroundIndex = index;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('profile_background_index', backgroundIndex);
  }

  void _loadBackgroundIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('profile_background_index') ?? 0;
    setState(() {
      backgroundIndex = savedIndex;
    });
  }

  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<Userprovider>(context).userModel!;
    CollectionReference posts = FirebaseFirestore.instance.collection("posts");

    FirebaseAuth auth = FirebaseAuth.instance;

    return isloading
        ? Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            )),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor:
                  Colors.transparent, 
              elevation: 0, 
              leading: Navigator.canPop(context)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  : null,
              actions: [
                if (userInfo['id'] == myId)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                  ),
              ],
            ),
            body: PawPrintBackground(
              child: Column(
                children: [
                  SizedBox(
                    height: 220, 
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                userInfo['id'] == myId
                                    ? backgrounds[backgroundIndex]
                                    : backgrounds[
                                        0], 
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Left arrow (show only if not at first background)
                        if (userInfo['id'] == myId && backgroundIndex > 0)
                          Positioned(
                            left: 8,
                            top: 130,
                            child: GestureDetector(
                              onTap: () {
                                if (backgroundIndex > 0)
                                  _setBackgroundIndex(backgroundIndex - 1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.chevron_left,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                          ),
                        // Right arrow (show only if not at last background)
                        if (userInfo['id'] == myId &&
                            backgroundIndex < backgrounds.length - 1)
                          Positioned(
                            right: 8,
                            top: 130,
                            child: GestureDetector(
                              onTap: () {
                                if (backgroundIndex < backgrounds.length - 1)
                                  _setBackgroundIndex(backgroundIndex + 1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.chevron_right,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                          ),

                        // Row with followers, profile image, following
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: -5,
                          child: SizedBox(
                            width: double.infinity,
                            child: Stack(
                              children: [
                                // Centered followers, profile image, following
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Followers
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            followerCount.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "Followers",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 16),
                                      // Profile image
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CircleAvatar(
                                          radius: 36,
                                          backgroundImage: userInfo[
                                                      "profileImage"] ==
                                                  ""
                                              ? AssetImage(
                                                  "assets/images/women.jpg")
                                              : NetworkImage(
                                                      userInfo["profileImage"])
                                                  as ImageProvider,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      // Following
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            followingCount.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "Following",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Name
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      userInfo["displayName"] ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Bio
                  if (userInfo["bio"] != "")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 5),
                      child: Opacity(
                        opacity: 0.7,
                        child: Text(
                          userInfo["bio"],
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  if (userInfo['id'] != myId)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: kPrimaryColor,
                                foregroundColor: kWhiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                try {
                                  CloudMethods()
                                      .followUser(myId, userInfo["id"]);
                                  setState(() {
                                    isFollowing
                                        ? followerCount--
                                        : followerCount++;
                                    isFollowing = !isFollowing;
                                  });
                                } catch (e) {}
                              },
                              child: Text(isFollowing ? "Unfollow" : "Follow"),
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: kBlackColor.withOpacity(0.7),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: kPrimaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                // Your message logic here
                              },
                              child: Text("Message"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTabIndex = 0;
                              _tabController.animateTo(0);
                            });
                          },
                          child: Text(
                            "Photos",
                            style: TextStyle(
                              color: selectedTabIndex == 0
                                  ? kBlackColor
                                  : kBlackColor.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTabIndex = 1;
                              _tabController.animateTo(1);
                            });
                          },
                          child: Text(
                            "Posts",
                            style: TextStyle(
                              color: selectedTabIndex == 1
                                  ? kBlackColor
                                  : kBlackColor.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Divider(),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Photos Tab
                        StreamBuilder(
                          stream: posts
                              .where("userId", isEqualTo: userInfo["id"])
                              // .orderBy("date", descending: true)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error loading photos"));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ));
                            }
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.photo_library_outlined,
                                      size: 56,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Nothing here yet.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ); // Display message if no photos
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GridView.builder(
                                padding:
                                    EdgeInsets.only(bottom: 30), // 🔥 Add this

                                itemCount: snapshot.data!.docs.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  dynamic item = snapshot.data!.docs[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(item["postImage"]),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8),
                                  );
                                },
                              ),
                            );
                          },
                        ),

                        // Posts Tab
                        StreamBuilder(
                          stream: posts
                              .where("userId", isEqualTo: userInfo["id"])
                              // .orderBy("date", descending: true)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text("Error loading posts"));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ));
                            }
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.notes,
                                      size: 56,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Nothing here yet.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ); // Display message if no photos
                            }
                            return ListView.builder(
                              padding:
                                  EdgeInsets.only(bottom: 100), // 🔥 Add this

                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                dynamic item = snapshot.data!.docs[index];
                                return PostCard(
                                    item: item); // Use your PostCard widget
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}
