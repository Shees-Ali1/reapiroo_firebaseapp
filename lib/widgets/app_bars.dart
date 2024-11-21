import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/svg_icons.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/my_svg.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.isMenu,
    required this.isNotification,
    required this.isTitle,
    this.title,
    required this.isSecondIcon,
    this.onBackTap,
    this.onMenuTap,
    this.isTextField = false,
    this.secondIcon,
    this.onSecondTap,
    this.onNotificationTap,
  });

  final bool isMenu;
  final bool isNotification;
  final bool isSecondIcon;
  final bool isTitle;
  final bool isTextField;
  final String? title;
  final String? secondIcon;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSecondTap;
  final VoidCallback? onNotificationTap;

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(130.h);
}

class _MyAppBarState extends State<MyAppBar> {
  bool _showGreenDot = false; // Tracks if a new notification exists

  @override
  void initState() {
    super.initState();

    // Firestore listener to detect new documents in "Bid Notifications" collection
    FirebaseFirestore.instance
        .collection('Bid Notifications')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.any((change) =>
      change.type == DocumentChangeType.added)) {
        setState(() {
          _showGreenDot = true; // Show green dot if a new document is added
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      padding: EdgeInsets.only(left: 13.w, right: 19.w, bottom: 10.h, top: 40.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.w),
          bottomRight: Radius.circular(15.w),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18), // Adjust opacity if needed
            offset: const Offset(0, 4), // (x = 0, y = 4)
            blurRadius: 10.4, // blur 10.4
            spreadRadius: 0, // spread 0
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu or Back Button
          InkWell(
            onTap: widget.isMenu == true
                ? widget.onMenuTap ?? () {}
                : widget.onBackTap ?? () {},
            child: MySvg(
              assetName: widget.isMenu
                  ? AppSvgs.menu
                  : AppSvgs.back_button,
              height: 38.h,
              width: 38.w,
            ),
          ),

          // Title or Search Field
          if (widget.isTitle == true || widget.isTextField == true)
            SizedBox(width: 12.w),
          if (widget.isTitle == true && widget.isTextField == false)
            Expanded(
              child: Text(
                widget.title ?? "",
                style: jost600(22.sp, AppColors.darkBlue),
              ),
            ),
          if (widget.isTextField == true && widget.isTitle == false)
            Container(
              width: 190.w,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              decoration: BoxDecoration(
                color: Colors.black, // Set the background color
                borderRadius: BorderRadius.circular(15.w), // Rounded edges
              ),
              child: Row(
                children: [
                  MySvg(
                    assetName: AppSvgs.search_icon,
                    height: 19.2.h,
                    width: 19.2.w,
                  ),
                  SizedBox(width: 10.w), // Space between the icon and the text field
                  Expanded(
                    child: TextField(
                      cursorColor: AppColors.secondary,
                      style: jost400(14.sp, AppColors.secondary),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 9.h),
                        hintText: "Search for anything",
                        hintStyle: jost400(14.sp, AppColors.secondary),
                        border: InputBorder.none, // Remove the underline border
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Spacer to push the icons to the end
          Spacer(),

          // Second Icon
          if (widget.isSecondIcon == true)
            GestureDetector(
              onTap: widget.onSecondTap,
              child: MySvg(
                assetName: widget.secondIcon ?? AppSvgs.menu,
                height: 38.h,
                width: 38.w,
              ),
            ),

          // Notification Icon with Green Dot
          if (widget.isNotification == true)
            GestureDetector(
              onTap: () {
                widget.onNotificationTap?.call();
                setState(() {
                  _showGreenDot = false; // Reset green dot on tap
                });
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: widget.isSecondIcon == true ? 7.w : 0),
                    height: 38.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14.w),
                    ),
                    alignment: Alignment.center,
                    child: MySvg(
                      assetName: AppSvgs.notification,
                      height: 23.h,
                      width: 23.w,
                    ),
                  ),
                  if (_showGreenDot)
                    Positioned(
                      top: -3.h,
                      right: -3.w,
                      child: Container(
                        height: 10.h,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.w),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
