import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/images.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController topicController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  void _openWhatsApp() async {
    const phoneNumber = '+923206754536'; // example phone number
    final url = Uri.parse('https://wa.me/$phoneNumber');  // WhatsApp URL format

    // Check if the URL can be launched and open it in an external application
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Show an error message if the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open WhatsApp.')),
      );
    }
  }

  void _showApprovalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'Your request has been approved by admin',
                style: jost500(18.sp, Color(0xff1E1E1E)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: MyAppBar(
          isMenu: false,
          isNotification: false,
          isTitle: true,
          isSecondIcon: false,
          title: 'Help & Support',
          onBackTap: () {
            Get.back();
          },
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Topic',
                  style: jost500(16.sp, Color(0xff1E1E1E)),
                ),
                SizedBox(height: 8.h),
                CustomInputField(
                  hintText: 'Enter Your Topic',
                  controller: topicController,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Message',
                  style: jost500(16.sp, Color(0xff1E1E1E)),
                ),
                SizedBox(height: 8.h),
                CustomInputField(
                  hintText: 'Enter Your Message',
                  maxLines: 4,
                  controller: messageController,
                ),
                SizedBox(height: 30.h),
                CustomElevatedButton(
                  text: 'Continue',
                  textColor: AppColors.secondary,
                  onPressed: _showApprovalDialog,
                  backgroundColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: Padding(
        //   padding: EdgeInsets.only(bottom: 50, right: 5),
        //   child: FloatingActionButton(
        //     onPressed: _openWhatsApp,
        //     child: SizedBox(
        //         height: 40.h,
        //         width: 40.w,
        //         child: Image.asset(AppImages.whatsapp)),
        //     backgroundColor: Colors.green,
        //   ),
        // ),
      ),
    );
  }
}
