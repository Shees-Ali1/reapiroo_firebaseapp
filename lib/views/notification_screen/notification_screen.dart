import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Fetch notifications from Firestore only if the customerUid matches the current user's UID
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    List<Map<String, dynamic>> notifications = [];
    try {
      // Get the current user's UID
      String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Get the document from your Firestore collection
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('techNotifications')
          .doc('hlcH2Vy5E8pBgBzkaaBj') // Document ID
          .get();

      // Extract the required fields if document exists
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        String customerUid = data['customerUid'] ?? ''; // Get customer UID from the document
        String bidAmount = data['bidAmount'] ?? 'N/A';
        String message = data['message'] ?? 'No Message';
        Timestamp timestamp = data['timestamp'] ?? Timestamp.now();

        // Format the timestamp using DateFormat
        String formattedDate = DateFormat('MM/dd/yyyy, hh:mm a').format(timestamp.toDate());

        // Check if customerUid matches the current user's UID
        if (customerUid == currentUserUid) {
          notifications.add({
            'title': message, // Example title
            'message': bidAmount,
            'date': formattedDate, // Use formatted timestamp
          });
        }
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error fetching data"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No data available"));
            }

            // ListView to display notifications
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['message']!,
                          style: jost500(12.sp, AppColors.primary),
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                    trailing: Text(
                      notification['date']!, // Formatted date displayed here
                      style: jost400(12.sp, AppColors.primary),
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
