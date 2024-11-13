import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'main_home.dart';
import 'new_task_home.dart';
import 'task_description_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TechHomeController homeVM = Get.find<TechHomeController>();


  @override
  Widget build(BuildContext context) {
    return MainHome();
  }
}
