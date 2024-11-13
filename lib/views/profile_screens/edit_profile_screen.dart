import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/drop_down_widget.dart';
import 'dart:io';
import '../../widgets/custom_input_fields.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _imagePath; // Store the image path

  // Controllers for the text fields
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed to free resources
    firstname.dispose();
    lastname.dispose();
    email.dispose();
    super.dispose();
  }

  /// Image Source dialog Box
  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Choose an Option",
            style: jost400(
              16,
              AppColors.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery); // Pick image from gallery
                },
                child: Text('Gallery', style: jost400(14.sp, AppColors.primary)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera); // Take photo with camera
                },
                child: Text('Camera', style: jost400(14.sp, AppColors.primary)),
              ),
            ],
          ),
          backgroundColor: AppColors.secondary,
        );
      },
    );
  }

  /// Function to pick an image
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source); // Use pickImage instead of getImage

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path; // Update the image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Close the keyboard when tapping outside
      },
      child: Scaffold(
        appBar: MyAppBar(
          isMenu: false,
          isNotification: false,
          isTitle: true,
          title: 'Profile',
          isSecondIcon: false,
          onBackTap: (){
            Get.back();
          },
        ),
        backgroundColor: AppColors.secondary,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w),
            child: Column(
              children: [
                SizedBox(height: 44.h),
                /// Profile Image And Camera Icon
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 138.w,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 120.h,
                          width: 120.w,
                          child: CircleAvatar(
                            backgroundImage: _imagePath != null
                                ? FileImage(File(_imagePath!))
                                : AssetImage(AppImages.profileImage) as ImageProvider, // Use the image from AppImages
                            radius: 60, // Optional: customize radius if needed
                          ),
                        ),
                        /// Image Picker
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () => _showImageSourceDialog(context), // Open image source dialog
                            child: SizedBox(
                              width: 46.w,
                              height: 46.h,
                              child: CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: SizedBox(
                                  width: 23.w,
                                  height: 20.7.h,
                                  child: Image.asset(AppImages.camera), // Use Image.asset to load the image
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                        prefixIcon: Icon(Icons.person,
                          color: AppColors.primary,
                          size: 18.sp,
                        ), // Add prefix icon here
                      ),
                    ),
                    SizedBox(width: 19.w), // Adjust spacing between the two fields if needed
                    Expanded(
                      child: CustomInputField(
                        label: 'Last Name',
                        controller: lastname,
                        prefixIcon: Icon(Icons.person,
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
                  iconPath: 'assets/images/gender_icon.png', // Specify the image asset path
                  iconHeight: 18.h, // Set your desired height
                  iconWidth: 18.w,  // Set your desired width
                ),
                SizedBox(height: 38.h),
                /// Button Save Changes
                CustomElevatedButton(
                  text: "Save Changes",
                  onPressed: () {
                    // Handle the button press
                    print("Changes saved!");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
