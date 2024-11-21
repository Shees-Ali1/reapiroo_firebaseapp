import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/nav_bar_controller.dart';
import 'package:repairoo/controllers/user_controller.dart';
import 'package:repairoo/views/booking_screens/today_screen_content.dart'; // Ensure you have this file created with TodayContent
import 'package:repairoo/views/notification_screen/notification_screen.dart';
import 'package:repairoo/widgets/app_bars.dart';

class BookingScreenMain extends StatefulWidget {
  const BookingScreenMain({super.key});

  @override
  _BookingScreenMainState createState() => _BookingScreenMainState();
}

class _BookingScreenMainState extends State<BookingScreenMain> {
  String? selectedOption = 'All'; // Default to "All"

  final NavBarController navBarController = Get.find<NavBarController>();

  // Assuming you have a view model that holds the user role
  final UserController userVM = Get.put(UserController());
  // Assuming you are using GetX for state management

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
                  child:
                  DropdownButton<String>(
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

  List<DropdownMenuItem<String>> _getDropdownItems(String userRole) {
    // Return different items based on the user role
    if (userRole == "Customer") {
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

  Widget _getBodyContent(String? option) {
    // Returns the body content based on the selected option
    switch (option) {
      case 'All':
        return TodayContent(); // Ensure this returns a Widget for "All"
      case 'Searching':
        return Center(
          child: Text(
            'Displaying orders searching for tech.',
            style: jost400(18.sp, AppColors.primary),
          ),
        );
      case 'In Progress':
        return TodayContent();
      case 'Completed':
        return Center(
          child: Text(
            'Displaying completed orders.',
            style: jost400(18.sp, AppColors.primary),
          ),
        );
      case 'Canceled':
        return Center(
          child: Text(
            'Displaying canceled orders.',
            style: jost400(18.sp, AppColors.primary),
          ),
        );
      default:
        return Center(
          child: Text(
            'Please select a filter.',
            style: jost400(18.sp, AppColors.primary),
          ),
        );
    }
  }
}
