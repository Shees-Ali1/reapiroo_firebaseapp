import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/svg_icons.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/controllers/user_controller.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/audio_note.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/my_svg.dart';
import 'package:repairoo/widgets/video_player.dart';

import '../booking_screens/today_screen_widgets/sparepart_dialogue_box.dart';
import 'components/bid_bottom_sheet.dart';
import 'components/cancel_dialog_box.dart';

class NewTaskHome extends StatefulWidget {
  const NewTaskHome({super.key});

  @override
  State<NewTaskHome> createState() => _NewTaskHomeState();
}

class _NewTaskHomeState extends State<NewTaskHome> {

  final TechHomeController homeVM = Get.find<TechHomeController>();
  final UserController userVM = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        isSecondIcon: false,
        secondIcon: "",
        title: "New Task",
        onBackTap: (){
          Get.back();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h,),
                Text("Plumbing", style: jost700(24.sp, AppColors.primary),),
                SizedBox(height: 9.h,),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// New
                            Container(
                              height: 21.h,
                              width: 108.w,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(239, 239, 239, 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.5.r,),
                                  bottomRight: Radius.circular(10.5.r,),
                                ),
                              ),
                              child: Center(
                                child: Text('In Progress',style: jost600(
                                  10.56.sp,
                                  AppColors.darkGrey,
                                ),
                                ),
                              ),
                            ),
                            userVM.userRole.value == "Customer" ?
                            Text(
                              "ID #2145",
                              style:
                              jost600(12.sp, AppColors.secondary),
                            ):SizedBox.shrink(),
                            /// plumbing
                            Container(
                              height: 21.h,
                              width: 108.w,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(239, 239, 239, 1),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.5.r,),
                                  bottomLeft: Radius.circular(10.5.r,),
                                ),
                              ),
                              child: Center(
                                child: Text('Plumbing',style: jost600(
                                  10.56.sp,
                                  AppColors.darkGrey,
                                ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.w,vertical: 7.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        userVM.userRole.value == "Customer" ?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: 60.h,
                                                width: 60.w,
                                                child: Image.asset(
                                                  AppImages.saraprofile,
                                                )),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Jared Hughs",
                                                  style: jost600(
                                                      18.sp, AppColors.secondary),
                                                ),

                                                Row(

                                                  children: [
                                                    SizedBox(
                                                        height: 18.h,
                                                        width: 18.w,
                                                        child: Image.asset(
                                                            AppImages.star)),
                                                    SizedBox(width: 5.w,),
                                                    Text(
                                                      "4 (15)",
                                                      style: jost600(
                                                          12.sp, AppColors.secondary),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ):      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Jared Hughs',
                                              style:
                                              jost600(18.sp, AppColors.secondary),
                                            ),
                                            Text(
                                              "ID #2145",
                                              style:
                                              jost600(12.sp, AppColors.secondary),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(AppImages.pinlocation, width: 15.w, height: 15.h,),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              "Downtown Road, Dubai.",
                                              style: montserrat400(
                                                  11.sp, AppColors.secondary),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        Text(
                                          "I need to have my outdoor pipes fixed. We have a huge leakage in the valves and the wall fittings.",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.secondary,
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 16.w),
                                    height: 110.h,
                                    width: 98.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.r),
                                        image: DecorationImage(
                                            image: AssetImage(AppImages.jared_hughs),
                                            fit: BoxFit.fill)),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 9.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 35.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                MySvg(assetName: AppSvgs.calender),
                                                SizedBox(
                                                  width: 8.w,
                                                ),
                                                Text(
                                                  "Mon, Dec 23",
                                                  style: montserrat600(
                                                      11.sp, AppColors.darkGrey),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            child: Row(
                                              children: [
                                                MySvg(assetName: AppSvgs.clock),
                                                SizedBox(
                                                  width: 8.w,
                                                ),
                                                Text(
                                                  "12:00",
                                                  style: montserrat600(
                                                      11.sp, AppColors.darkGrey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true, // Allows dialog dismissal on outside tap
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.all(16),
                                            child: Center(
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondary,
                                                  borderRadius: BorderRadius.circular(16.r),
                                                ),
                                                child: SparepartDialogueBox(),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height:35.h ,
                                      width: 98.w,
                                      margin: EdgeInsets.only(left: 16.w),

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Center(child: Text("Spare Parts", style: jost600(13.sp, AppColors.primary),)),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                alignment: Alignment.center,
                                height: 189.h,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,

                                ),
                                clipBehavior: Clip.hardEdge,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r), // Match the container's radius
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9, // Replace this with your video’s actual aspect ratio
                                    child: VideoPlayer(
                                      videoUrl: 'assets/video/videotest.mp4',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              AudioNote(),
                              SizedBox(height: 7.h),
                            ],
                          ),
                        ),

                      ]
                  ),
                ),
                SizedBox(height: 32.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      width: 160.w,
                      height: 51.h,
                      text: "Reschedule",
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.secondary,
                      fontSize: 19.sp,
                      onPressed: () {
                        // Show message for rescheduling
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: FittedBox(child: Text("Reschedule Information")),
                            content: Text(
                                "Please contact the technician for that, you can always contact us for more help."),
                            actions: [
                              TextButton(
                                child: Text("OK",style: jost500(15.sp, AppColors.primary,)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      // enabled: false, // Disable the button
                    ),
                    CustomElevatedButton(
                      width: 160.w,
                      height: 51.h,
                      text: "Cancel",
                      backgroundColor: AppColors.buttonGrey,
                      textColor: AppColors.primary,
                      borderSide:
                      BorderSide(width: 0, color: Colors.transparent),
                      fontSize: 19.sp,
                      onPressed: () {
                        // Show message for canceling
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text("Cancel Information"),
                            content: Text(
                                "Cancelling the order is not allowed, please contact us for help."),
                            actions: [
                              TextButton(
                                child: Text("OK",style: jost500(15.sp, AppColors.primary,)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      // enabled: false, // Disable the button
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
