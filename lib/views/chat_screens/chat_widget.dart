import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/views/chat_screens/chat_screen_detail.dart';

class ChatItem extends StatelessWidget {
  final String profileImage;
  final String name;
  final String message;
  final String timestamp;

  const ChatItem({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.message,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ChatScreenDetail and pass profile image and name
        Get.to(ChatScreenDetail(profileImage: profileImage, name: name));
      },
      child: Container(
        width: double.infinity,
        height: 61.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(ChatScreenDetail(profileImage: profileImage, name: name));
                  },
                  child: Container(
                    height: 61.h, // Set your desired height for the image
                    width: 61.w, // Set your desired width for the image
                    child: Image.asset(
                      profileImage, // Use the image asset path
                      fit: BoxFit.cover, // Maintain aspect ratio
                    ),
                  ),
                ),
                SizedBox(width: 7.5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: jost700(16.sp, AppColors.primary),
                    ),
                    Text(
                      message,
                      style: jost400(14.sp, AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                timestamp,
                style: jost400(
                  12.sp,
                  AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final List<Map<String, String>> chatData = [
    {
      'profileImage': AppImages.elijhaprofile,
      'name': 'Elijah',
      'message': "Hey There what's up? is everything a.",
      'timestamp': '04:43',
    },
    {
      'profileImage': AppImages.abdulprofile,
      'name': 'Abdul',
      'message': "Hey There what's up? is everything a.",
      'timestamp': '04:43',
    },
    {
      'profileImage': AppImages.joeprofile,
      'name': 'Joe',
      'message': "Hey There what's up? is everything a.",
      'timestamp': '04:43',
    },
    // Add more chat data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatData.length,
      itemBuilder: (context, index) {
        final chatItem = chatData[index];
        return Column(
          children: [
            /// Divider
            Container(
              height: 2.0.h, // Set the height of the divider
              width: 271.w, // Set the width to fill the parent
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 1), // First color (white)
                    Color.fromRGBO(0, 0, 0, 1),       // Second color (black)
                    Color.fromRGBO(255, 255, 255, 1), // Third color (white)
                  ],
                  stops: [0.0, 0.5, 1.0], // Control the gradient stop positions
                  begin: Alignment.centerLeft, // Start from the left
                  end: Alignment.centerRight,   // End at the right
                ),
              ),
            ), // Use the divider as needed
            SizedBox(height: 12.h),
            ChatItem(
              profileImage: chatItem['profileImage']!,
              name: chatItem['name']!,
              message: chatItem['message']!,
              timestamp: chatItem['timestamp']!,
            ),
            SizedBox(height: 12.5.h),
          ],
        );
      },
    );
  }
}
