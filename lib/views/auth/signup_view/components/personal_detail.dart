import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../const/color.dart';
import '../../../../const/text_styles.dart';
import '../../../../controllers/tech_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_input_fields.dart';
import '../../../../widgets/drop_down_widget.dart';
import '../../otp_verification/otp_verification.dart';

class PersonalDetailsForm extends StatefulWidget {
  const PersonalDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TechController techController = Get.find();

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Enter Your Personal Details here.',
              style: jost600(15.17.sp, Color(0xff6B7280)),
            ),
          ),
          SizedBox(height: 56.h),

          /// First Name and Last Name TextFields
          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  label: 'First Name',
                  controller: firstname,
                  prefixIcon: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 19.w),
              Expanded(
                child: CustomInputField(
                  label: 'Last Name',
                  controller: lastname,
                  prefixIcon: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),

          /// Email TextField
          CustomInputField(
            controller: email,
            label: 'Your email',
            prefixIcon: Icon(
              Icons.email,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(height: 25.h),

          /// Gender Drop Down Field
          GenderDropdownField(
            label: 'Gender',
            iconPath: 'assets/images/gender_icon.png',
            iconHeight: 18.h,
            iconWidth: 18.w,
          ),
          SizedBox(height: 120.h),

          CustomElevatedButton(
            text: 'Next',
            textColor: AppColors.secondary,
            onPressed: () {
              // Button action
              techController.selectedIndex.value = "1";
            },
            backgroundColor: AppColors.primary,
          ),

        ],
      ),
    );
  }
}
