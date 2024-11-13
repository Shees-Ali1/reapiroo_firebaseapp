import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/svg_icons.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/my_svg.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.isMenu,
    required this.isNotification,
    required this.isTitle,
    this.title,
    required this.isSecondIcon,
    this.onBackTap,
    this.onMenuTap,
    this.isTextField = false, this.secondIcon, this.onSecondTap, this.onNotificationTap,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: isMenu == true ? onMenuTap ?? (){} : onBackTap ?? (){},
            child: MySvg(
              assetName: isMenu ? AppSvgs.menu : AppSvgs.back_button,
              height: 38.h,
              width: 38.w,
            ),
          ),
          if (isTitle == true || isTextField == true)
            SizedBox(width: 12.w,),
          if (isTitle == true && isTextField == false)
            Expanded(
              child: Text(
                title ?? "",
                style: jost600(22.sp, AppColors.darkBlue),
              ),
            ),
          if(isTextField == true && isTitle == false)
            Expanded(
              child: Container(
                padding:  EdgeInsets.symmetric(horizontal: 13.w),
                decoration: BoxDecoration(
                  color: Colors.black, // Set the background color
                  borderRadius: BorderRadius.circular(15.w), // Rounded edges
                ),
                child: Row(
                  children: [
                    MySvg(assetName: AppSvgs.search_icon, height: 19.2.h, width: 19.2.w,),
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
            ),
          if(isTextField == true && isTitle == false)
            SizedBox(width: 12.w,),
          if(isTextField == false && isTitle == false)
            Expanded(child: SizedBox()),
          if(isSecondIcon == true )
            GestureDetector(
              onTap: onSecondTap,
              child: MySvg(
                assetName: secondIcon ?? AppSvgs.menu,
                height: 38.h,
                width: 38.w,
              ),
            ),
          if (isNotification == true)
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                margin: EdgeInsets.only(left: isSecondIcon == true ? 7.w : 0),
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
            ),

        ],
      ),
    );
  }

  // To set a fixed size for the AppBar
  @override
  Size get preferredSize => Size.fromHeight(130.h);
}


