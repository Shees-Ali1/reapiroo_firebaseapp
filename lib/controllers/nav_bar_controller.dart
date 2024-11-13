import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer(BuildContext context) {
    scaffoldKey.currentState?.openDrawer();
  }

  late final PageController pageController;

  late final NotchBottomBarController controller;
}
