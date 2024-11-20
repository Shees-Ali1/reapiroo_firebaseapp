
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';
import '../home_screen_for_tech/components/customer_bid.dart';
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Get the current user's UID
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final Query notificationsQuery = FirebaseFirestore.instance
        .collection('Bid Notifications')
        .where('bidderId', isEqualTo: currentUserId);
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
        child: StreamBuilder<QuerySnapshot>(
          stream: notificationsQuery.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching notifications',
                  style: jost500(14.sp, AppColors.primary),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No notifications found',
                  style: jost500(14.sp, AppColors.primary),
                ),
              );
            }

            final notifications = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index].data() as Map<String, dynamic>;
                final title = notification['message'] ?? 'No title';
                final message = 'Bid Amount: ${notification['bidAmount']}';
                final timestamp = notification['timestamp'] != null
                    ? (notification['timestamp'] as Timestamp).toDate()
                    : DateTime.now();
                final date = '${timestamp.day}/${timestamp.month}/${timestamp.year}';

// NotificationScreen.dart

                return GestureDetector(
                  onTap: () {
                    final bidAmountString = notification['bidAmount'] ?? '0.0';
                    final bidAmount = double.tryParse(bidAmountString) ?? 0.0;

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CustomerBidBottomSheet(
                        bidAmount: bidAmount,
                        bidderId: notification['bidderId'], // Pass bidderId
                        customerUid: notification['customerUid'], // Pass customerUid
                      ),
                    );
                  },

                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const FaIcon(
                        FontAwesomeIcons.bell,
                        color: Colors.black,
                      ),
                      title: Text(
                        title,
                        style: jost600(14.sp, AppColors.primary),
                      ),
                      subtitle: Text(
                        message,
                        style: jost500(12.sp, AppColors.primary),
                      ),
                      trailing: Text(
                        date,
                        style: jost400(12.sp, AppColors.primary),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
