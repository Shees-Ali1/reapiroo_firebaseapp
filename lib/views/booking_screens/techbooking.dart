import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../const/color.dart';
import '../../const/images.dart';
import '../../const/text_styles.dart';
import '../home_screen_for_tech/task_description_home.dart';

class BookingCardtech extends StatelessWidget {
  final String id; // Unique task ID
  final String title; // Unique task ID
  final String name;
  final String status;
  final String category;
  final String location;
  final String description;
  final String date;
  final String time;
  final String imagePath;

  const BookingCardtech({
    Key? key,
    required this.id,
    required this.title,
    required this.name,
    required this.status,
    required this.category,
    required this.location,
    required this.description,
    required this.date,
    required this.time,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("imagePath$imagePath");
    print("imagePathname$name");
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Top Row (Status & Category)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTag(status),
              _buildTag(category),
            ],
          ),
          // Content Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              children: [
                // Name, ID, Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and ID
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: jost600(18.sp, AppColors.secondary),
                              ),
                              Text(
                                "ID #$id",
                                style: jost600(12.sp, AppColors.secondary),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          // Location
                          Row(
                            children: [
                              Image.asset(
                                AppImages.pinlocation,
                                height: 12.h,
                                width: 8.w,
                              ),
                              SizedBox(width: 7.w),
                              Text(
                                location,
                                style: jost400(11.sp, AppColors.buttontext),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          // Description
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: jost400(12.sp, AppColors.secondary),
                          ),
                          SizedBox(height: 5.h),
                          // Price
                          // Container(
                          //   padding: EdgeInsets.all(7.w),
                          //   decoration: BoxDecoration(
                          //     color: AppColors.secondary,
                          //     borderRadius: BorderRadius.circular(10.r),
                          //   ),
                          //   child: Text(
                          //     "Price: $price",
                          //     style: jost400(12.sp, AppColors.primary),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // Image
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Image.network(
                        imagePath,
                        height: 82.h,
                        width: 70.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                // Date, Time, and View Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date & Time
                    _buildDateTimeContainer(date, time),
                    // View Button
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          TaskDescriptionHome(
                            comingFrom: "booking",
                            taskData: {
                              'randomId': id,
                              'title': title,
                              'userName': name,
                              'location': location,
                              'taskDescription': description,
                              'imageUrl': imagePath, // Add this
                              'selectedDateTime': '2023-11-19T10:30:00', // Ensure this field is included
                              'voiceNoteUrl': imagePath, // Add any other relevant field
                              'videoUrl': imagePath,
                            },
                          ),
                        );

                      },
                      child: Container(
                        height: 35.h,
                        width: 94.w,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            'View',
                            style: jost600(13.sp, AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Tags (e.g., Status and Category)
  Widget _buildTag(String text) {
    return Container(
      height: 21.h,
      width: 108.w,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(239, 239, 239, 1),
        borderRadius: BorderRadius.only(
          topLeft: text == status ? Radius.circular(10.5.r) : Radius.zero,
          topRight: text == category ? Radius.circular(10.5.r) : Radius.zero,
          bottomLeft: text == category ? Radius.circular(10.5.r) : Radius.zero,
          bottomRight: text == status ? Radius.circular(10.5.r) : Radius.zero,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: jost600(10.56.sp, AppColors.darkGrey),
        ),
      ),
    );
  }

  // Helper Widget for Date and Time Container
  Widget _buildDateTimeContainer(String date, String time) {
    return Container(
      height: 35.h,
      width: 185.w,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(AppImages.calendericon, height: 14.46.h, width: 14.46.w),
                SizedBox(width: 3.w),
                Text(date, style: jost600(10.85.sp, AppColors.darkGrey)),
              ],
            ),
            Row(
              children: [
                Image.asset(AppImages.clockicon, height: 14.46.h, width: 14.46.w),
                SizedBox(width: 3.w),
                Text(time, style: jost600(10.85.sp, AppColors.darkGrey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
