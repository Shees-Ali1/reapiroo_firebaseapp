import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/views/notification_screen/notification_screen.dart';

class ChatScreenDetail extends StatelessWidget {
  final String profileImage;
  final String name;

  const ChatScreenDetail({
    Key? key,
    required this.profileImage,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h), // Set your preferred height here
        child: AppBar(
          automaticallyImplyLeading:
              false, // Prevents the default back button or title
          flexibleSpace: Container(
            height: 120.h,
            decoration: BoxDecoration(
              color: AppColors.buttontext, // Custom color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.w),
                bottomRight: Radius.circular(15.w),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.18), // Adjust opacity if needed
                  offset: Offset(0, 4), // (x = 0, y = 4)
                  blurRadius: 10.4, // blur 10.4
                  spreadRadius: 0, // spread 0
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              'assets/images/back_icon.png', // Update this to your back icon path
                              height: 38.h,
                              width: 38.w,
                            ),
                          ),
                          SizedBox(width: 13.w),
                          Container(
                            height: 63.h,
                            width: 63.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                profileImage,
                                fit: BoxFit
                                    .cover, // Ensures the image fills the circle container
                              ),
                            ),
                          ),
                          SizedBox(width: 7.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: jost600(
                                  22.sp,
                                  AppColors.primary,
                                ),
                              ),
                              Text(
                                'Plumber', // Placeholder text, you can update it as needed
                                style: jost400(
                                  16.sp,
                                  AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(NotificationScreen());
                          },
                          child: Image.asset(
                              'assets/images/notification_icon.png',
                              height: 38.h,
                              width: 38.w)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          elevation: 0, // Remove AppBar shadow
          backgroundColor:
              Colors.transparent, // Makes the AppBar fully transparent
        ),
      ),
      backgroundColor: AppColors.secondary,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: Column(
          children: [
            // Add body content here if needed
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 25.h),
                children: [
                  _buildSupportMessage(
                      "Alright, \nYou can track your progress by accessing the 'My Courses' or 'My Progress' section in the app.\nIt will show you the courses you're enrolled in, your completion status, and any assessments or quizzes you've completed."),
                  _buildUserMessage("That's good to know.!"),
                  _buildUserMessage(
                      'Thank you so much for your help! I appreciate it.'),
                  _buildSupportMessage(
                      "You're very welcome!\nYou can track your progress by accessing the 'My Courses' or 'My Progress' section in the app."),
                  _buildSupportMessage("Happy studying"),
                ],
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportMessage(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Color.fromRGBO(0, 26, 46, 1),
          child: Image.asset(profileImage),
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary, // Support bubble color
              borderRadius: BorderRadius.circular(5.69.r),
            ),
            child: Text(
              message,
              style: jost400(
                13.27.sp,
                AppColors.buttontext,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 220.w, // Limit the message bubble width to 220
          ),
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.textFieldGrey, // User bubble color
              borderRadius: BorderRadius.circular(5.69.r),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13.27.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      height: 79.8.h,
      width: double.infinity.w,
      color: AppColors.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 23.4.w),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 56.63.h, // Height for the container
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type message...',
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                    filled: true,
                    fillColor: AppColors.secondary,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true, // Set isDense to true
                  ),
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(width: 11.52.w),
            Container(
              height: 38.4.h,
              width: 38.4.w,
              decoration: BoxDecoration(
                color: AppColors.secondary, // Send button color
                shape: BoxShape.circle,
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 23.04.h,
                    width: 23.04.w,
                    child: Image.asset('assets/images/send_icon.png',
                        fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
