import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_media/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/provider/userprovider.dart';
import 'package:social_media/screens/comment.dart';
import 'package:social_media/services/cloud.dart';

class PostCard extends StatefulWidget {
  final item;
  const PostCard({super.key, required this.item});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<Userprovider>(context).userModel!;

    return Padding(
      padding: EdgeInsets.all(6),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: kWhiteColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.item["profileImage"] == ""
                      ? AssetImage("assets/images/women.jpg")
                      : NetworkImage(widget.item["profileImage"]),
                ),
                Gap(7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item["displayName"],
                    ),
                    Text(
                      "@" + widget.item["userName"],
                    )
                  ],
                ),
                Spacer(),
                Text(
                  timeAgo(widget.item["date"].toDate()),
                  style: TextStyle(fontSize: 14), // Adjust the style as needed
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: widget.item["postImage"] == ""
                      ? Container()
                      : Container(
                          margin: EdgeInsets.all(12),
                          height: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.item["postImage"]),
                              )),
                        ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  widget.item['description'],
                  maxLines: 3,
                ))
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      CloudMethods().likePost(widget.item["postId"],
                          userData.id, widget.item["like"]);
                    },
                    icon: widget.item["like"].contains(userData.id)
                        ? Icon(
                            Icons.favorite_outline,
                            color: kPrimaryColor,
                          )
                        : Icon(Icons.favorite_outline)),
                Text(widget.item["like"].length.toString()),
                Gap(15),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          postId: widget.item["postId"],
                        ),
                      ),
                    );
                  },
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(-1.0, 1.0), // Flip horizontally
                    child: Icon(
                      LucideIcons.messageSquareDashed,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(widget.item["postId"])
                      .collection("comments")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("...");
                    }
                    // Update the comment count dynamically
                    int commentCount = snapshot.data?.docs.length ?? 0;
                    return Text(commentCount.toString());
                  },
                ),
                Spacer(),
                userData.id == widget.item["userId"]
                    ? IconButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: kSecondreyColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Row(
                                children: [
                                  // Icon(Icons.delete, color: Colors.red[400]),
                                  SizedBox(width: 8),
                                  Text("Delete!"),
                                ],
                              ),
                              content: Text(
                                "Are you sure you want to delete this post?",
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: kWhiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text("Delete"),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            CloudMethods().deletePost(widget.item["postId"]);
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                          color: kPrimaryColor,
                        ),
                      )
                    : SizedBox.shrink()
              ],
            )
          ],
        ),
      ),
    );
  }

  String timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago'; // Days
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago'; // Hours
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago'; // Minutes
    } else {
      return 'Just now'; // Seconds
    }
  }
}

//  import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:social_media/colors/colors.dart';
// import 'package:intl/intl.dart';
// import 'package:social_media/screens/comment.dart';

// class PostCard extends StatefulWidget {
//   final item;
//   const PostCard({super.key, required this.item});

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   int commentCount = 0;

//   getComment() async {
//     try {
//       QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
//           .collection("posts")
//           .doc(widget.item["postId"])
//           .collection("comments")
//           .get();
//       setState(() {
//         commentCount = commentSnapshot.docs.length;
//       });
//     } on Exception catch (e) {
//       // TODO
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getComment();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(6),
//       child: Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//             color: kWhiteColor, borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: widget.item["profileImage"] == ""
//                       ? AssetImage("assets/images/woman.png")
//                       : NetworkImage(widget.item["profileImage"]),
//                 ),
//                 Gap(7),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.item["displayName"],
//                     ),
//                     Text(
//                       "@" + widget.item["userName"],
//                     )
//                   ],
//                 ),
//                 Spacer(),
//                 Text(
//                   timeAgo(widget.item["date"].toDate()),
//                   style: TextStyle(fontSize: 14), // Adjust the style as needed
//                 )
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: widget.item["postImage"] == ""
//                       ? Container()
//                       : Container(
//                           margin: EdgeInsets.all(12),
//                           height: 250,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: NetworkImage(widget.item["postImage"]),
//                               )),
//                         ),
//                 )
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                     child: Text(
//                   widget.item['description'],
//                   maxLines: 3,
//                 ))
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                     onPressed: () {}, icon: Icon(Icons.favorite_outline)),
//                 Text(commentCount.toString()),
//                 Gap(15),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CommentScreen(
//                           postId: widget.item["postId"],
//                         ),
//                       ),
//                     );
//                   },
//                   icon: Icon(Icons.comment_outlined),
//                 ),
//                 Text(commentCount.toString()),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   String timeAgo(DateTime dateTime) {
//     final difference = DateTime.now().difference(dateTime);

//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago'; // Days
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago'; // Hours
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m ago'; // Minutes
//     } else {
//       return 'Just now'; // Seconds
//     }
//   }
// }
