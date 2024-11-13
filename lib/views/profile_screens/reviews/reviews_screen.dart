import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String selectedRating = "5 stars"; // Default selection for dropdown

  // Mockup reviews data for each rating
  final Map<String, List<Map<String, String>>> reviewsData = {
    "5 stars": [
      {
        "name": "Ryosuke Tanaka",
        "date": "August 5, 2023",
        "comment": "Natalie offers an impressive array of features and resources, making it a truly awesome tool for learning, fantastic choice for anyone looking to enhance their learning journey.",
      },
      {
        "name": "John Doe",
        "date": "July 12, 2023",
        "comment": "Amazing platform with great learning tools!",
      },
    ],
    "4 stars": [
      {
        "name": "Jane Smith",
        "date": "June 18, 2023",
        "comment": "Very good but could use more variety in resources.",
      },
    ],
    "3 stars": [
      {
        "name": "Alex Johnson",
        "date": "May 3, 2023",
        "comment": "Decent platform but I faced some technical issues.",
      },
    ],
    "2 stars": [
      {
        "name": "Lily Brown",
        "date": "April 20, 2023",
        "comment": "Not as expected. Needs improvement.",
      },
    ],
    "1 star": [
      {
        "name": "Samuel Green",
        "date": "March 11, 2023",
        "comment": "Poor experience. Wouldn't recommend.",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Close the keyboard when tapping outside
      },
      child: Scaffold(
        appBar: MyAppBar(
          isMenu: false,
          isNotification: false,
          isTitle: true,
          title: 'Reviews',
          isSecondIcon: false,
          onBackTap: () {
            Get.back();
          },
        ),
        backgroundColor: AppColors.secondary,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 26.h),
                /// Rating container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7.w),
                                child: Icon(
                                                            index < 4
                                  ? FontAwesomeIcons.solidStar  // Example: solid star icon
                                  : FontAwesomeIcons.star, // Show empty star for 4 out of 5 rating
                                                            color: AppColors.goldenstar,
                                                            size: 30.w,
                                                          ),
                              ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '4 out of 5',
                            style: jost500(
                                14.sp,
                                AppColors.buttontext,
                            ),
                          ),
                          Text(
                            '15 reviews',
                            style: jost500(
                              14.sp,
                              AppColors.buttontext,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                /// Dropdown for selecting stars
                Container(
                  height: 26.h,
                  width: 87.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(9.r), // Apply border radius here
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRating,
                        icon: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: AppColors.secondary,
                        ),
                        iconSize: 20.w,
                        elevation: 16,
                        dropdownColor: AppColors.primary,
                        style: jost400(
                          13.sp,
                          AppColors.secondary,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRating = newValue!;
                          });
                        },
                        items: <String>[
                          '5 stars',
                          '4 stars',
                          '3 stars',
                          '2 stars',
                          '1 star'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                /// Display Reviews Based on Selected Rating
                Column(
                  children: reviewsData[selectedRating]!.map((review) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20.w,
                                backgroundImage: AssetImage("assets/images/review_coments_image.png"), // Correct usage with AssetImage
                              ),

                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['name']!,
                                    style: jost700(13.23.sp, AppColors.primary,),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(
                                          5,
                                              (index) => Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 2.w), // Adjust right padding as needed
                                            child: Icon(
                                              index < int.parse(selectedRating[0])
                                                  ? FontAwesomeIcons.solidStar
                                                  : FontAwesomeIcons.star,
                                              color: AppColors.goldenstar,
                                              size: 16.w,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 5.w),
                                      Text(
                                        review['date']!,
                                        style: jost600(
                                            12.sp,
                                            AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            review['comment']!,
                            style: jost500(
                              13.sp,
                              AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
