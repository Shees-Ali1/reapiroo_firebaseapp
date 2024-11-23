import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../const/color.dart';
import '../../../../const/text_styles.dart';
import '../../../../controllers/signup_controller.dart';
import '../../../../controllers/tech_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_input_fields.dart';
import '../../../../widgets/drop_down_widget.dart';

class PersonalDetailsForm extends StatefulWidget {
  const PersonalDetailsForm({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TechController techController = Get.find();
  String? selectedGender;
  final SignupController signupController = Get.put(SignupController());

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
          IntlPhoneField(
            // controller: signupController.phonenumber,
            flagsButtonPadding: EdgeInsets.only(left: 13.w),
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            showDropdownIcon: false,
            decoration: InputDecoration(
              hintText: 'Your phone number',
              filled: true,
              fillColor: Color(0xffFAFAFA),
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 14.h),
              counterText: '',
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'jost',
                fontSize: 14.65.sp,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.31.r),
                borderSide: BorderSide(color: Color(0xffE2E2E2),width: 0.95),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.31.r),
                borderSide: BorderSide(color: Color(0xffE2E2E2),width: 0.95),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.31.r),
                borderSide: BorderSide(color: Color(0xffE2E2E2),width: 0.95),
              ),
            ),
            initialCountryCode: 'AE',
            onChanged: (phone) {
              try {
                debugPrint("Phone number entered: ${phone.completeNumber}");
                signupController.phonenumber.text= phone.completeNumber;
                debugPrint("Phone number text: ${signupController.phonenumber.text}");
              } catch (e) {
                debugPrint("Error processing phone number: $e");
              }
            },
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

          CustomInputField(
            controller: password,
            label: 'Your password',
            prefixIcon: Icon(
              Icons.lock,
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
            // onChanged: (value) {
            //   setState(() {
            //     selectedGender = value;
            //   });
            //   print('Gender selected: $selectedGender'); // Debug output
            // },
          ),


          SizedBox(height: 120.h),

          CustomElevatedButton(
            text: 'Next',
            textColor: AppColors.secondary,
            onPressed: () {
              techController.updateUserDetails(
                firstname: firstname.text,
                lastname: lastname.text,
                email: email.text,
                password: password.text, phoneNumber: signupController.phonenumber.text,
                gender: signupController.selectedGender.value,
              );

              // Navigate by updating selectedIndex
              techController.selectedIndex.value = "1";

            },
            backgroundColor: AppColors.primary,
          ),


        ],
      ),
    );
  }
}
