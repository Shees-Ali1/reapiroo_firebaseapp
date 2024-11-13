import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/controllers/nav_bar_controller.dart';
import 'package:repairoo/views/notification_screen/notification_screen.dart';
import 'package:repairoo/widgets/app_bars.dart';

import '../../const/color.dart';
import '../../const/svg_icons.dart';
import '../../const/text_styles.dart';
import '../booking_screens/today_screen_widgets/today_screen_booking_card.dart';
import '../tech_wallet/wallet_screen.dart';
import 'components/tech_order_bookings.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<Map<String, String>> bookingData = [
    {
      'name': 'Jared Hughs',
      'location': 'Downtown Road, Dubai.',
      'description':
      'I need to have my outdoor pipes fixed.\nWe have a huge leakage in the valves\nand the wall fittings.',
      'date': 'Mon, Dec 23',
      'time': '12:00',
      'image': AppImages.saraprofile, // Replace with your image path
    },
    {
      'name': 'Michael Scott',
      'location': 'Central Street, Abu Dhabi.',
      'description':
      'The indoor heating system is malfunctioning.\nNeed help to fix the furnace ASAP.',
      'date': 'Wed, Jan 02',
      'time': '14:30',
      'image': AppImages.profileImage, // Replace with your image path
    },


  ];
  final NavBarController navBarController = Get.find<NavBarController>();
  String? selectedOption = 'Nearest'; // Default to "In Progress"
  String? serviceOption = 'All'; // Default to "In Progress"

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        onNotificationTap: () {
          Get.to(NotificationScreen());
        },
        onMenuTap: () {
          navBarController.openDrawer(context);
        },
        isMenu: true,
        isNotification: true,
        isTitle: true,
        isSecondIcon: false,
        title: 'Order Screen',
        secondIcon: AppSvgs.white_wallet,
        onSecondTap: () {
          Get.to(Wallet());
        },
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 26.h,
                  width: 87.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.83.r),
                  ),
                  child: DropdownButton<String>(
                    value: serviceOption,
                    dropdownColor: AppColors.secondary, // Yellow background for dropdown items
                    hint: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select',
                          style: jost700(14.sp, AppColors.primary),
                        ),
                      ],
                    ),
                    isExpanded: false,
                    underline: SizedBox(), // Remove the default underline
                    icon: SizedBox.shrink(), // Remove the default icon
                    items: [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text(
                          'All',
                          style: jost700(14.sp, AppColors.primary),
                        ),
                      ), DropdownMenuItem(
                        value: 'Plumbing',
                        child: Text(
                          'Plumbing',
                          style: jost700(14.sp, AppColors.primary),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Gardening',
                        child: Text(
                          'Gardening',
                          style: jost700(14.sp, AppColors.primary),
                        ),
                      ),

                    ],
                    onChanged: (value) {
                      setState(() {
                        serviceOption = value; // Update the selected option
                      });
                    },
                    // Custom rendering for the selected item to underline it
                    selectedItemBuilder: (BuildContext context) {
                      return ['All','Plumbing', 'Gardening'].map((String value) {
                        return Container(
                          width: 87.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  value,
                                  style: jost400(11.sp, AppColors.secondary),
                                ),

                                Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: AppColors.secondary,size: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                Container(
                  height: 26.h,
                  width: 87.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.83.r),
                  ),
                  child: DropdownButton<String>(
                    value: selectedOption,
                    dropdownColor: AppColors.secondary, // Yellow background for dropdown items
                    hint: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select',
                          style: jost700(14.sp, AppColors.primary),
                        ),
                      ],
                    ),
                    isExpanded: false,
                    underline: SizedBox(), // Remove the default underline
                    icon: SizedBox.shrink(), // Remove the default icon
                    items: [
                      DropdownMenuItem(
                        value: 'Nearest',
                        child: Text(
                          'Nearest',
                          style: jost700(14.sp, AppColors.primary),
                        ),
                      ),DropdownMenuItem(
                        value: 'Newest ',
                        child: Text(
                          'Newest ',
                          style: jost700(14.sp, AppColors.primary),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Oldest',
                        child: Text(
                          'Oldest',
                          style: jost700(14.sp, AppColors.primary),
                        ),
                      ),

                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value; // Update the selected option
                      });
                    },
                    // Custom rendering for the selected item to underline it
                    selectedItemBuilder: (BuildContext context) {
                      return ['Nearest', 'Far'].map((String value) {
                        return Container(
                          width: 87.w,
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.w,right: 6.w),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  value,
                                  style: jost400(11.sp, AppColors.secondary),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: AppColors.secondary,size: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h,),
            ListView.builder(
              shrinkWrap: true,
              itemCount: bookingData.length,
              itemBuilder: (context, index) {
                final booking = bookingData[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index != bookingData.length - 1 ? 12.h : 0),
                  child: OrderBookingCard(
                    name: booking['name']!,
                    location: booking['location']!,
                    description: booking['description']!,
                    date: booking['date']!,
                    time: booking['time']!,
                    imagePath: booking['image']!,
                  ),
                );
              },
            ),
          ],
        ),
      ),

    );
  }
}
