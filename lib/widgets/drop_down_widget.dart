import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import 'package:repairoo/controllers/signup_controller.dart';
import '../const/color.dart';
import '../const/text_styles.dart';
import '../controllers/tech_controller.dart';

class GenderDropdownField extends StatelessWidget {
  final String label;
  final String iconPath;
  final double iconHeight;
  final double iconWidth;
  final void Function(String?)? onChanged;
  final TechController techController = Get.put(TechController());
  final SignupController signupController = Get.put(SignupController()); // Inject the controller
// Inject TechController
  final TechController techController = Get.find(); // Use Get.find() to ensure the same instance

  GenderDropdownField({
    required this.label,
    required this.iconPath,
    this.onChanged,
    this.iconHeight = 24.0, // Default height
    this.iconWidth = 24.0,  // Default width
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(13.31.r),
      ),
      child: DropdownButtonFormField<String>(
        value: techController.selectedGender.value.isEmpty
            ? null
            : techController.selectedGender.value,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.fill,
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
          prefixIcon: Container(
            height: iconHeight,
            width: iconWidth,
            alignment: Alignment.center,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.primary.withOpacity(1),
                BlendMode.srcIn,
              ),
              child: Image.asset(
                iconPath,
                height: iconHeight,
                width: iconWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        items: <String>['Male', 'Female', 'Other'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: jost400(14.65.sp, AppColors.primary),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          signupController.updateGender(newValue); // Update the controller on change
          // techController.updateGender(newValue);
          if (newValue != null) {
            techController.updateGender(newValue); // Update controller
          }
          if (onChanged != null) {
            onChanged!(newValue); // Trigger any additional behavior
          }
        },
        dropdownColor: AppColors.fill,
        iconEnabledColor: Colors.black,
        style: TextStyle(color: AppColors.primary),
        icon: Icon(Icons.keyboard_arrow_down_sharp,
            color: AppColors.primary, size: 28),
      ),
    ));
  }
}
