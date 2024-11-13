import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic faqs = [
      {
        'question': 'How can I download the app?',
        'answer':
            'You can download the app from the App Store\n (for iOS devices) or the Google Play Store (for Android)',
      },
      {
        'question': 'Is the app free to use?',
        'answer':
            'Yes, the basic version of the Repairoo app is free to\n download and use. However, there may be optional.',
      },
      {
        'question': 'Can I use the app offline?',
        'answer':
            "Repairoo offer offline access to some or all of their\n content. Check the app's settings or user guide.",
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        isSecondIcon: false,
        title: 'Faqs',
        onBackTap: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: faqs.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 10.h),
                        // height: 100.h,
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            // border: Border.all(
                            //     color: AppColors.secondary.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.primary),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(faqs[index]['question'].toString(),
                                    style: jost600(
                                      12.sp,
                                      AppColors.secondary,
                                    )),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                                maxLines: 3,
                                faqs[index]['answer'].toString(),
                                style: jost600(
                                  12.sp,
                                  AppColors.secondary,
                                )),
                          ],
                        )),
                  );
                })
          ],
        ),
      ),
    );
  }
}
