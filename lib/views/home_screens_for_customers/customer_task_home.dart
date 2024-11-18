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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Upload Picture/Video"),
                            Obx(() {
                              final imageFile = serviceController.imageFile.value;
                              return imageFile == null
                                  ? InkWell(
                                onTap: serviceController.pickImageFromGallery,
                                child: Container(
                                  height: 30.h,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius:
                                      BorderRadius.circular(8.w)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AppImages.upload,
                                          height: 18.h, width: 18.w),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        "Upload    ",
                                        style:
                                        sora600(10.sp, AppColors.secondary),
                                      )
                                    ],
                                  ),
                                ),
                              )
                                  : GestureDetector(
                                onTap: serviceController.removeImage,
                                child: Icon(Icons.close, color: Colors.red),
                              );
                            }),
                          ],
                        ),
                        Obx(() {
                          final imageFile = serviceController.imageFile.value;
                          return imageFile != null
                              ? Container(
                            margin: EdgeInsets.only(top: 15.h),
                            height: 100.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          )
                              : Center(
                            child: Text(
                              'No Image Selected',
                              style: jost400(12.sp, const Color(0xff6B7280)),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),
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
                        Text("Select location"),
                        Container(
                          height: 30.h,
                          width: 100.w,  // Adjust width to fit text input and button
                          child:
                            TextField(
                            onChanged: (value) {
                              // Update the location value in the controller
                              Get.find<LocationController>().updateLocation(value);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15.w, bottom: 0.h),
                              hintText: 'Enter Location',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Record Voice Note',
                          style: TextStyle(fontSize: 14.sp, color: Colors.black),
                        ),
                        Obx(() => IconButton(
                          icon: Icon(
                            serviceController.isRecording.value ? Icons.stop : Icons.mic,
                          ),
                          onPressed: serviceController.isRecording.value
                              ? serviceController.stopRecording
                              : serviceController.recordVoiceNote,
                          color: serviceController.isRecording.value ? Colors.red : Colors.black,
                        )),
                        Obx(() => serviceController.isRecording.value
                            ? CircularProgressIndicator(
                          value: serviceController.progressValue.value,
                          strokeWidth: 2,
                        )
                            : Container()),
                      ],
                    ),
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
                    child: CustomElevatedButton(
                      text: "Next",
                      onPressed: () async {
                        // Ensure an image is selected before attempting to save
                        if (serviceController.imageFile.value == null) {
                          Get.snackbar(
                            "Error",
                            "Please select an image before proceeding.",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        // Save data before navigating
                        final isSuccess = await serviceController.saveDataToCollection(
                          title: widget.service!,  // Title being passed to saveDataToCollection
                          imageFile: serviceController.imageFile.value, // Pass the imageFile here
                        );

                        if (isSuccess) {
                          // Navigate to the next screen if save is successful
                          Get.to(SearchOfferScreen(field: widget.service!));
                        } else {
                          // Show an error if save failed
                          Get.snackbar(
                            "Error",
                            "Failed to save data. Please try again.",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      fontSize: 19.sp,
                    ),
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
