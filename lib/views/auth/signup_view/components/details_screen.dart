import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/controllers/tech_controller.dart';
import 'package:repairoo/widgets/custom_button.dart';

import '../../../../const/color.dart';
import '../../../../const/text_styles.dart';
import '../../../../widgets/custom_input_fields.dart';

class DetailsScreen extends StatefulWidget {
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController description = TextEditingController();

  final TechController techController = Get.find();

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Write a short bio about yourself',
            style: jost600(15.17.sp, Color(0xff6B7280)),
          ),
          SizedBox(
            height: 30.h,
          ),
          CustomInputField(
            hintText: 'I am Muhammad, i have +10 Years experience in Plumping and ready to serve you anytime.',
            maxLines: 6,
            controller: description,
          ),
          SizedBox(
            height: 179.h,
          ),
          CustomElevatedButton(
            text: 'Next',
            textColor: AppColors.secondary,
            onPressed: () {
              // Button action
              techController.updateBio(description.text);

              // Navigate to the next step
              techController.selectedIndex.value = "3";            },
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
