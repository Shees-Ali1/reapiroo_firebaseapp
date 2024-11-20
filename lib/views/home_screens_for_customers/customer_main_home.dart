import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/controllers/nav_bar_controller.dart';
import 'package:repairoo/views/customer_wallet_screen/wallet_screen.dart';
import 'package:repairoo/views/notification_screen/notification_screen.dart';
import 'package:repairoo/views/home_screens_for_customers/components/services_container.dart';
import 'package:repairoo/views/home_screens_for_customers/customer_task_home.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../const/svg_icons.dart';
import '../../const/text_styles.dart';
import '../../controllers/top services controller.dart';
import '../../widgets/custom_container.dart';
import '../home_screen_for_tech/components/announcement_containers.dart';
import 'components/slider_image.dart';

class CustomerMainHome extends StatefulWidget {
  const CustomerMainHome({super.key});

  @override
  State<CustomerMainHome> createState() => _CustomerMainHomeState();
}

class _CustomerMainHomeState extends State<CustomerMainHome> {
  final HomeController customerVM = Get.find<HomeController>();
  final NavBarController navBarController = Get.find<NavBarController>();
  final TopServiceController topServiceController = Get.put(TopServiceController());

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
                  SizedBox(height: 6.h),
                  SlidingMenu(
                    imageUrls: [
                      AppImages.home_ad,
                      AppImages.home_ad,
                      AppImages.home_ad,
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
                    child: Row(
                      children: [
                        AnnouncementList(),  // Displaying fetched announcements here
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
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
                  SizedBox(height: 11.h),
                  Obx(() {
                    if (topServiceController.topServices.isEmpty) {
                      return Center(
                        child: Text(
                          "No services available",
                          style: jost400(14.sp, AppColors.lightGrey),
                        ),
                      );
                    }
                    return MasonryGridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2, // Number of items in a row
                      mainAxisSpacing: 20.w, // Vertical spacing between items
                      crossAxisSpacing: 20.w, // Horizontal spacing between items
                      itemCount: topServiceController.topServices.length,
                      itemBuilder: (context, index) {
                        final service = topServiceController.topServices[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(CustomerTaskHome(
                              service: service['title'],
                            ));
                          },
                          child: ServicesContainer(
                            image: topServiceController.topServices[index]["image"], // Pass the image URL
                            title: topServiceController.topServices[index]["title"],
                            isNetworkImage: true, // Indicate it's a network image
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
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
      List notificationsArray = snapshot['notifications'] ?? [];  // Ensure it's not null

      for (var notification in notificationsArray) {
        DateTime timestamp;

        // Check if the 'time' field exists and is a valid Timestamp
        if (notification['time'] != null && notification['time'] is Timestamp) {
          timestamp = (notification['time'] as Timestamp).toDate();
        } else {
          // Fallback to the current time if 'time' is missing or invalid
          timestamp = DateTime.now();
        }

        notifications.add({
          'title': notification['title'] ?? 'No Title',
          'message': notification['message'] ?? 'No Message',
          'timestamp': timestamp,  // Store the DateTime object
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    return notifications;
  }
  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder<List<Map<String, dynamic>>>(  // Fetching data using FutureBuilder
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Set the color to black
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: snapshot.data!.map((notification) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 16),
                  child: AnnouncementContainers(
                    title: notification['title'],  // Pass the title to the container
                    message: notification['message'],  // Pass the message to the container
                    timestamp: notification['timestamp'],  // Pass the valid timestamp to the container
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
  }
}

class AnnouncementContainers extends StatelessWidget {
  const AnnouncementContainers({
    super.key,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  final String title;
  final String message;
  final DateTime timestamp; // Change to DateTime type

  @override
  Widget build(BuildContext context) {
    // Format the timestamp into a string (e.g., "16 Sep 2024")
    String formattedTime = DateFormat('d MMM yyyy').format(timestamp);

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
                SizedBox(
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.announcement, // Assuming a static image for now
                        height: 19.h,
                        width: 19.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        title, // Static text for now
                        style: jost400(14.sp, AppColors.secondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  formattedTime, // Display the formatted timestamp
                  style: jost(8.sp, AppColors.secondary, FontWeight.w300),
                ),
              ],
            ),
            SizedBox(height: 13.h),
            Text(
              message, // Display the fetched message
              style: jost(8.sp, AppColors.secondary, FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}

