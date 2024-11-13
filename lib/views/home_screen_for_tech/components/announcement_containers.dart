import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/my_svg.dart';

class AnnouncementContainers extends StatefulWidget {
  const AnnouncementContainers({super.key, required this.type});

  final String type;

  @override
  State<AnnouncementContainers> createState() => _AnnouncementContainersState();
}

class _AnnouncementContainersState extends State<AnnouncementContainers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.w),
      ),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Image.asset(
                        widget.type == "offer" ? AppImages.offer : AppImages.announcement,
                        height: widget.type == "offer" ? 15.h : 19.h,
                        width: widget.type == "offer" ? 15.w : 19.h,
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        widget.type == "offer" ? "New Offer" : "Announcement",
                        style: jost400(14.sp, AppColors.secondary),
                      )
                    ],
                  ),
                ),
                Text("16 Sep 2024", style: jost(8.sp, AppColors.secondary, FontWeight.w300),)
              ],
            ),
            SizedBox(height: 13.h,),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tincidunt sagittis sapien, id lobortis metus. Morbi luctus, sapien sed aliquam vestibulum, arcu nibh fermentum",
              style: jost(8.sp, AppColors.secondary, FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}
