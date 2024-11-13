import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class divider extends StatelessWidget {
  const divider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.0.h, // Set the height of the divider
      width: 271.w, // Set the width to fill the parent
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 1), // First color (white)
            Color.fromRGBO(0, 0, 0, 1),       // Second color (black)
            Color.fromRGBO(255, 255, 255, 1), // Third color (white)
          ],
          stops: [0.0, 0.5, 1.0], // Control the gradient stop positions
          begin: Alignment.centerLeft, // Start from the left
          end: Alignment.centerRight,   // End at the right
        ),
      ),
    );
  }
}
