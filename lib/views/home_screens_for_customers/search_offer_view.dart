import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/views/home_screen_for_tech/components/bid_bottom_sheet.dart';
import 'package:repairoo/views/home_screens_for_customers/components/job_accepted_bottomsheet.dart';
import 'package:repairoo/views/home_screens_for_customers/search_offer_screen.dart';
import 'package:repairoo/widgets/app_bars.dart';

import '../customerbidnotify.dart';

class SearchOfferView extends StatefulWidget {
  const SearchOfferView({super.key, required this.name, required this.image, required this.experience, required this.price, required this.rating, required this.reviews, required this.skills});

  final String image;
  final String name;
  final String experience;
  final String price;
  final String rating;
  final String reviews;
  final List<String> skills;

  @override
  State<SearchOfferView> createState() => _SearchOfferViewState();
}

class _SearchOfferViewState extends State<SearchOfferView> {

  String selectedRating = "5 stars"; // Default selection for dropdown

  // Mockup reviews data for each rating
  final Map<String, List<Map<String, String>>> reviewsData = {
    "5 stars": [

      {
        "name": "John Doe",
        "date": "July 12, 2023",
        "comment": "Amazing platform with great learning tools!",
      },
    ],
    "4 stars": [
      {
        "name": "Jane Smith",
        "date": "June 18, 2023",
        "comment": "Very good but could use more variety in resources.",
      },
    ],
    "3 stars": [
      {
        "name": "Alex Johnson",
        "date": "May 3, 2023",
        "comment": "Decent platform but I faced some technical issues.",
      },
    ],
    "2 stars": [
      {
        "name": "Lily Brown",
        "date": "April 20, 2023",
        "comment": "Not as expected. Needs improvement.",
      },
    ],
    "1 star": [
      {
        "name": "Samuel Green",
        "date": "March 11, 2023",
        "comment": "Poor experience. Wouldn't recommend.",
      },
    ],
  };

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
        isTextField: false,
        title: widget.name,
        onBackTap: (){
          Get.back();
        },
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 13.0.w),
          child: Column(
            children: [
              SizedBox(height: 8.h,),
              SizedBox(
                height: 82.h,
                child: Row(
                  children: [
                    Container(
                      width: 90.w,
                      height: 76.h,
                      margin: EdgeInsets.only(right: 9.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.w),
                          image: DecorationImage(image: AssetImage(widget.image), fit: BoxFit.fill)
                      ),
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name, style: jost600(16.sp, AppColors.primary),),
                        SizedBox(height: 3.h,),
                        Text(widget.experience, style: jost500(10.sp, AppColors.primary),),
                        Spacer(),
                        RichText(text: TextSpan(
                            children: [
                              TextSpan(text: widget.price, style: jost600(24.sp, AppColors.primary)),
                              TextSpan(text: "AED",style: jost(13.sp, AppColors.primary, FontWeight.w300))
                            ]
                        )),

                      ],
                    ))
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20.h, bottom: 15.h),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skills",
                      style: jost600(14.sp, AppColors.primary),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: widget.skills.map((skill) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            skill,
                            style: jost500(12.sp, AppColors.secondary),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.only(top: 28.h, bottom: 21.h),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                            (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Image.asset(
                            index < 4
                                ? AppImages.star_yellow  // Example: solid star icon
                                : AppImages.star_grey, // Show empty star for 4 out of 5 rating
                            height: 36.h,
                            width: 36.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4 out of 5',
                          style: jost500(
                            14.sp,
                            AppColors.buttontext,
                          ),
                        ),
                        Text(
                          '15 reviews',
                          style: jost500(
                            14.sp,
                            AppColors.buttontext,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(
                  left: 13.47.w,
                  right: 13.47.w,
                  top: 11.97.h,
                ),
                decoration: BoxDecoration(
                    color: AppColors.containerLightGrey,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                        width: 1,
                        color: AppColors.textFieldGrey
                    )
                ),
                child: Column(children: reviewsData[selectedRating]!.map((review) {
                  return Padding(
                    padding:  EdgeInsets.only(bottom: 17.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20.w,
                              backgroundImage: AssetImage("assets/images/review_coments_image.png"), // Correct usage with AssetImage
                            ),

                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review['name']!,
                                  style: jost700(13.23.sp, AppColors.primary,),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Row(
                                      children: List.generate(
                                        5,
                                            (index) => Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 0.w), // Adjust right padding as needed
                                          child: Image.asset(
                                            index < int.parse(selectedRating[0])
                                                ? AppImages.star_yellow  // Example: solid star icon
                                                : AppImages.star_grey,
                                            height: 15.12.h,
                                            width: 15.12.w,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 8.w),
                                    Text(
                                      review['date']!,
                                      style: jost600(
                                        12.sp,
                                        AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          review['comment']!,
                          style: jost500(
                            13.sp,
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                ),
              ),
              SizedBox(height: 16.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: () async {
                        // Fetch the current user's UID from FirebaseAuth
                        final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

                        if (currentUserId == null) {
                          Get.snackbar("Error", "User not logged in.");
                          return;
                        }

                        // Get bid amount (price) from the widget
                        final String bidAmount = widget.price; // Assuming the bid amount is the widget's price
                        if (bidAmount.isEmpty) {
                          Get.snackbar("Error", "Bid amount cannot be empty.");
                          return;
                        }

                        try {
                          // Query the 'bids' collection to get all bids
                          final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                              .collection('bids')
                              .get();

                          print("Query Snapshot: ${querySnapshot.docs.length} documents found"); // Debugging: Print how many documents are returned

                          if (querySnapshot.docs.isEmpty) {
                            Get.snackbar("Error", "No bids found.");
                            return;
                          }

                          // Loop through the documents and store data to the 'booking' collection
                          for (var doc in querySnapshot.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            print("Bid Data: $data");  // Debug: Print the data for checking

                            // Store the bid data in the 'booking' collection
                            await FirebaseFirestore.instance.collection('booking').add({
                              'bidAmount': data['bidAmount'] ?? bidAmount,  // Default to widget price if no bidAmount in bid
                              'customerUid': currentUserId,
                              'vendorName': data['vendorName'] ?? widget.name,
                              'vendorRating': data['vendorRating'] ?? widget.rating,
                              'vendorExperience': data['vendorExperience'] ?? widget.experience,
                              'vendorReviews': data['vendorReviews'] ?? widget.reviews,
                              'timestamp': FieldValue.serverTimestamp(),
                              'bidderId': data['bidderId'] ?? '',  // Ensure bidderId is present
                              'taskId': data['taskId'] ?? '',  // Store taskId from bid document
                              'title': data['title'] ?? '',  // Store title from bid document
                              'firstName': data['firstName'] ?? '',  // Store firstName from bid document
                            });

                            // Debugging: Print confirmation for each stored document
                            print("Stored bid data in booking collection: ${data['bidderId']}");
                          }

                          // After storing all data in 'booking', you can proceed to remove the bid from the 'bids' collection
                          final String? bidDocId = querySnapshot.docs.first.id;
                          if (bidDocId != null) {
                            await FirebaseFirestore.instance.collection('bids').doc(bidDocId).delete();
                            print("Bid removed successfully from 'bids' collection");
                          }

                          // Show success message and open the bottom sheet after storing the bid data

                          // Open the bottom sheet after storing the bid data
                          Get.bottomSheet(
                            isScrollControlled: true,
                            isDismissible: true,
                            enableDrag: true,
                            JobAcceptedBottomsheet(
                              name: widget.name,
                              price: widget.price,
                            ),
                          );
                        } catch (e) {
                          print("Error occurred: $e");
                          Get.snackbar("Error", "Failed to complete job: $e");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        width: 149.w,
                        height: 56.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.w),
                          color: AppColors.primary,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Accept",
                          style: jost600(22.sp, AppColors.secondary),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: true,
                          CustomerrBidBottomSheet(comingFrom: "customer"),
                        );
                      },
                      child: Container(
                        width: 149.w,
                        height: 56.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(color: AppColors.secondary),
                          color: Color(0xffDDDDDD),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Bid",
                          style: jost600(22.sp, AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap: () async {
                  // Fetch the current user's UID from FirebaseAuth
                  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

                  if (currentUserId == null) {
                    Get.snackbar(
                      "Error",
                      "User not logged in.",
                      backgroundColor: AppColors.primary, // Snackbar color
                      colorText: Colors.white, // Snackbar text color
                    );
                    return;
                  }

                  try {
                    // Query the 'bids' collection to get all bids for the current user with a matching price
                    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                        .collection('bids')
                        .where('customerId', isEqualTo: currentUserId) // Assuming the current user is the customer
                        .where('bidAmount', isEqualTo: widget.price) // Filter bids by price
                        .get();

                    if (querySnapshot.docs.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "No bids found with the matching price.",
                        backgroundColor: AppColors.secondary, // Snackbar color
                        colorText: Colors.white, // Snackbar text color
                      );
                      return;
                    }

                    // Loop through the documents to find the matching bid and remove it
                    for (var doc in querySnapshot.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final String taskId = data['taskId']; // Get taskId from the bid document
                      final String bidderId = data['bidderId']; // Assuming 'bidderId' exists in the bid document
                      print("Bid Data: $data");  // Debug: Print the data for checking

                      // Remove the specific bid based on the document ID
                      await FirebaseFirestore.instance.collection('bids').doc(doc.id).delete();
                      print("Bid removed successfully from 'bids' collection");

                      // Add a notification about the bid rejection
                      await FirebaseFirestore.instance.collection('Bid Notifications').add({
                        'rejectedBy': currentUserId, // UID of the user who rejected the offer
                        'bidderId': bidderId,        // UID of the bidder whose bid is rejected
                        'taskId': taskId,            // Task ID associated with the bid
                        'bidAmount': widget.price,   // The bid amount that was rejected
                        'message': 'Your offer has been rejected by the customer', // Custom rejection message
                        'timestamp': FieldValue.serverTimestamp(), // Timestamp of the rejection
                      });

                      print("Bid rejection notification added successfully");

                      // Show confirmation message with appropriate background color
                      Get.snackbar(
                        "Rejected",
                        "Offer has been rejected successfully.",
                        backgroundColor: AppColors.primary, // Snackbar color
                        colorText: Colors.white, // Snackbar text color
                      );
                    }

                    // After rejecting, you can open any additional bottom sheets or perform further actions here
                  } catch (e) {
                    print("Error occurred: $e");
                    Get.snackbar(
                      "Error",
                      "Failed to reject offer: $e",
                      backgroundColor: AppColors.secondary, // Snackbar color
                      colorText: Colors.white, // Snackbar text color
                    );
                  }
                },
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.w),
                    border: Border.all(color: AppColors.secondary),
                    color: Colors.red,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Reject",
                    style: jost600(22.sp, AppColors.secondary),
                  ),
                ),
              )

            ],
          ),
        ),
      )),
    );
  }
}
