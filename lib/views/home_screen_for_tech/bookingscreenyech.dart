import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../const/color.dart';
import '../../const/text_styles.dart';
import '../../controllers/nav_bar_controller.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/app_bars.dart';
import '../booking_screens/techbooking.dart';
import '../booking_screens/today_screen_content.dart';
import '../booking_screens/today_screen_widgets/today_screen_booking_card.dart';
import '../notification_screen/notification_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class bookingTech extends StatefulWidget {
  const bookingTech({super.key});

  @override
  State<bookingTech> createState() => _bookingTechState();
}

class _bookingTechState extends State<bookingTech> {
  String? selectedOption = 'All'; // Default to "All"

  final NavBarController navBarController = Get.find<NavBarController>();

  // Assuming you have a view model that holds the user role
  final UserController userVM = Get.put(UserController());
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<DropdownMenuItem<String>> _getDropdownItems(String userRole) {
    // Return different items based on the user role
    if (userRole != "Customer") {
      return [
        DropdownMenuItem(
          value: 'All',
          child: Text(
            'All',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),DropdownMenuItem(
          value: 'In Progress',
          child: Text(
            'In Progress',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),
        DropdownMenuItem(
          value: 'Completed',
          child: Text(
            'Completed',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),
        DropdownMenuItem(
          value: 'Canceled',
          child: Text(
            'Canceled',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),
      ];
    } else if (userRole == "Customer") {
      return [
        DropdownMenuItem(
          value: 'All',
          child: Text(
            'All',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),
        DropdownMenuItem(
          value: 'Searching',
          child: Text(
            'Searching',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),
        DropdownMenuItem(
          value: 'In Progress',
          child: Text(
            'In Progress',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),
        DropdownMenuItem(
          value: 'Completed',
          child: Text(
            'Completed',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),
        DropdownMenuItem(
          value: 'Canceled',
          child: Text(
            'Canceled',
            style: jost700(14.sp, AppColors.primary),
          ),
        ),
      ];
    } else {
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bookings",
                  style: jost700(24.sp, AppColors.primary),
                ),
                /// Dropdown Menu for filtering orders
                Container(
                  height: 29.h,
                  width: 87.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.83.r),
                  ),
                  child: DropdownButton<String>(
                    value: selectedOption,
                    dropdownColor: AppColors.secondary, // Yellow background for dropdown items
                    hint: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    items: _getDropdownItems(userVM.userRole.value),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value; // Update the selected option
                      });
                    },
                    // Custom rendering for the selected item to underline it
                    selectedItemBuilder: (BuildContext context) {
                      return [
                        'All', 'Searching', 'In Progress', 'Completed', 'Canceled'
                      ].map<Widget>((String value) {
                        return Container(
                          width: 87.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  value,
                                  style: jost400(11.sp, AppColors.secondary),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: AppColors.secondary, size: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(); // Ensure it's a List<Widget>
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h), // Spacing below the row
            Expanded(
              child: _getBodyContent(selectedOption), // Update to call the widget directly
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBodyContent(String? option) {
    return  StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('CompletedTasks').snapshots(),
      builder: (context, snapshot) {
        // Check for loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check for empty data
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No completed tasks found"));
        }

        // Filter Firestore Data Locally
        var filteredTasks = snapshot.data!.docs.where((doc) {
          var completedTask = doc['completedTask'] ?? {};
          return completedTask['bidderid'] == currentUserId;
        }).toList();

        if (filteredTasks.isEmpty) {
          return const Center(child: Text("No tasks matching your ID found"));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            var task = filteredTasks[index];
            var data = task['completedTask'];

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: BookingCardtech(
                id: data['randomId'] ?? 'Unknown Task',
                title: data['title'] ?? 'Unknown title',
                name: data['userName'] ?? 'Unknown Task',
                status: 'Completed',
                category: data['taskDescription'] ?? 'General',
                location: data['location'] ?? 'Unknown',
                description: data['taskDescription'] ?? 'No Description',
                date: data['selectedDateTime']?.split('T')[0] ?? 'No Date',
                time: data['selectedDateTime']?.split('T')[1]?.split('.')[0] ?? 'No Time',
                imagePath: data['imageUrl'] ?? '',
              ),
            );
          },
        );
      },
    )

    //   StreamBuilder<QuerySnapshot>(
    //   stream: FirebaseFirestore.instance.collection('CompletedTasks').snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //
    //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //       return const Center(child: Text("No completed tasks found"));
    //     }
    //
    //     // Parse Firestore Data
    //     var taskDocs = snapshot.data!.docs;
    //
    //     return ListView.builder(
    //       padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
    //       itemCount: taskDocs.length,
    //       itemBuilder: (context, index) {
    //         var task = taskDocs[index];
    //         var data = task['completedTask'];
    //
    //         return Padding(
    //           padding: EdgeInsets.only(bottom: 12.h),
    //           child: BookingCardtech(
    //             id: task.id,
    //             name: data['title'] ?? 'Unknown Task',
    //             status: 'Completed',
    //             category: data['taskDescription'] ?? 'General',
    //             location: data['location'] ?? 'Unknown',
    //             description: data['taskDescription'] ?? 'No Description',
    //             price: 'N/A', // Add pricing if applicable
    //             date: data['selectedDateTime']?.split('T')[0] ?? 'No Date',
    //             time: data['selectedDateTime']?.split('T')[1]?.split('.')[0] ?? 'No Time',
    //             imagePath: data['imageUrl'] ?? '',
    //           ),
    //         );
    //       },
    //     );
    //   },
    // )
    ;  }
}
