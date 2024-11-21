import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/svg_icons.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/views/home_screens_for_customers/search_offer_screen.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';
import 'package:repairoo/widgets/my_svg.dart';

import '../../controllers/servicecontroller.dart';

class CustomerTaskHome extends StatefulWidget {
  const CustomerTaskHome({super.key, this.service});

  final String? service;

  @override
  State<CustomerTaskHome> createState() => _CustomerTaskHomeState();
}

class _CustomerTaskHomeState extends State<CustomerTaskHome> {
  final HomeController customerVM = Get.find<HomeController>();
  final ServiceController serviceController = Get.find<ServiceController>();
  final TextEditingController task = TextEditingController();
  final TextEditingController voice = TextEditingController();
  FlutterSoundRecorder? _recorder;
  File? _audioFile;
  bool _isRecording = false;
  double _progressValue = 0.0; // Value from 0.0 to 1.0
  Timer? _progressTimer;
  RxString location = ''.obs;  // To capture location input

  XFile? imageFile;


  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _openRecorder();
  }

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder!.openRecorder();
  }

  Future<void> _startRecording() async {
    String path = '/sdcard/Download/audio_recording.aac';

    await _recorder?.startRecorder(toFile: path);

    setState(() {
      _isRecording = true;
      _progressValue = 0.0; // Reset progress when starting a new recording
    });

    // Start a timer that updates the progress every 100 milliseconds over 1 minute
    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _progressValue +=
            100 / 60000; // Increment progress based on 1 minute (60,000 ms)
      });

      if (_progressValue >= 1.0) {
        _stopRecording(); // Automatically stop recording when time is up
      }
    });
  }

  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    _progressTimer?.cancel(); // Cancel the timer
    setState(() {
      _isRecording = false;
      _progressValue = 0.0; // Reset progress indicator
    });
  }
  DateTime? selectedDateTime;


  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ThemeData? theme, // Optional theme parameter
  })
  async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= initialDate.add(const Duration(days: 3)); // Restrict to 3 days ahead

    // Show time picker first with theme
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.red,
            bannerTheme: MaterialBannerThemeData(backgroundColor: Colors.red),
            timePickerTheme: TimePickerThemeData(
                dialBackgroundColor: AppColors.textFieldGrey),
            primaryColor: Colors.black, // Background color
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white, // Time color
              secondary: Colors.black, // AM/PM color
              onSecondary: Colors.white, // Button text color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.normal, // Button text color
            ),
          ), // Apply provided theme or default
          child: child ?? SizedBox(),
        );
      },
    );

    // If no time is selected, return null
    if (selectedTime == null) {
      return null; // User did not pick a time
    }

    // Show date picker after time picker with theme
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.primary,
            primaryColor: Colors.black, // Background color
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white, // Time color
              secondary: Colors.black, // AM/PM color
              onSecondary: Colors.white, // Button text color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.normal, // Button text color
            ),
          ), // Apply provided theme or default
          child: child ?? SizedBox(),
        );
      },
    );

    // If no date is selected, return time with default date
    if (selectedDate == null) {
      return DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ); // Use initialDate if date is not picked
    }

    // Combine date and time
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }
  Future<void> _pickDateTime() async {
    DateTime? dateTime = await showDateTimePicker(
      context: context,
      theme: ThemeData.light(), // Optional: Pass a custom theme if desired
    );

    // Update selectedDateTime if a date and time was picked
    if (dateTime != null) {
      setState(() {
        selectedDateTime = dateTime;
      });
    }
  }
  String getFormattedDateTime() {
    if (selectedDateTime == null) return "Select Date & Time";
    return DateFormat('MM/dd/yyyy hh:mm a').format(selectedDateTime!);
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    _progressTimer?.cancel();
    super.dispose();
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
          isTextField: false,
          isSecondIcon: false,
          title: "Task Description",
          onBackTap: () {
            Get.back();
          },
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.5.w),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      widget.service ?? "",
                      style: jost700(24.sp, AppColors.primary),
                    ),
                    SizedBox(
                      height: 13.w,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 6.h),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFA),
                        border: Border.all(color: const Color(0xffE2E2E2), width: 1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child:
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Reactive widget for handling images
                              Obx(() {
                                if (serviceController.images.isEmpty) {
                                  return InkWell(
                                    onTap: serviceController.pickImagesFromGallery,
                                    child: Container(
                                      height: 30.h,
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8.w),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(AppImages.upload, height: 18.h, width: 18.w),
                                          SizedBox(width: 8.w),
                                          Text("Upload Image", style: sora600(10.sp, AppColors.secondary)),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Wrap(
                                    spacing: 8.w,
                                    children: serviceController.images.map((image) {
                                      return GestureDetector(
                                        onTap: () => serviceController.removeImage(image),
                                        child: Container(
                                          height: 30.h,
                                          width: 30.w,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(image),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Icon(Icons.close, color: Colors.red, size: 16.sp),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                              }),
                              SizedBox(width: 10.w),
                              // Reactive widget for handling videos
                              Obx(() {
                                if (serviceController.videos.isEmpty) {
                                  return InkWell(
                                    onTap: serviceController.pickVideosFromGallery,
                                    child: Container(
                                      height: 30.h,
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8.w),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.video_collection, size: 18.h, color: Colors.white),
                                          SizedBox(width: 8.w),
                                          Text("Upload Video", style: sora600(10.sp, AppColors.secondary)),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Wrap(
                                    spacing: 8.w,
                                    children: serviceController.videos.map((video) {
                                      return GestureDetector(
                                        onTap: () => serviceController.removeVideo(video),
                                        child: Container(
                                          height: 30.h,
                                          width: 30.w,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Icon(Icons.close, color: Colors.red, size: 16.sp),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                              }),
                            ],
                          ),
                          SizedBox(height: 10.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Button for capturing a photo
                              InkWell(
                                onTap: serviceController.takePhoto,
                                child: Container(
                                  height: 30.h,
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.camera_alt, color: Colors.white, size: 18.h),
                                      SizedBox(width: 8.w),
                                      Text("Take Photo", style: sora600(10.sp, AppColors.secondary)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Button for recording a video
                              InkWell(
                                onTap: serviceController.recordVideo,
                                child: Container(
                                  height: 30.h,
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.videocam, color: Colors.white, size: 18.h),
                                      SizedBox(width: 8.w),
                                      Text("Record Video", style: sora600(10.sp, AppColors.secondary)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Obx(() {
                            // Display a preview of the first image or video, if available
                            if (serviceController.images.isNotEmpty) {
                              return Container(
                                margin: EdgeInsets.only(top: 15.h),
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(serviceController.images.first),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              );
                            } else if (serviceController.videos.isNotEmpty) {
                              return Container(
                                margin: EdgeInsets.only(top: 15.h),
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Icon(Icons.video_collection, size: 40.h, color: Colors.white),
                                ),
                              );
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  'No Image/Video Selected',
                                  style: jost400(12.sp, const Color(0xff6B7280)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }),
                        ],
                      )

                      // Column(
                      //   children: [
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Obx(() {
                      //           return Row(
                      //             children: [
                      //               // For images
                      //               if (serviceController.images.isEmpty)
                      //                 InkWell(
                      //                   onTap: serviceController.pickImagesFromGallery,
                      //                   child: Container(
                      //                     height: 30.h,
                      //                     padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                      //                     decoration: BoxDecoration(
                      //                       color: AppColors.primary,
                      //                       borderRadius: BorderRadius.circular(8.w),
                      //                     ),
                      //                     alignment: Alignment.center,
                      //                     child: Row(
                      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Image.asset(AppImages.upload, height: 18.h, width: 18.w),
                      //                         SizedBox(width: 8.w),
                      //                         Text("Upload Image", style: sora600(10.sp, AppColors.secondary)),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 )
                      //               else
                      //                 Stack(
                      //                   children: serviceController.images.map((image) {
                      //                     return GestureDetector(
                      //                       onTap: () => serviceController.removeImage(image),
                      //                       child: Container(
                      //                         margin: EdgeInsets.only(right: 10.w),
                      //                         height: 30.h,
                      //                         width: 30.w,
                      //                         decoration: BoxDecoration(
                      //                           image: DecorationImage(
                      //                             image: FileImage(image),
                      //                             fit: BoxFit.cover,
                      //                           ),
                      //                           borderRadius: BorderRadius.circular(4.r),
                      //                         ),
                      //                         child: Icon(Icons.close, color: Colors.red, size: 16.sp),
                      //                       ),
                      //                     );
                      //                   }).toList(),
                      //                 ),
                      //               SizedBox(width: 10.w),
                      //               // For videos
                      //               if (serviceController.videos.isEmpty)
                      //                 InkWell(
                      //                   onTap: serviceController.pickVideosFromGallery,
                      //                   child: Container(
                      //                     height: 30.h,
                      //                     padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                      //                     decoration: BoxDecoration(
                      //                       color: AppColors.primary,
                      //                       borderRadius: BorderRadius.circular(8.w),
                      //                     ),
                      //                     alignment: Alignment.center,
                      //                     child: Row(
                      //                       mainAxisAlignment: MainAxisAlignment.center,
                      //                       children: [
                      //                         Icon(Icons.video_collection, size: 18.h, color: Colors.white),
                      //                         SizedBox(width: 8.w),
                      //                         Text("Upload Video", style: sora600(10.sp, AppColors.secondary)),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 )
                      //               else
                      //                 Stack(
                      //                   children: serviceController.videos.map((video) {
                      //                     return GestureDetector(
                      //                       onTap: () => serviceController.removeVideo(video),
                      //                       child: Container(
                      //                         margin: EdgeInsets.only(right: 10.w),
                      //                         height: 30.h,
                      //                         width: 30.w,
                      //                         decoration: BoxDecoration(
                      //                           color: Colors.black,
                      //                           borderRadius: BorderRadius.circular(4.r),
                      //                         ),
                      //                         child: Icon(Icons.close, color: Colors.red, size: 16.sp),
                      //                       ),
                      //                     );
                      //                   }).toList(),
                      //                 ),
                      //             ],
                      //           );
                      //         }),
                      //       ],
                      //     ),
                      //
                      //     Obx(() {
                      //       // Display a preview of the first image or video, if available
                      //       if (serviceController.images.isNotEmpty) {
                      //         return Container(
                      //           margin: EdgeInsets.only(top: 15.h),
                      //           height: 100.h,
                      //           width: 100.w,
                      //           decoration: BoxDecoration(
                      //             image: DecorationImage(
                      //               image: FileImage(serviceController.images.first),
                      //               fit: BoxFit.cover,
                      //             ),
                      //             borderRadius: BorderRadius.circular(8.r),
                      //           ),
                      //         );
                      //       } else if (serviceController.videos.isNotEmpty) {
                      //         return Container(
                      //           margin: EdgeInsets.only(top: 15.h),
                      //           height: 100.h,
                      //           width: 100.w,
                      //           decoration: BoxDecoration(
                      //             color: Colors.black,
                      //             borderRadius: BorderRadius.circular(8.r),
                      //           ),
                      //           child: Center(
                      //             child: Icon(Icons.video_collection, size: 40.h, color: Colors.white),
                      //           ),
                      //         );
                      //       }
                      //       return Center(
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(top: 10.0),
                      //           child: Text(
                      //             'No Image/Video Selected',
                      //             style: jost400(12.sp, const Color(0xff6B7280)),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      //   ],
                      // )
                    ),
                    Container(
                      height: 55.h,
                      margin: EdgeInsets.only(bottom: 6.h),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: Color(0xffFAFAFA),
                        border: Border.all(color: Color(0xffE2E2E2), width: 1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select location"),
                          Container(
                              height: 30.h,
                              width: 150.w,  // Adjust width to fit text input and button
                              child:
                              TextField(
                                onChanged: (value) {
                                  // Update the location value in the controller
                                  Get.find<LocationController>().updateLocation(value);
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15.w, bottom: 0.h),
                                  hintText: 'Enter Location',
                                  hintStyle: TextStyle(color: AppColors.buttonGrey),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.w),
                                    borderSide: BorderSide(color: Color(0xffE2E2E2), width: 1),
                                  ),
                                ),

                              )


                          ),
                          // Container(
                          //   height: 30.h,
                          //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                          //   decoration: BoxDecoration(
                          //       color: AppColors.primary,
                          //       borderRadius: BorderRadius.circular(8.w)),
                          //   alignment: Alignment.center,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Image.asset(AppImages.location_icon,
                          //           height: 15.h, width: 15.w),
                          //       SizedBox(width: 9.w),
                          //       Text("Select on Maps", style: sora600(10.sp, AppColors.secondary)),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      height: 55.h,
                      margin: EdgeInsets.only(bottom: 6.h),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: Color(0xffFAFAFA),
                        border: Border.all(color: Color(0xffE2E2E2), width: 1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getFormattedDateTime()), // Display formatted date and time
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _pickDateTime,
                                child: Container(
                                  width: 73.w,
                                  height: 30.h,
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Now",
                                    style: sora600(10.sp, AppColors.secondary),
                                  ),
                                ),
                              ),
                              Container(
                                width: 73.w,
                                height: 30.h,
                                margin: EdgeInsets.only(left: 8.w),
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.buttonGrey,
                                  borderRadius: BorderRadius.circular(8.w),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Later",
                                  style: sora600(10.sp, AppColors.secondary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Obx(
                          () => Container(
                        height: customerVM.uploadSpareParts.value ? 130.h : 55.h,
                        margin: EdgeInsets.only(bottom: 6.h),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: Color(0xffFAFAFA),
                          border: Border.all(color: Color(0xffE2E2E2), width: 1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Do you need spare parts?"),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        customerVM.uploadSpareParts.value = true;
                                      },
                                      child: Container(
                                        width: 52.w,
                                        height: 30.h,
                                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.buttonGrey,
                                          borderRadius: BorderRadius.circular(8.w),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Yes",
                                          style: sora600(10.sp, AppColors.secondary),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        customerVM.uploadSpareParts.value = false;
                                      },
                                      child: Container(
                                        width: 52.w,
                                        height: 30.h,
                                        margin: EdgeInsets.only(left: 8.w),
                                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(8.w),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "No",
                                          style: sora600(10.sp, AppColors.secondary),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (customerVM.uploadSpareParts.value) ...[
                              SizedBox(height: 17.h),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Upload Picture/Video"),
                                      Container(
                                        height: 30.h,
                                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(8.w),
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(AppImages.upload, height: 18.h, width: 18.w),
                                            SizedBox(width: 8.w),
                                            Text(
                                              "Upload    ",
                                              style: sora600(10.sp, AppColors.secondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "Spare Parts cost is NOT included in the offers, as technician will attach a proof of invoice for you to pay after he buys it",
                                    style: jost400(10.sp, Color(0xff4B4B4B)),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    // CustomInputField(controller: voice,hintText: 'Record Voice Note',),
                    Container(
                      height: 55.h,
                      margin: EdgeInsets.only(bottom: 6.h),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: Color(0xffFAFAFA),
                        border: Border.all(color: Color(0xffE2E2E2), width: 1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Obx(() {
                        if (serviceController.isRecording.value) {
                          // Recording State
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recording... ${serviceController.recordingDuration.value}s",
                                style: TextStyle(fontSize: 14.sp, color: Colors.black),
                              ),
                              CircularProgressIndicator(
                                value: serviceController.progressValue.value,
                                strokeWidth: 2,
                              ),
                              IconButton(
                                icon: Icon(Icons.stop, color: Colors.red),
                                onPressed: serviceController.stopRecording,
                              ),
                            ],
                          );
                        } else if (serviceController.voiceNoteUrl.value != null) {
                          // Recorded Voice Note State
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Voice Note Recorded",
                                style: TextStyle(fontSize: 14.sp, color: Colors.black),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.play_arrow, color: Colors.green),
                                    onPressed: serviceController.playVoiceNote,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: serviceController.deleteVoiceNote,
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          // Default State
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Record Voice Note",
                                style: TextStyle(fontSize: 14.sp, color: Colors.black),
                              ),
                              IconButton(
                                icon: Icon(Icons.mic, color: Colors.black),
                                onPressed: serviceController.recordVoiceNote,
                              ),
                            ],
                          );
                        }
                      }),
                    ),

                    CustomInputField(
                      maxLines: 4,
                      controller: task,
                      hintText: 'Describe your task',
                      onChanged: (value) {
                        serviceController.taskDescription.value = value; // Update observable
                      },
                    ),
                    SizedBox(
                      height: 72.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                      child: Obx(() {
                        return CustomElevatedButton(
                          text: serviceController.isLoading.value ? "" : "Next", // Show text when not loading
                          onPressed: () async {
                            // Check if at least one image or video is selected
                            if (serviceController.images.isEmpty && serviceController.videos.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please select at least one image or video before proceeding.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            // Set isLoading to true to show the loading indicator
                            serviceController.isLoading.value = true;

                            // Save data before navigating
                            final isSuccess = await serviceController.saveDataToCollection(
                              title: widget.service!, // Replace with your actual service title
                              selectedDateTime: DateTime.now(), // Pass the selected date or use the current time
                              imageFiles: serviceController.images, // Pass the list of selected images
                              videoFiles: serviceController.videos, // Pass the list of selected videos
                            );

                            // Reset isLoading after the operation
                            serviceController.isLoading.value = false;

                            // Navigate on success or show error message
                            if (isSuccess) {
                              Get.to(SearchOfferScreen(field: widget.service!)); // Replace with your actual screen navigation
                            } else {
                              Get.snackbar(
                                "Error",
                                "Failed to save data. Please try again.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          fontSize: 19.sp,
                        );
                      }),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}