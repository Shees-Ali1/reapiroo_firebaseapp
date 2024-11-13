import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlidingMenu extends StatefulWidget {
  final List<String> imageUrls; // Replace with data fetched from Firestore or admin panel

  SlidingMenu({required this.imageUrls});

  @override
  _SlidingMenuState createState() => _SlidingMenuState();
}

class _SlidingMenuState extends State<SlidingMenu> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Start auto-sliding every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.w),
                  image: DecorationImage(
                    image: AssetImage(widget.imageUrls[index]),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.imageUrls.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8.w,
            dotWidth: 8.w,
            activeDotColor: Colors.black,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
