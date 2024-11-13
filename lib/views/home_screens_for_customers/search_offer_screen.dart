import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/views/home_screen_for_tech/components/cancel_dialog_box.dart';
import 'package:repairoo/views/home_screens_for_customers/components/offer_container.dart';
import 'package:repairoo/widgets/app_bars.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchOfferScreen extends StatefulWidget {
  const SearchOfferScreen({super.key, required this.field});

  final String field;

  @override
  State<SearchOfferScreen> createState() => _SearchOfferScreenState();
}

class _SearchOfferScreenState extends State<SearchOfferScreen> {
  List<Map<String, dynamic>> dummy = [];
  final HomeController customerVM = Get.find<HomeController>();
  bool isLoading = true; // Variable to control loading state

  @override
  void initState() {
    super.initState();

    // Simulate loading data
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        dummy = [
          {
            "image": AppImages.natalie_hales,
            "name": "Natalie Hales",
            "experience": "10+ years of experience in ${widget.field}",
            "rating": "4",
            "price": "200",
            "reviews": "15"
          },
          {
            "image": AppImages.sara_jones,
            "name": "Sara Jones",
            "experience": "9+ years of experience in ${widget.field}",
            "rating": "4",
            "price": "120",
            "reviews": "15"
          },
          {
            "image": AppImages.natalie_hales,
            "name": "Ibrahim Zafar",
            "experience": "14+ years of experience in ${widget.field}",
            "rating": "4.5",
            "price": "140",
            "reviews": "25"
          },
        ];
        isLoading = false; // Stop loading
      });
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
        child: isLoading
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
                            style: jost400(10.sp, AppColors.secondary),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 20.w,
                            color: AppColors.secondary,
                          )
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
                  itemCount: dummy.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                      EdgeInsets.only(top: index != 0 ? 10.0.w : 0),
                      child: OfferContainer(
                        image: dummy[index]['image'],
                        name: dummy[index]['name'],
                        experience: dummy[index]['experience'],
                        price: dummy[index]['price'],
                        rating: dummy[index]['rating'],
                        reviews: dummy[index]['reviews'],
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
        ),
      ),
    );
  }
}
