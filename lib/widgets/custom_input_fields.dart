import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:repairoo/const/color.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final bool obscureText;
  final String? svgIconPath; // Path to SVG icon
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? hintText; // Hint text parameter
  final Color? hintTextColor; // Color for the hint text
  final double? hintTextSize; // Font size for the hint text
  final Color? labelTextColor; // Color for the label text
  final double? labelTextSize; // Font size for the label text
  final bool alignLabelWithHint; // New parameter to adjust label position
  final Widget? suffixIcon; // Suffix icon parameter
  final Widget? prefixIcon; // New parameter for prefix icon
  final EdgeInsets? contentPadding; // New parameter for prefix icon
  final ValueChanged<String>? onChanged;
  final int? maxLines; // New parameter for max lines

  CustomInputField({
    required this.controller,
    this.label,
    this.obscureText = false,
    this.svgIconPath,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.hintText,
    this.hintTextColor,
    this.hintTextSize,
    this.labelTextColor,
    this.labelTextSize,
    this.alignLabelWithHint = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.maxLines, this.contentPadding, // Add maxLines to the constructor
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // Set initial obscureText state
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Toggle visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textAlign: TextAlign.start,
      cursorColor: AppColors.primary,
      style: TextStyle(
        color: AppColors.primary,
        fontSize: widget.hintTextSize ?? 14.65.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'Jost',
      ),
      maxLines: widget.maxLines ?? 1, // Set maxLines here
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: AppColors.fill,
        filled: true,
        labelText: widget.label,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintTextColor ?? AppColors.primary.withOpacity(0.5),
          fontSize: widget.hintTextSize ?? 14.65.sp,
          fontFamily: 'Jost',
        ),
        labelStyle: TextStyle(
          color: widget.labelTextColor ?? AppColors.primary,
          fontSize: widget.labelTextSize ?? 14.65.sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Jost',
        ),
        alignLabelWithHint: widget.alignLabelWithHint,
        // Add the prefix icon support
        prefixIcon: widget.prefixIcon != null
            ? widget.prefixIcon // If provided, use the widget's prefixIcon
            : widget.svgIconPath != null // Or fallback to svgIconPath if provided
            ? Padding(
          padding: EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            widget.svgIconPath!,
            fit: BoxFit.scaleDown,
            width: 15.26.w,
            height: 12.97.h,
          ),
        )
            : null, // No prefix icon if none is provided
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primary,
          ),
          onPressed: _togglePasswordVisibility,
        )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.31.r),
          borderSide: BorderSide(color: AppColors.textFieldGrey, width: 0.95.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldGrey, width: 0.95.w),
          borderRadius: BorderRadius.circular(13.31.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldGrey, width: 0.95.w),
          borderRadius: BorderRadius.circular(13.31.r),
        ),
        contentPadding: widget.contentPadding,
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}