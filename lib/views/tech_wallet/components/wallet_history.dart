import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';

class WalletHistory extends StatelessWidget {
  const WalletHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: true,
        isTitle: true,
        isSecondIcon: false,
        title: 'History',
        onBackTap: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w),

        child: Column(children: [
          SizedBox(
            height: 14.h,
          ),
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                "Transactions",
                style: jost600(26.sp, AppColors.primary),
              )),
          SizedBox(
            height: 13.h,
          ),
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                "Today",
                style: jost400(13.sp, AppColors.primary),
              )),
          SizedBox(
            height: 25.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 28.1.w,
                    height: 28.1.h,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/arrow_down_wallet.png"),
                          scale: 4,
                        )),
                  ),
                  SizedBox(
                    width: 23.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Credit",
                        style: jost400(13.sp, AppColors.primary),
                      ),
                      Text(
                        "From Starbucks",
                        style: jost400(12.sp, AppColors.primary),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 37.0.w),
                child: Text(
                  "\$ 3,110",
                  style: jost500(14.sp, AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 35.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 28.1.w,
                    height: 28.1.h,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/arrow_left_wallet.png"),
                          scale: 4,
                        )),
                  ),
                  SizedBox(
                    width: 23.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transfer",
                        style: jost400(13.sp, AppColors.primary),
                      ),
                      Text(
                        "To Starbucks",
                        style: jost400(12.sp, AppColors.primary),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 37.0.w),
                child: Text(
                  "\$ 1,500",
                  style: jost500(14.sp, AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 21.h,
          ),
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                "Yesterday",
                style: jost400(13.sp, AppColors.primary),
              )),
          SizedBox(
            height: 16.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 28.1.w,
                    height: 28.1.h,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/arrow_left_wallet.png"),
                          scale: 4,
                        )),
                  ),
                  SizedBox(
                    width: 23.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transfer",
                        style: jost400(13.sp, AppColors.primary),
                      ),
                      Text(
                        "To Starbucks",
                        style: jost400(12.sp, AppColors.primary),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 37.0.w),
                child: Text(
                  "\$ 3,110",
                  style: jost500(14.sp, AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
        ],),
      ),
    );

  }
}
