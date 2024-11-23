import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart' as vp;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/svg_icons.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/controllers/user_controller.dart';
import 'package:repairoo/views/chat_screens/chat_screen_main.dart';
import 'package:repairoo/views/home_screen_for_tech/components/cancel_dialog_box.dart';
import 'package:repairoo/views/home_screen_for_tech/main_home.dart';
import 'package:repairoo/views/home_screen_for_tech/new_task_home.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/audio_note.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';
import 'package:repairoo/widgets/my_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/video_player.dart';
import '../booking_screens/today_screen_widgets/sparepart_dialogue_box.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bookingscreenyech.dart';
import 'components/description_widget.dart';

class TaskDescriptionHome extends StatefulWidget {
  final Map<String, dynamic> taskData;

  const TaskDescriptionHome({super.key, required this.comingFrom,required this.taskData});

  final String comingFrom;

  @override
  State<TaskDescriptionHome> createState() => _TaskDescriptionHomeState();
}

class _TaskDescriptionHomeState extends State<TaskDescriptionHome> {
  final TechHomeController homeVM = Get.find<TechHomeController>();
  final PostController postController = Get.put(PostController());
  final TextEditingController description = TextEditingController();
  final UserController userVM = Get.put(UserController());
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
    final task = widget.taskData;
    final String title = task['title'] ?? 'No Title';
    final String name = task['userName'] ?? 'No userName';
    final String id = task['randomId'] ?? 'No randomId';
    final String description = task['taskDescription'] ?? 'No Description';
    final String? imageUrl = task['imageUrl'];
    final String location = task['location'] ?? 'Unknown Location';
    final DateTime dateTime = DateTime.parse(task['selectedDateTime']);
    // final task = widget.taskData;
    // final String title = task['title'] ?? 'No Title';
    // final String name = task['userName'] ?? 'No userName';
    // final String id = task['randomId'] ?? 'No randomId';
    // final String description = task['taskDescription'] ?? 'No Description';
    // final String? imageUrl = task['imageUrl'];
    // final String location = task['location'] ?? 'Unknown Location';
    // final DateTime dateTime = DateTime.parse(task['selectedDateTime']);
    final String voiceNoteUrl = task['voiceNoteUrl'] ?? 'No Voice Note';
    final String userUid = task['userUid'] ?? 'No Voice Note';
    final String videoUrl = task['videoUrl'] ?? 'No Voice Note';
    print('Video URL: $videoUrl');

    String descriptionText =
        description;
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        isSecondIcon: false,
        title: 'Task Description',
        onBackTap: () {
          Get.back();
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
                  height: 16.h,
                ),
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
                            borderRadius: BorderRadius.circular(12.r),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child:
                              VideoPlayerWidget(
                                videoUrl: videoUrl,
                                placeholderImage:imageUrl, // Provide your asset image path
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final Uri phoneUri = Uri(
                                    scheme: 'tel',
                                    path:
                                    '1234567890'); // Yahan apna phone number daalein
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  print("Could not launch $phoneUri");
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.w),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Call",
                                  style: jost600(13.sp, AppColors.primary),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(ChatsScreenMain());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.w),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Chat",
                                  style: jost600(13.sp, AppColors.primary),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.w),
                              ),
                              alignment: Alignment.center,
                              child: FittedBox(
                                child: Text(
                                  "Track on map",
                                  style: jost600(13.sp, AppColors.primary),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 20.h,
                ),
                FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('tech_users').doc(currentUserUid).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return Center(child: Text('Error fetching role.'));
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text('User data not found.'));
                    }

                    // Extract role from Firestore document
                    String role = snapshot.data!['role'] ?? '';

                    return role == 'Tech'
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomElevatedButton(
                          width: 160,
                          height: 51,
                          text: "Mark as done",
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.secondary,
                          fontSize: 19,
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              final String uid = user.uid; // Current user's UID

                              try {
                                // Saving status to Firebase
                                await FirebaseFirestore.instance.collection('status').add({
                                  'text': 'completed',
                                  'bidderId': uid,     // Current user's UID
                                  'customerId': uid,   // Same UID for this example
                                  'timestamp': FieldValue.serverTimestamp(), // Optional: time of update
                                });

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Status marked as completed!")),
                                );

                                // Navigate to the bookingTech page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => bookingTech()),
                                );

                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error saving status: $e")),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("User not logged in!")),
                              );
                            }
                          },
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
                            CancelDialogBox();
                          },
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        // Reschedule Button
                        CustomElevatedButton(
                          width: 160.w,
                          height: 51.h,
                          text: "Reschedule",
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.secondary,
                          fontSize: 19.sp,
                          onPressed: () {
                            // Show message for rescheduling
                            final String userUid = task['userUid'] ?? 'No userUid';
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: FittedBox(
                                    child: Text("Reschedule Information")),
                                content: Text(
                                    "Please contact the technician for that, you can always contact us for more help."),
                                actions: [
                                  TextButton(
                                    child: Text("OK",
                                        style: jost500(
                                          15.sp,
                                          AppColors.primary,
                                        )),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        // Cancel Button
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
                                    child: Text("OK",
                                        style: jost500(
                                          15.sp,
                                          AppColors.primary,
                                        )),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(
                  height: 26.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String placeholderImage; // Image to show if no video URL is provided

  const VideoPlayerWidget({
    required this.videoUrl,
    required this.placeholderImage,
    Key? key,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController? _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl.isNotEmpty && widget.videoUrl != 'No Voice Note') {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {}); // Refresh after initialization
        });
    } else {
      _controller = null; // No video
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
          _isPlaying = false;
        } else {
          _controller!.play();
          _isPlaying = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      // Show the placeholder image if no video or not initialized
      return Stack(
        children: [
          Image.network(
            widget.placeholderImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          if (widget.videoUrl.isEmpty || widget.videoUrl == 'No Voice Note')
            Center(
              child: Text(
                "No Video Available",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: vp.VideoPlayer(_controller!),
        ),
        GestureDetector(
          onTap: _togglePlayPause,
          child: Icon(
            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            color: Colors.white,
            size: 64.0,
          ),
        ),
      ],
    );
  }
}

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerWidget({required this.videoUrl, Key? key}) : super(key: key);
//
//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late vp.VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = vp.VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {}); // Refresh after initialization
//       })
//       ..play(); // Auto-play
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: vp.VideoPlayer(_controller), // Explicitly use the alias
//     )
//         : Center(child: CircularProgressIndicator());
//   }
// }
