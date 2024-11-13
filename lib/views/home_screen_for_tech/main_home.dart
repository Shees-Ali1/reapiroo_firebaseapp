import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/svg_icons.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/controllers/nav_bar_controller.dart';
import 'package:repairoo/controllers/user_controller.dart';
import 'package:repairoo/views/home_screen_for_tech/components/announcement_containers.dart';
import 'package:repairoo/views/home_screen_for_tech/task_description_home.dart';
import 'package:repairoo/views/notification_screen/notification_screen.dart';
import 'package:repairoo/views/tech_wallet/wallet_detail.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/custom_box.dart';
import 'package:repairoo/widgets/my_svg.dart';

import '../home_screens_for_customers/components/slider_image.dart';
import '../tech_wallet/wallet_screen.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final TechHomeController homeVM = Get.find<TechHomeController>();
  final UserController userVM = Get.find<UserController>();
  final NavBarController navBarController = Get.find<NavBarController>();

  String? selectedOption = 'Newest'; // Default to "In Progress"
  String? serviceOption = 'All'; // Default to "In Progress"

  List<Map<String, dynamic>> dummy = [
    {
      "image": AppSvgs.today_appointment,
      "title": "Today Appointments",
      "value": '3'
    },
    {
      "image": AppSvgs.happy_customers,
      "title": "Happy Customers",
      "value": '2000'
    },
    {
      "image": AppSvgs.jobs_completed,
      "title": "Jobs Completed",
      "value": '170'
    },
    {"image": AppSvgs.total_earned, "title": "Total Earned", "value": '\$400'},
  ];

  List<String> string = ["announcement", "offer"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        onNotificationTap: () {
          Get.to(NotificationScreen());
        },
        onMenuTap: () {
          navBarController.openDrawer(context);
        },
        isMenu: true,
        isNotification: true,
        isTitle: false,
        isSecondIcon: true,
        title: '',
        secondIcon: AppSvgs.white_wallet,
        onSecondTap: () {
          Get.to(Wallet());
        },
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 17.h,
                ),
                Text(
                  "Hi Hugh Quinn",
                  style: montserrat600(18.sp, AppColors.textGrey2),
                ),
                // SizedBox(
                //   height: 17.h,
                // ),
                // SlidingMenu(
                //   imageUrls: [
                //     AppImages.home_ad,
                //     AppImages.home_ad,
                //     AppImages.home_ad
                //   ],
                // ),
                SizedBox(
                  height: 8.h,
                ),
                Container(
                  height: 75.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.containerLightGrey,
                      borderRadius: BorderRadius.circular(12.w),
                      border:
                          Border.all(width: 1, color: AppColors.textFieldGrey)),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(WalletDetail(bankName: 'ADCB', name: '', iban: '', bankImage: 'assets/images/bank.png', accNumber: ''));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.wallet,
                                    width: 21.w,
                                    height: 17.h,
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  Text(
                                    "Balance",
                                    style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                "79.00 AED",
                                style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1.w,
                          height: 88.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFE2E2E2), // #E2E2E2
                                Color(0xFF525252), // #525252
                                Color(0xFFE2E2E2), // #E2E2E2
                              ],
                              stops: [
                                0.0, // at 0%
                                0.485, // at 48.5%
                                1.0, // at 100%
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Availability ",
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              SizedBox(
                                height: 28,
                                child: Obx(
                                  () => Switch(
                                    value: userVM.availability.value,
                                    onChanged: (val) {
                                      userVM.availability.value = val;
                                    },
                                    activeColor: AppColors.switchGreen,
                                    activeTrackColor:
                                        AppColors.switchGreen.withOpacity(.30),
                                    inactiveThumbColor: Colors.grey,
                                    inactiveTrackColor: Colors.grey.shade300,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 26.h,
                      width: 87.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.83.r),
                      ),
                      child: DropdownButton<String>(
                        value: serviceOption,
                        dropdownColor: AppColors.secondary,
                        hint: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select',
                              style: jost700(14.sp, AppColors.primary),
                            ),
                          ],
                        ),
                        isExpanded: false,
                        underline: SizedBox(),
                        icon: SizedBox.shrink(),
                        items: [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text(
                              'All',
                              style: jost700(14.sp, AppColors.primary),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Plumbing',
                            child: Text(
                              'Plumbing',
                              style: jost700(14.sp, AppColors.primary),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Gardening',
                            child: Text(
                              'Gardening',
                              style: jost700(14.sp, AppColors.primary),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            serviceOption = value;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return ['All', 'Plumbing', 'Gardening'].map((String value) {
                            return Container(
                              width: 87.w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value,
                                      style: jost400(11.sp, AppColors.secondary),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: AppColors.secondary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    Container(
                      height: 26.h,
                      width: 87.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.83.r),
                      ),
                      child: DropdownButton<String>(
                        value: selectedOption,
                        dropdownColor: AppColors.secondary,
                        hint: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select',
                              style: jost700(14.sp, AppColors.primary),
                            ),
                          ],
                        ),
                        isExpanded: false,
                        underline: SizedBox(),
                        icon: SizedBox.shrink(),
                        items: [
                          DropdownMenuItem(
                            value: 'Nearest',
                            child: Text(
                              'Nearest',
                              style: jost700(14.sp, AppColors.primary),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Newest',
                            child: Text(
                              'Newest',
                              style: jost700(14.sp, AppColors.primary),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Oldest',
                            child: Text(
                              'Oldest',
                              style: jost700(14.sp, AppColors.primary),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return ['Nearest', 'Newest', 'Oldest'].map((String value) {
                            return Container(
                              width: 87.w,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.w, right: 6.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value,
                                      style: jost400(11.sp, AppColors.secondary),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      color: AppColors.secondary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    )
                  ],
                ),

                Obx(() {
                  if (userVM.availability.value) {
                    return Column(
                      children: [
                        SizedBox(height: 120.h,),
                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "No Requests at the moment", // Message to show when off
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );

                    //   Column(
                    //   children: [

                    //     SizedBox(
                    //       height: 20.h,
                    //     ),
                    //     Container(
                    //       decoration: BoxDecoration(
                    //           color: AppColors.primary,
                    //           borderRadius: BorderRadius.circular(12.r),
                    //           border: Border.all(
                    //             color: Colors.transparent,
                    //             width: 0,
                    //           )),
                    //       child:
                    //           Column(mainAxisSize: MainAxisSize.min, children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Container(
                    //               height: 21.h,
                    //               width: 108.w,
                    //               decoration: BoxDecoration(
                    //                   color: AppColors.containerLightGrey,
                    //                   borderRadius: BorderRadius.only(
                    //                     topLeft: Radius.circular(10.5.r),
                    //                     bottomRight: Radius.circular(10.5.r),
                    //                   )),
                    //               alignment: Alignment.center,
                    //               child: Text(
                    //                 "New",
                    //                 style:
                    //                     montserrat600(11.sp, AppColors.primary),
                    //               ),
                    //             ),
                    //             Container(
                    //               height: 21.h,
                    //               width: 108.w,
                    //               decoration: BoxDecoration(
                    //                   color: AppColors.containerLightGrey,
                    //                   borderRadius: BorderRadius.only(
                    //                     topRight: Radius.circular(10.5.r),
                    //                     bottomLeft: Radius.circular(10.5.r),
                    //                   )),
                    //               alignment: Alignment.center,
                    //               child: Text(
                    //                 "Plumbing",
                    //                 style:
                    //                     montserrat600(11.sp, AppColors.primary),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 7.h,
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.symmetric(
                    //             horizontal: 10.w,
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Expanded(
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Text(
                    //                           "Jared Hughs",
                    //                           style: jost600(
                    //                               18.sp, AppColors.secondary),
                    //                         ),
                    //                         Text(
                    //                           "ID #2145",
                    //                           style: jost600(
                    //                               12.sp, AppColors.secondary),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     SizedBox(
                    //                       height: 6.h,
                    //                     ),
                    //                     Row(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       children: [
                    //                         Image.asset(
                    //                           AppImages.pinlocation,
                    //                           width: 15.w,
                    //                           height: 15.h,
                    //                         ),
                    //                         SizedBox(
                    //                           width: 3.w,
                    //                         ),
                    //                         Text(
                    //                           "Downtown Road, Dubai.",
                    //                           style: montserrat400(
                    //                               11.sp, AppColors.secondary),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     SizedBox(
                    //                       height: 6.h,
                    //                     ),
                    //                     Container(
                    //                       padding: EdgeInsets.all(10),
                    //                       decoration: BoxDecoration(
                    //                           color: AppColors.secondary,
                    //                           borderRadius:
                    //                               BorderRadius.circular(12.r)),
                    //                       child: Text(
                    //                         "I need to have my outdoor pipes fixed. We have a huge leakage in the valves and the wall fittings.",
                    //                         style: GoogleFonts.montserrat(
                    //                           fontSize: 9.sp,
                    //                           fontWeight: FontWeight.w500,
                    //                           color: AppColors.primary,
                    //                           height: 1,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: 20.w,
                    //               ),
                    //               Container(
                    //                 height: 82.h,
                    //                 width: 92.w,
                    //                 decoration: BoxDecoration(
                    //                     borderRadius:
                    //                         BorderRadius.circular(12.r),
                    //                     image: DecorationImage(
                    //                         image: AssetImage(
                    //                             AppImages.jared_hughs),
                    //                         fit: BoxFit.contain)),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 9.h,
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.symmetric(
                    //             horizontal: 10.w,
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Container(
                    //                 height: 35.h,
                    //                 padding: EdgeInsets.symmetric(
                    //                   horizontal: 8.w,
                    //                 ),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.white,
                    //                   borderRadius: BorderRadius.circular(12.r),
                    //                 ),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     SizedBox(
                    //                       child: Row(
                    //                         children: [
                    //                           MySvg(
                    //                               assetName: AppSvgs.calender),
                    //                           SizedBox(
                    //                             width: 8.w,
                    //                           ),
                    //                           Text(
                    //                             "Mon, Dec 23",
                    //                             style: montserrat600(
                    //                                 11.sp, AppColors.darkGrey),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       width: 45.w,
                    //                     ),
                    //                     SizedBox(
                    //                       child: Row(
                    //                         children: [
                    //                           MySvg(assetName: AppSvgs.clock),
                    //                           SizedBox(
                    //                             width: 8.w,
                    //                           ),
                    //                           Text(
                    //                             "12:00",
                    //                             style: montserrat600(
                    //                                 11.sp, AppColors.darkGrey),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: 15.w,
                    //               ),
                    //               Expanded(
                    //                 child: GestureDetector(
                    //                   onTap: () {
                    //                     Get.to(TaskDescriptionHome(
                    //                       comingFrom: "tech",
                    //                     ));
                    //                   },
                    //                   child: Container(
                    //                     height: 35.h,
                    //                     //  padding: EdgeInsets.symmetric(vertical: 12.h),
                    //                     decoration: BoxDecoration(
                    //                       color: Colors.white,
                    //                       borderRadius:
                    //                           BorderRadius.circular(12.r),
                    //                     ),
                    //                     alignment: Alignment.center,
                    //                     child: Text(
                    //                       "View",
                    //                       style:
                    //                           jost600(13.sp, AppColors.primary),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 10.h,
                    //         )
                    //       ]),
                    //     ),
                    //   ],
                    // );
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: 120.h,),
                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Please Switch the Available Button ON to start receiving new orders.", // Message to show when off
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
