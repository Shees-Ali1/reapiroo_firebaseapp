import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  ];


  Future<List<Map<String, String>>> fetchBookingData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return [];
    }
    final userId = user.uid;
    final bookingsRef = FirebaseFirestore.instance.collection('bookings').doc(userId);
    final snapshot = await bookingsRef.get();

    final bookings = snapshot.data()?['bookings'] as List<dynamic>?;
    if (bookings != null) {
      return List<Map<String, String>>.from(
        bookings.map((booking) => Map<String, String>.from(booking)),
      );
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // First, store the data to Firestore when the widget is built

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchBookingData(),  // Fetch data from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No booking data available'));
          }

          final bookingData = snapshot.data!;
          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
