import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/views/booking_screens/today_screen_widgets/today_screen_booking_card.dart';
import 'package:repairoo/views/home_screen_for_tech/task_description_home.dart';

class TodayContent extends StatelessWidget {
  TodayContent({Key? key}) : super(key: key);

  // Method to format Firestore Timestamp into readable DateTime string
  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate(); // Convert Timestamp to DateTime
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm a'); // Format as desired
    return dateFormat.format(date); // Return formatted string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('booking').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings available.'));
          }

          final bookingData = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>; // Cast to a map
            return {
              'name': data['vendorName'] ?? 'Unknown Vendor',
              'location': 'Multan, Pakistan', // Static location value
              'description': 'description',
              'date': data.containsKey('date') && data['date'] is Timestamp
                  ? formatTimestamp(data['date'])
                  : 'Mon, Dec 23', // Safe handling for missing or invalid 'date'
              'time': data['time'] ?? '12:00',
              'image': data['image'] ?? AppImages.plumbing, // Fallback image
              'price': data['bidAmount'] ?? 'N/A', // Default price
              'taskId': data['taskId'] ?? 'N/A',
              'title': data['title'] ?? 'N/A',
            };
          }).toList();





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
                  description: booking['description']!, // This will always have a fallback value
                  date: booking['date']!,
                  time: booking['time']!,
                  imagePath: booking['image']!,
                  price: booking['price']!,
                  taskId: booking['taskId']!,
                  title: booking['title']!, // Pass title here

                )

              );
            },
          );
        },
      ),
    );
  }
}
