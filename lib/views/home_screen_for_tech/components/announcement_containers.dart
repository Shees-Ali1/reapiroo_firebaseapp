import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
class AnnouncementContainers extends StatelessWidget {
  const AnnouncementContainers({super.key, required this.title, required this.message, required this.date, required this.type});

  final String title;
  final String message;
  final String date;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.w),
      ),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      type == "offer" ? AppImages.offer : AppImages.announcement,
                      height: type == "offer" ? 15.h : 19.h,
                      width: type == "offer" ? 15.w : 19.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      type == "offer" ? "New Offer" : "Announcement",
                      style: jost400(14.sp, AppColors.secondary),
                    ),
                  ],
                ),
                Text(
                  date,
                  style: jost(8.sp, AppColors.secondary, FontWeight.w300),
                ),
              ],
            ),
            SizedBox(height: 13.h),
            Text(
              message,
              style: jost(8.sp, AppColors.secondary, FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({Key? key}) : super(key: key);

  @override
  _AnnouncementListState createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    List<Map<String, dynamic>> notifications = [];

    try {
      DocumentSnapshot snapshot = await _firestore.collection('admin').doc('announcement').get();
      List notificationsArray = snapshot['notifications'];

      for (var notification in notificationsArray) {
        notifications.add({
          'title': notification['title'],
          'message': notification['message'],
          'date': notification['date'],
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(  // Fetch data here
      future: fetchNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching data"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No data available"));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: snapshot.data!.map((notification) {
              return AnnouncementContainers(
                title: notification['title'],
                message: notification['message'],
                date: notification['date'],
                type: "new",  // Adjust depending on your data type
              );
            }).toList(),
          ),
        );
      },
    );
  }
}


