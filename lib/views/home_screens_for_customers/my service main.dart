import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../const/color.dart';
import '../../const/text_styles.dart';
import '../../controllers/nav_bar_controller.dart';
import '../../widgets/app_bars.dart';

class MyServiceMain extends StatefulWidget {
  const MyServiceMain({super.key});

  @override
  State<MyServiceMain> createState() => _MyServiceMainState();
}

class _MyServiceMainState extends State<MyServiceMain> {
  String? selectedOption = 'All'; // Default to "All"
  final NavBarController navBarController = Get.find<NavBarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
body: Padding(
  padding: const EdgeInsets.all(13.5),
  child: Column(
    children: [
      SizedBox(height: 40.h,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Your Services',
            style: jost700(24.sp, AppColors.primary),
          ),
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
              items: _getDropdownItems(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value; // Update the selected option
                });
              },
              // Custom rendering for the selected item to underline it
              selectedItemBuilder: (BuildContext context) {
                return [
                  'All', 'House Cleaning', 'TV Mounting', 'Gardening', 'Plumbing'
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
      )
    ],
  ),
),
    );
  }
}
