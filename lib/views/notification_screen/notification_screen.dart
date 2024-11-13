import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for notifications
    final notifications = [
      {
        'title': 'Order Update',
        'message': 'Your order has been shipped!',
        'date': '10/10/2024',
      },
      {
        'title': 'Promotion',
        'message': 'Get 20% off on your next purchase!',
        'date': '09/10/2024',
      },
      {
        'title': 'Account Notice',
        'message': 'Your account settings have been updated.',
        'date': '08/10/2024',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        isSecondIcon: false,
        title: 'Notifications',
        onBackTap: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const FaIcon(
                  FontAwesomeIcons.bell,
                  color: Colors.black,
                ),
                title: Text(
                  notification['title']!,
                  style: jost600(14.sp, AppColors.primary),
                ),
                subtitle: Text(
                  notification['message']!,
                  style: jost500(12.sp, AppColors.primary),
                ),
                trailing: Text(
                  notification['date']!,
                  style: jost400(12.sp, AppColors.primary),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
