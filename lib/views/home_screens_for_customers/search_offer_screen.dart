import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/views/home_screen_for_tech/components/cancel_dialog_box.dart';
import 'package:repairoo/views/home_screens_for_customers/components/offer_container.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SearchOfferScreen extends StatefulWidget {
  const SearchOfferScreen({super.key, required this.field});

  final String field;

  @override
  _SearchOfferScreenState createState() => _SearchOfferScreenState();
}

class _SearchOfferScreenState extends State<SearchOfferScreen> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Start auto-sliding every 5 seconds

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  Stream<List<Map<String, dynamic>>> fetchOffersStream(String taskId) {
    print('Fetching offers for taskId: $taskId');

    // Create a query for the 'bids' collection
    Query query = FirebaseFirestore.instance.collection('bids');

    // Apply a filter if taskId is not "All"
    if (taskId != "All") {
      print("Applying filter for taskId: $taskId");
      query = query.where('title', isEqualTo: taskId); // No need for capitalize unless explicitly needed
    }

    // Debug: Fetch all documents to check data in the collection
    FirebaseFirestore.instance.collection('bids').get().then((snapshot) {
      print("All documents in 'bids' collection:");
      for (var doc in snapshot.docs) {
        print("Document ID: ${doc.id}, Data: ${doc.data()}");
      }
    });

    return query.snapshots().map((snapshot) {
      print('Snapshot received: ${snapshot.docs.length} docs');

      return snapshot.docs.map((doc) {
        // Check and log document data
        final data = doc.data() as Map<String, dynamic>;
        print('Document ID: ${doc.id}, Data: $data');

        // Check if title exists in the document
        final firestoreTitle = data['title'] ?? "N/A";
        print('Firestore title: $firestoreTitle');

        return {
          'image': AppImages.natalie_hales, // Example static image
          'name': data['firstName'] ?? "Bidder", // Using bidder's first name
          'experience': "Bidder's experience details", // Example experience
          'rating': "4", // Static rating (adjust as needed)
          'price': data['bidAmount']?.toString() ?? "N/A", // Using bid amount
          'reviews': "0", // Static reviews (adjust as needed)
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        isSecondIcon: false,
        title: widget.field.capitalize,
        onBackTap: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child:
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: fetchOffersStream(widget.field), // Pass the field as taskId
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 20.h),
                    Text(
                      "We're working on your requests and connecting you with the nearest Technicians. Please wait.",
                      style: jost400(16.sp, AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Failed to load offers. Please try again later.",
                  style: jost400(16.sp, AppColors.primary),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final offers = snapshot.data ?? [];

            return offers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCircle(
                    color: AppColors.primary,
                    size: 100.0,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "We're working on your requests and connecting you with the nearest Technicians. Please wait.",
                    style: jost400(16.sp, AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Searching best offer",
                          style: jost700(24.sp, AppColors.primary),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(9.w),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Lowest price",
                                style:
                                jost400(10.sp, AppColors.secondary),
                              ),
                              SizedBox(width: 1.w),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 20.w,
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: index != 0 ? 10.0.w : 0),
                          child: OfferContainer(
                            image: offers[index]['image'],
                            name: offers[index]['name'],
                            experience: offers[index]['experience'],
                            price: offers[index]['price'],
                            rating: offers[index]['rating'],
                            reviews: offers[index]['reviews'],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 26.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                      child: CustomElevatedButton(
                        text: "Cancel",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColors.secondary,
                                contentPadding: EdgeInsets.zero,
                                content: CancelDialogBox(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}