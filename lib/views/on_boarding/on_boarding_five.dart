import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../const/color.dart';
import '../../const/images.dart';
import '../../const/text_styles.dart';

class OnBoardingFive extends StatelessWidget {
  const OnBoardingFive({super.key});

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
            'Technicians, Get Ready!',
            style: jost700(26.54.sp, AppColors.primary),
          ),
          SizedBox(
            height: 29.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),

            child: Text(
              'Stay updated with new orders, respond quickly,\nand grow your wallet with each successful job.\nStart earning today!',
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
                        height: 326.h,
                        width: 326.w,
                        child: Image.asset(
                          AppImages.onboarding4,
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
