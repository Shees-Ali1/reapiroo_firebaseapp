import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/post_controller.dart';
import '../booking_screens/today_screen_widgets/sparepart_dialogue_box.dart';
import 'components/bid_bottom_sheet.dart';
import 'components/cancel_dialog_box.dart';
import 'package:intl/intl.dart';

class NewTaskHome extends StatefulWidget {
  final Map<String, dynamic> taskData;

  const NewTaskHome({super.key, required this.taskData});

  @override
  State<NewTaskHome> createState() => _NewTaskHomeState();
}

class _NewTaskHomeState extends State<NewTaskHome> {

  final TechHomeController homeVM = Get.find<TechHomeController>();
  final UserController userVM = Get.put(UserController());
  final PostController postController = Get.put(PostController());
  final TextEditingController description = TextEditingController();
  DateTime? selectedDateTime;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _showDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 16.sp, // Larger font size for easier readability
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
  final AudioController audioVM = Get.find<AudioController>();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String audioUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"; // Replace with your audio URL

  late final VoiceController _voiceController;


  @override
  void initState() {
    super.initState();

    // Initialize the VoiceController here
    _voiceController = VoiceController(
      noiseCount: 50,
      audioSrc: audioUrl,
      maxDuration: Duration(seconds: 60),
      isFile: false,
      onComplete: () {
        // Handle audio complete
      },
      onPause: () {
        // Handle pause
      },
      onPlaying: () {
        // Handle playing state
      },
      onError: (err) {
        // Handle errors
      },
    );
  }

  @override
  void dispose() {
    // Dispose of VoiceController and AudioPlayer
    _voiceController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (audioVM.isPLaying.value) {
      await _audioPlayer.pause();
    } else {
      audioVM.isLoading.value = true;
      await _audioPlayer.play(UrlSource(audioUrl));
      audioVM.isLoading.value = false;
    }
    audioVM.isPLaying.value = !audioVM.isPLaying.value;
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ThemeData? theme, // Optional theme parameter
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??=
        initialDate.add(const Duration(days: 3)); // Restrict to 3 days ahead

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final String? currentUserUid = _auth.currentUser?.uid;

    final String title = widget.taskData['title'] ?? 'No Title';
    final String name = widget.taskData['name'] ?? 'No UserName';
    final String id = widget.taskData['id'] ?? 'No randomId';
    final String description = widget.taskData['description'] ?? 'No Description';
    final String? imageUrl = widget.taskData['imageUrl'];
    final String location = widget.taskData['location'] ?? 'Unknown Location';
    final DateTime dateTime = DateTime.parse(widget.taskData['dateTime']);
    final String voiceNoteUrl = widget.taskData['voiceNoteUrl'] ?? 'No Voice Note';
    final String userUid = widget.taskData['userUid'] ?? 'No userUid';
    print("userUiduserUidnewtasking$userUid");
    String descriptionText =
        description;
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
                Text(
                  title,                  style: jost700(24.sp, AppColors.primary),
                ),
                SizedBox(
                  height: 9.h,
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      height: 21.h,
                      padding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 5.w),
                      // width: 108.w,
                      decoration: BoxDecoration(
                          color: AppColors.containerLightGrey,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.5.r),
                            bottomRight: Radius.circular(10.5.r),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "In Progress",
                            style: montserrat600(11.sp, AppColors.primary),
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: _firestore.collection('tech_users').doc(currentUserUid).get(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Error fetching role.'));
                              }
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(child: Text('User data not found.'));
                              }

                              // Extract role from Firestore document
                              String role = snapshot.data!['role'] ?? '';

                              return role == 'Tech'
                                  ?  SizedBox.shrink()

                                  : Text(
                                "ID #2145",
                                style: jost600(12.sp, AppColors.primary),
                              );
                            },
                          ),


                          Text(
                            title,
                            style: montserrat600(11.sp, AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 13.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<DocumentSnapshot>(
                                  future: _firestore.collection('tech_users').doc(currentUserUid).get(),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(child: Text('Error fetching role.'));
                                    }
                                    if (!snapshot.hasData || !snapshot.data!.exists) {
                                      return Center(child: Text('User data not found.'));
                                    }

                                    // Extract role from Firestore document
                                    String role = snapshot.data!['role'] ?? '';

                                    return role == 'Tech'

                                        ?    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          name,
                                          style: jost600(
                                              18.sp, AppColors.secondary),
                                        ),
                                        Text(
                                          id,
                                          style: jost600(
                                              12.sp, AppColors.secondary),
                                        ),
                                      ],
                                    )
                                        : Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
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
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  "4 (15)",
                                                  style: jost600(12.sp,
                                                      AppColors.secondary),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),


                                SizedBox(
                                  height: 6.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      AppImages.pinlocation,
                                      width: 15.w,
                                      height: 15.h,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Text(
                                      location,
                                      style: montserrat400(
                                          11.sp, AppColors.secondary),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                // DescriptionWidget(),
                                GestureDetector(
                                  onTap: () => _showDialog(context, descriptionText),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      descriptionText,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                FutureBuilder<DocumentSnapshot>(
                                  future: _firestore.collection('tech_users').doc(currentUserUid).get(),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(child: Text('Error fetching role.'));
                                    }
                                    if (!snapshot.hasData || !snapshot.data!.exists) {
                                      return Center(child: Text('User data not found.'));
                                    }

                                    // Extract role from Firestore document
                                    String role = snapshot.data!['role'] ?? '';

                                    return role == 'Tech'


                                        ?   SizedBox.shrink()

                                        :  Container(
                                      padding: EdgeInsets.all(7.w),
                                      decoration: BoxDecoration(
                                          color: AppColors.secondary,
                                          borderRadius:
                                          BorderRadius.circular(10.r)),
                                      child: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        'Price: 60.00 AED',
                                        style: jost400(12.sp, AppColors.primary),
                                      ),
                                    );
                                  },
                                ),

                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16.w),
                            height: 110.h,
                            width: 85.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.w),
                              image:DecorationImage(
                                image: NetworkImage(imageUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 35.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                              ),
                              decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                      color: Colors.transparent, width: 0)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        MySvg(assetName: AppSvgs.calender),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Text(
                                          DateFormat('EEE, MMM d').format(dateTime), // Format date
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
                                          DateFormat('hh:mm a').format(dateTime), // Format time
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
                                barrierDismissible:
                                true, // Allows dialog dismissal on outside tap
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.all(16),
                                    child: Center(
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 24.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(16.r),
                                        ),
                                        child: SparepartDialogueBox(),
                                      ),
                                    ),
                                  );
                                },
                              );

                            },
                            child:
                            FutureBuilder<DocumentSnapshot>(
                              future: _firestore.collection('tech_users').doc(currentUserUid).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error fetching role.'));
                                }
                                if (!snapshot.hasData || !snapshot.data!.exists) {
                                  return Center(child: Text('User data not found.'));
                                }

                                // Extract role from Firestore document
                                String role = snapshot.data!['role'] ?? '';

                                return role == 'Tech'

                                    ?     Container(
                                  width: 98.w,
                                  height: 35.h,
                                  margin: EdgeInsets.only(left: 16.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Main Row with the "Spare parts" text
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Spare parts",
                                            style: jost600(13.sp, AppColors.primary),
                                          ),
                                        ],
                                      ),

                                      // Red dot indicator
                                      Positioned(
                                        top: -12,  // Adjust to position the dot
                                        right: 5, // Adjust to position the dot
                                        child: Container(
                                          width: 10,  // Size of the red dot
                                          height: 10, // Size of the red dot
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : SizedBox.shrink();
                              },
                            ),

                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),

                    /// Video Player
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 14.w),
                          alignment: Alignment.center,
                          height: 189.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12.r), // Match the container's radius
                            child: AspectRatio(
                              aspectRatio: 16 /
                                  9, // Replace this with your video’s actual aspect ratio
                              child: VideoPlayer(
                                videoUrl: 'assets/video/videotest.mp4',
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4.h,
                          left: 14.w,
                          child: Container(
                            height: 28.h,
                            width: 68.w,
                            decoration: BoxDecoration(
                                color: AppColors.containerLightGrey,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.5.w),
                                  bottomRight: Radius.circular(10.5.w),
                                )),
                            alignment: Alignment.center,
                            child: Text(
                              "Video",
                              style: montserrat400(11.sp, AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width * 0.82,
                            child: VoiceMessageView(
                              size: 40,
                              backgroundColor: Colors.black,
                              activeSliderColor: Colors.white,
                              circlesColor: Colors.white,
                              playPauseButtonLoadingColor: AppColors.primary,
                              playIcon: Icon(Icons.play_arrow, size: 30.w, color: Colors.black,),
                              pauseIcon: Icon(Icons.pause, size: 30.w, color: Colors.black,),
                              circlesTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),

                              counterTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              controller: _voiceController,
                              innerPadding: 0,
                              cornerRadius: 20,
                              // waveformHeight: 60,
                            ),
                          ),


                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ]),
                ),
                SizedBox(height: 32.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      width: 160.w,
                      height: 51.h,
                      text: "Bid",
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.secondary,
                      fontSize: 19.sp,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40.w),
                            ),
                          ),
                          builder: (context) => BidBottomSheet(
                            userUid: userUid,
                          ),
                        );
                      },                      // enabled: false, // Uncomment to disable the button
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
