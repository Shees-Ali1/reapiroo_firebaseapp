import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../const/color.dart';
import '../../const/images.dart';
import '../../const/text_styles.dart';

class OnBoardingThree extends StatelessWidget {
  const OnBoardingThree({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(viewportFraction: 1);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          SizedBox(
            height: 100.h,
          ),
          Text(
            'Choose the Best Offer',
            style: jost700(26.54.sp, AppColors.primary),
          ),
          SizedBox(
            height: 29.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),

            child: Text(
              'Compare offers from multiple technicians and\npick the one that fits your needs and budget.\nNo hassle, no guessing!',
              style: jost600(15.17.sp, Color(0xff6B7280)),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(


            ),
          ),
          Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.60,

                  width: double.infinity,
                  child: Image.asset(
                    AppImages.onboardingelipse,
                    fit: BoxFit.fill,
                    color: AppColors.primary,
                  )),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 93.h,
                    ),
                    SizedBox(
                        height: 210.h,
                        width: 210.w,
                        child: Image.asset(
                          AppImages.onboarding2,
                          fit: BoxFit.contain,
                        )),
                    SizedBox(
                      height: 60.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
