import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:repairoo/views/home_screens_for_customers/search_offer_screen.dart';

import '../../const/color.dart';
import '../../const/text_styles.dart';

class MyServiceMain extends StatefulWidget {
  const MyServiceMain({Key? key, this.service}) : super(key: key);
  final String? service;

  @override
  State<MyServiceMain> createState() => _MyServiceMainState();
}

class _MyServiceMainState extends State<MyServiceMain> {
  String? selectedOption = 'All'; // Default to "All"

  // Fetch tasks for the current user
  Stream<QuerySnapshot> _fetchUserTasks() {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('userUid', isEqualTo: userUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(13.5),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Services',
                  style: jost700(24.sp, AppColors.primary),
                ),
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.black, // Set the container color to black
                  ),
                  child: DropdownButton<String>(
                    value: selectedOption,
                    dropdownColor: AppColors.secondary,
                    underline: SizedBox(), // Remove underline
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.keyboard_arrow_down, color: Colors.white), // Icon color set to white
                    ),
                    style: jost400(14.sp, Colors.black), // Default text color for dropdown items (black)
                    selectedItemBuilder: (BuildContext context) {
                      return ['All', 'House Cleaning', 'TV Mounting', 'Gardening', 'Plumbing']
                          .map((String value) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0,top: 5),
                          child: Text(
                            value,
                            style: jost400(14.sp, Colors.white), // Set text color to white for selected item
                          ),
                        );
                      }).toList();
                    },
                    items: ['All', 'House Cleaning', 'TV Mounting', 'Gardening', 'Plumbing']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            value,
                            style: jost400(14.sp, Colors.black), // Set text color to black for unselected items
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value; // Update filter
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _fetchUserTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks found.',
                        style: jost600(18.sp, Colors.grey),
                      ),
                    );
                  }

                  final tasks = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final taskDoc = tasks[index].data() as Map<String, dynamic>;
                      final userUid = taskDoc['userUid'] ?? 'Unknown User';

                      // Filter tasks by selected option
                      final filteredTasks = taskDoc.entries.where((entry) {
                        final isValidArray = entry.value is List;
                        return isValidArray &&
                            (selectedOption == 'All' || entry.key == selectedOption);
                      }).toList();

                      if (filteredTasks.isEmpty) {
                        return SizedBox(); // Skip if no tasks match the filter
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filteredTasks.map((entry) {
                          final title = entry.key;
                          final tasksArray = entry.value as List;

                          return Column(
                            children: tasksArray.map((task) {
                              final taskMap = task as Map<String, dynamic>;
                              final taskTitle = taskMap['title'] ?? 'Untitled';
                              final taskDate =
                                  taskMap['dateTime']?.toDate() ?? DateTime.now();
                              final taskUserName =
                                  taskMap['userName'] ?? 'Unknown User';

                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 10.h),
                                elevation: 5, // Add elevation for shadow effect
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r), // Rounded corners
                                ),
                                color: AppColors.secondary, // Use secondary color for the card
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15.w), // Add padding inside the card
                                  title: Text(
                                    taskTitle,
                                    style: jost600(16.sp, AppColors.primary),
                                  ),
                                  subtitle: Text(
                                    'Uploaded by: $taskUserName\nDate: ${taskDate.toString().split(' ')[0]}',
                                    style: jost400(12.sp, Colors.grey),
                                  ),
                                  trailing: Icon(Icons.arrow_forward, color: AppColors.primary),
                                  onTap: () {
                                    // Use Get.to to navigate to a new screen
                                    Get.to(SearchOfferScreen(field: selectedOption!)); // Pass the selected option here
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
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
  }
}
