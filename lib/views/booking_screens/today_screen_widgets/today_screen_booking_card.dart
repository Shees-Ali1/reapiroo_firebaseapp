import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/views/home_screen_for_tech/task_description_home.dart';

import '../../home_screen_for_tech/components/description_widget.dart';

class BookingCard extends StatelessWidget {
  final String name;
  final String location;
  final String description;
  final String date;
  final String time;
  final String imagePath;
  final String price; // Added price
  final String taskId; // Added taskId
  final String title; // New parameter

  const BookingCard({
    super.key,
    required this.name,
    required this.location,
    required this.description,
    required this.date,
    required this.time,
    required this.imagePath,
    required this.price, // Added price
    required this.taskId, // Added taskId
    required this.title, // Added taskId
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // In Progress Container
              Container(
                height: 21.h,
                width: 108.w,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(239, 239, 239, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.5.r),
                    bottomRight: Radius.circular(10.5.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    'In Progress',
                    style: jost600(10.56.sp, AppColors.darkGrey),
                  ),
                ),
              ),
              // Plumbing Container
              Container(
                height: 21.h,
                width: 108.w,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(239, 239, 239, 1),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.5.r),
                    bottomLeft: Radius.circular(10.5.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    title, // Display dynamic title here
                    style: jost600(10.56.sp, AppColors.darkGrey),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: jost600(18.sp, AppColors.secondary),
                              ),
                              Text(
                                "ID #$taskId", // Display task ID here
                                style: jost600(12.sp, AppColors.secondary),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
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
                          DescriptionWidget(),
                          SizedBox(height: 5.h),
                          Container(
                            padding: EdgeInsets.all(7.w),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              'Price: $price AED', // Display price here
                              style: jost400(12.sp, AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Image.asset(
                        imagePath,
                        height: 82.h,
                        width: 70.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 35.h,
                      width: 195.w,
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
                                Image.asset(
                                  AppImages.calendericon,
                                  height: 14.46.h,
                                  width: 14.46.w,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  date,
                                  style: jost600(10.85.sp, AppColors.darkGrey),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  AppImages.clockicon,
                                  height: 14.46.h,
                                  width: 14.46.w,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  time,
                                  style: jost600(10.85.sp, AppColors.darkGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(TaskDescriptionHome(comingFrom: "booking"));
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
}
