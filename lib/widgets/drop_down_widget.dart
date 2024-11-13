import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/drop_down_controller.dart';

class GenderDropdownField extends StatelessWidget {
  final String label;
  final String iconPath; // String for image path
  final double iconHeight; // Height of the icon
  final double iconWidth; // Width of the icon
  final GenderController genderController = Get.put(GenderController()); // Inject the controller

  GenderDropdownField({
    required this.label,
    required this.iconPath,
    this.iconHeight = 24.0, // Default height
    this.iconWidth = 24.0,  // Default width
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(13.31.r), // Match with the input decoration
      ),
      child: DropdownButtonFormField<String>(
        value: genderController.selectedGender.value.isEmpty
            ? null
            : genderController.selectedGender.value, // Bind the value to the controller's observable
        decoration: InputDecoration(
          filled: true, // Enable filled background
          fillColor: AppColors.fill, // Set fill color
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.primary,
            fontSize: 14.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.31.r),
            borderSide: BorderSide(color: Color(0xffE2E2E2), width: 0.95.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE2E2E2), width: 0.95.w),
            borderRadius: BorderRadius.circular(13.31.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE2E2E2), width: 0.95.w),
            borderRadius: BorderRadius.circular(13.31.r),
          ),
          prefixIcon: Container( // Use Container to control size
            height: iconHeight,
            width: iconWidth,
            alignment: Alignment.center, // Center the icon
            child: ColorFiltered( // Apply color filter to the image
              colorFilter: ColorFilter.mode(
                AppColors.primary.withOpacity(1), // Set the color for the image
                BlendMode.srcIn, // Blend mode to apply color
              ),
              child: Image.asset(
                iconPath, // Use the image asset path
                height: iconHeight, // Set the height
                width: iconWidth, // Set the width
                fit: BoxFit.contain, // Ensure the image fits well
              ),
            ),
          ),
        ),
        items: <String>['Male', 'Female', 'Other'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: jost400(
                14.65.sp,
                AppColors.primary,
              ), // Set dropdown item text color
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          genderController.updateGender(newValue); // Update the controller on change
        },
        dropdownColor: AppColors.fill, // Set dropdown background color
        iconEnabledColor: Colors.black, // Set icon color to black
        style: TextStyle(color: AppColors.primary), // Set the selected item text color
        icon: Icon(Icons.keyboard_arrow_down_sharp,
          color: AppColors.primary,size: 28,
        ), // Default dropdown icon
      ),
    ));
  }
}
