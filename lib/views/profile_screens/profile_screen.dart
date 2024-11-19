import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/svg_icons.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/nav_bar_controller.dart';
import 'package:repairoo/controllers/user_controller.dart';
import 'package:repairoo/views/auth/login_view/login_screen.dart';
import 'package:repairoo/views/auth/signup_view/role_screen.dart';
import 'package:repairoo/views/customer_wallet_screen/wallet_screen.dart';
import 'package:repairoo/views/notification_screen/notification_screen.dart';
import 'package:repairoo/views/profile_screens/bio_and_experience/bio_and_experience_main.dart';
import 'package:repairoo/views/profile_screens/edit_profile_screen.dart';
import 'package:repairoo/views/profile_screens/reports/reports_screen.dart';
import 'package:repairoo/views/profile_screens/reviews/reviews_screen.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/profile_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../tech_wallet/wallet_screen.dart';
import 'support_screen/support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<ProfileScreen> {
  String? _imagePath; // Store the image path

  // Controllers for the text fields
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final UserController userVM = Get.put(UserController());
  final NavBarController navBarController = Get.find<NavBarController>();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed to free resources
    firstname.dispose();
    lastname.dispose();
    email.dispose();
    super.dispose();
  }
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Close the keyboard when tapping outside
      },
      child: Scaffold(
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
          title: 'Profile',
          isSecondIcon: false,
          // secondIcon: AppSvgs.notification,
        ),
        backgroundColor: AppColors.secondary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 44.h),

              /// Profile Image
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 138.w,
                  child: SizedBox(
                    height: 120.h,
                    width: 120.w,
                    child: CircleAvatar(
                      backgroundImage: _imagePath != null
                          ? FileImage(File(_imagePath!))
                          : AssetImage(AppImages.profileImage)
                              as ImageProvider, // Use the image from AppImages
                      radius: 60, // Optional: customize radius if needed
                    ),
                  ),
                ),
              ),
              Text(
                "Merrill Kervin",
                style: jost700(23.1.sp, AppColors.primary),
              ),
              SizedBox(height: 30.h),

              /// My Profile
              userVM.userRole.value == "Customer"
                  ? ProfileButton(
                      onPressed: () {
                        // Navigate to the EditProfileScreen
                        Get.to(EditProfileScreen());
                      },
                      label: "General Information",
                      iconPath: AppImages.name_icon,
                    )
                  : ProfileButton(
                      onPressed: () {
                        // Navigate to the EditProfileScreen
                        Get.to(EditProfileScreen());
                      },
                      label: "My Profile",
                      iconPath: AppImages.name_icon,
                    ),

              SizedBox(height: 10.h),

              /// Bio and Experience
              userVM.userRole.value == "Customer"
                  ? ProfileButton(
                      onPressed: () {
                        // Get.to(BioAndExperienceMain());
                      },
                      label: "Saved Address",
                      iconPath: AppImages.bagicon,
                    )
                  : ProfileButton(
                      onPressed: () {
                        Get.to(BioAndExperienceMain());
                      },
                      label: "Bio and Experience",
                      iconPath: AppImages.bagicon,
                    ),
              SizedBox(height: 10.h),
              userVM.userRole.value == "Customer"
                  ? SizedBox.shrink()
                  : ProfileButton(
                      onPressed: () {
                        Get.to(ReportsScreen());
                      },
                      label: "Reports",
                      iconPath: AppImages.reports_icon,
                    ),
              SizedBox(height: 10.h),

              /// Reviews
              userVM.userRole.value == "Customer"
                  ? ProfileButton(
                      onPressed: () {
                        Get.to(WalletScreen());
                      },
                      label: "Wallet",
                      iconPath: AppImages.wallet,
                    )
                  : ProfileButton(
                      onPressed: () {
                        Get.to(ReviewsScreen());
                      },
                      label: "Reviews",
                      iconPath: AppImages.star_icon,
                    ),

              SizedBox(height: 10.h),

              // /// Terms/Policy
              // ProfileButton(
              //   onPressed: () {
              //     // Navigate to the SettingsScreen
              //   },
              //   label: "Terms/Policy",
              //   iconPath: AppImages.privacyicon,
              // ),
              // SizedBox(height: 10.h),

              /// Help/Contact Us
              userVM.userRole.value == "Customer"
                  ? ProfileButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Help & Support"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.confirmation_number),
                            title: Text("Tickets"),
                            onTap: () {
                              Get.back();// Replace with your Tickets screen

                              // Navigate to the Tickets screen or handle tickets action
                              Get.to(SupportScreen());                              // Navigate to the Tickets screen or handle tickets action
                              // Get.to(TicketsScreen()); // Replace with your Tickets screen
                            },
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SizedBox(
                                height: 25,width: 25,
                                child: Image.asset(AppImages.whatsapp)),
                            title: Text("WhatsApp"),
                            onTap:       _openWhatsApp                   // Navigate to the Tickets screen or handle tickets action

                              // Navigate to WhatsApp support or open WhatsApp chat
                              // For example, launch WhatsApp with a specific number
                              // Get.to(WhatsAppSupportScreen()); // Replace with your WhatsApp support screen

                          ),
                        ],
                      ),

                    ),
                  );
                },
                label: "Help & Support",
                iconPath: AppImages.questionicon,
              )
            : ProfileButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Help & Support"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.confirmation_number),
                            title: Text("Tickets"),
                            onTap: () {
                              Get.back();// Replace with your Tickets screen

                              // Navigate to the Tickets screen or handle tickets action
                             Get.to(SupportScreen());
                            },
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SizedBox(
                                height: 25,width: 25,
                                child: Image.asset(AppImages.whatsapp)),
                            title: Text("WhatsApp"),
                              onTap:       _openWhatsApp ,                  // Navigate to the Tickets screen or handle tickets action

                          ),
                        ],
                      ),

                    ),
                  );
                },
                label: "Help & Support",
                iconPath: AppImages.questionicon,
              ),

              SizedBox(height: 30.h),
              userVM.userRole.value == "Customer"
                  ? GestureDetector(
                      onTap: () {
                        Get.offAll(LoginScreen());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 21.w),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.logout,
                              height: 25.h,
                              width: 25.w,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Text(
                              'Logout',
                              style: jost500(16.sp, AppColors.primary),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
    );
  }
}
