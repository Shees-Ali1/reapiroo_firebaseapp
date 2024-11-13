import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';

import 'today_screen_widgets/today_screen_booking_card.dart';

class TodayContent extends StatelessWidget {
  TodayContent({Key? key}) : super(key: key);
  // Define a list of data for the containers
  final List<Map<String, String>> bookingData = [
    {
      'name': 'Jared Hughs',
      'location': 'Downtown Road, Dubai.',
      'description':
      'I need to have my outdoor pipes fixed.\nWe have a huge leakage in the valves\nand the wall fittings.',
      'date': 'Mon, Dec 23',
      'time': '12:00',
      'image':  AppImages.saraprofile,  // Replace with your image path
    },
    {
      'name': 'Michael Scott',
      'location': 'Central Street, Abu Dhabi.',
      'description':
      'The indoor heating system is malfunctioning.\nNeed help to fix the furnace ASAP.',
      'date': 'Wed, Jan 02',
      'time': '14:30',
      'image': AppImages.jared_hughs, // Replace with your image path
    },


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: bookingData.length,
        itemBuilder: (context, index) {
          final booking = bookingData[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index != bookingData.length - 1 ? 12.h : 0),
            child: BookingCard(
              name: booking['name']!,
              location: booking['location']!,
              description: booking['description']!,
              date: booking['date']!,
              time: booking['time']!,
              imagePath: booking['image']!,
            ),
          );
        },
      ),
    );
  }
}