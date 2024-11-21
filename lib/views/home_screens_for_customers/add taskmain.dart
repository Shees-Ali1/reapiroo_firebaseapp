import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets/app_bars.dart';
import 'customer_task_home.dart';
import 'my service main.dart';

class AddTaskMain extends StatefulWidget {
  const AddTaskMain({super.key, this.service});
  final String? service;

  @override
  State<AddTaskMain> createState() => _AddTaskMainState();
}

class _AddTaskMainState extends State<AddTaskMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: DefaultTabController(
        length: 2, // Define the number of tabs
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Material(
              color: Colors.white,
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Add Services'),
                  Tab(text: 'My Services'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CustomerTaskHome(service: widget.service),  // Pass service to Tab 1
// Screen for Tab 1
                  MyServiceMain(),  // Screen for Tab 2
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
