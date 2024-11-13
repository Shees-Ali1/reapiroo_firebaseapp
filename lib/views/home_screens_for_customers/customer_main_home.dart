import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/svg_icons.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/controllers/nav_bar_controller.dart';
import 'package:repairoo/views/customer_wallet_screen/wallet_screen.dart';
import 'package:repairoo/views/home_screen_for_tech/components/announcement_containers.dart';
import 'package:repairoo/views/home_screens_for_customers/components/services_container.dart';
import 'package:repairoo/views/home_screens_for_customers/customer_task_home.dart';
import 'package:repairoo/views/home_screens_for_customers/search_offer_screen.dart';
import 'package:repairoo/views/notification_screen/notification_screen.dart';
import 'package:repairoo/views/tech_wallet/wallet_screen.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_container.dart';

import 'components/slider_image.dart';

class CustomerMainHome extends StatefulWidget {
  const CustomerMainHome({super.key});

  @override
  State<CustomerMainHome> createState() => _CustomerMainHomeState();
}

class _CustomerMainHomeState extends State<CustomerMainHome> {
  final HomeController customerVM = Get.find<HomeController>();
  final NavBarController navBarController = Get.find<NavBarController>();

  List<Map<String, dynamic>> dummy = [
    {
      "image": AppImages.house_cleaning,
      "title": "House Cleaning",
    },
    {
      "image": AppImages.tv_mounting,
      "title": "TV Mounting",
    },
    {
      "image": AppImages.gardening,
      "title": "Gardening",
    },
    {
      "image": AppImages.plumbing,
      "title": "Plumbing",
    },
  ];

  List<String> string = ["announcement", "offer"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: MyAppBar(
          onNotificationTap: () {
            Get.to(NotificationScreen());
          },
          onMenuTap: () {
            navBarController.openDrawer(context);
          },
          isMenu: true,
          isNotification: true,
          isTitle: false,
          isTextField: true,
          isSecondIcon: true,
          secondIcon: AppSvgs.white_wallet,
          onSecondTap: () {
            Get.to(WalletScreen());
          },
          title: "",
        ),
        backgroundColor: AppColors.secondary,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.5.w),
            child: Column(
              children: [
                SizedBox(
                  height: 6.h,
                ),
                SlidingMenu(
                  imageUrls: [
                    AppImages.home_ad,
                    AppImages.home_ad,
                    AppImages.home_ad
                  ],
                ),
                // Container(
                //   height: 150.h,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(12.w),
                //       image: DecorationImage(image: AssetImage(AppImages.home_ad), fit: BoxFit.fill)
                //   ),
                // ),
                SizedBox(
                  height: 8.h,
                ),
                // Container(
                //   height: 100.h,
                //   width: double.infinity,
                //   margin: EdgeInsets.only(bottom: 21.h),
                //   padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 6.h),
                //   decoration: BoxDecoration(
                //       color: AppColors.textFieldGrey,
                //       borderRadius: BorderRadius.circular(12.w),
                //       border: Border.all(
                //           width: 1,
                //           color: AppColors.lightGrey
                //       )
                //   ),
                //   child: ListView.builder(
                //       itemCount: string.length,
                //       shrinkWrap: true,
                //       padding: EdgeInsets.zero,
                //       scrollDirection: Axis.horizontal,
                //       itemBuilder: (context, index){
                //         return Padding(
                //           padding: EdgeInsets.only(left: index != 0 ? 8.w : 0),
                //           child: AnnouncementContainers(type: string[index],),
                //         );
                //       }),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Services",
                      style: jost700(16.sp, AppColors.primary),
                    ),
                    CustomButton(
                      width: 72.w,
                      height: 24.h,
                      vPadding: 0,
                      foregroundColor: AppColors.secondary,
                      backgroundColor: AppColors.primary,
                      labelFontSize: 10.sp,
                      borderRadius: 8.r,
                      label: "View all",
                      onPressed: () {},
                    )
                  ],
                ),
                SizedBox(
                  height: 11.h,
                ),
                MasonryGridView.count(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2, // Number of items in a row
                  mainAxisSpacing: 20.w, // Vertical spacing between items
                  crossAxisSpacing: 20.w, // Horizontal spacing between items
                  itemCount: dummy.length, // Number of items
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(CustomerTaskHome(
                          service: dummy[index]['title'],
                        ));
                      },
                      child: ServicesContainer(
                        image: dummy[index]["image"],
                        title: dummy[index]["title"],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
