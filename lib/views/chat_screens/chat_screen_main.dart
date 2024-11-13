import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/views/chat_screens/chat_widget.dart';
import 'package:repairoo/views/notification_screen/notification_screen.dart';
import 'package:repairoo/widgets/app_bars.dart';

import '../../controllers/nav_bar_controller.dart';

class ChatsScreenMain extends StatelessWidget {
  const ChatsScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    final NavBarController navBarController = Get.find<NavBarController>();

    return Scaffold(
      appBar:  MyAppBar(
        onNotificationTap: () {
          Get.to(NotificationScreen());
        },
        onMenuTap: () {
          navBarController.openDrawer(context);
        },
        isMenu: true,
        isNotification: true,
        isTitle: true,
        isSecondIcon: false,
      ),
      backgroundColor: AppColors.secondary,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 21.0.h, horizontal: 10.0.w), // Reduced vertical padding
          child: Column(
            children: [
              /// Search Bar
            Container(
            width: double.infinity,
            height: 50.h, // Height of the search bar
            decoration: BoxDecoration(
              color: Colors.black, // Background color
              borderRadius: BorderRadius.circular(20.r), // Border radius
            ),
            child: TextField(
              style: TextStyle(color: AppColors.buttontext), // Text color inside the search field
              decoration: InputDecoration(
                hintText: 'Search...', // Placeholder text
                hintStyle: TextStyle(color: AppColors.buttontext,fontSize: 16.sp,fontWeight: FontWeight.w400,), // Color for hint text
                prefixIcon: Icon(
                  Icons.search, // Prefix icon
                  color: AppColors.buttontext, // Prefix icon color
                ),
                filled: true, // Enable fill color
                fillColor: Colors.black, // Set the fill color explicitly
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none, // Remove border side
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Vertical padding
              ),
            ),
          ),
              SizedBox(height: 27.h),
              /// Chat List
              Expanded(
                child: ChatList(), // Ensure ChatList is properly defined
              ),
            ],
          ),
        ),
      ),
    );
  }
}


