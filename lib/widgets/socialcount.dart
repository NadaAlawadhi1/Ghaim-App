import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
import 'package:social_media/colors/colors.dart';

class SocialCount extends StatefulWidget {
  final List<String> imageList;
  final int followCount;
  final String followText;

  const SocialCount(
      {Key? key,
      required this.imageList,
      this.followCount = 0,
      required this.followText})
      : super(key: key);

  @override
  State<SocialCount> createState() => _SocialCountState();
}

class _SocialCountState extends State<SocialCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ImageStack(
            imageSource: ImageSource.Asset,
            imageList: widget.imageList,
            totalCount: widget.imageList.length,
            imageBorderWidth: 1,
            imageBorderColor: Colors.white,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                "${widget.followCount}",
                style: TextStyle(fontSize: 11),
              ),
              SizedBox(width: 5),
              Text(
                widget.followText,
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
