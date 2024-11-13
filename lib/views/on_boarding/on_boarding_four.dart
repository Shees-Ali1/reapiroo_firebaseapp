import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../const/color.dart';
import '../../const/images.dart';
import '../../const/text_styles.dart';

class OnBoardingFour extends StatelessWidget {
  const OnBoardingFour({super.key});

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
            'Secure Payments',
            style: jost700(26.54.sp, AppColors.primary),
          ),
          SizedBox(
            height: 29.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),

            child: Text(
              'Pay securely using your preferred method. Your\npayment is held until the job is completed to\nyour satisfaction.',
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
                        height: 240.h,
                        width: 240.w,
                        child: Image.asset(
                          AppImages.onboarding3,
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
