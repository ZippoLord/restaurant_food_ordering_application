import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildSkeletonCategory() {
  return Container(
    width: 80.w,
    margin: EdgeInsets.only(right: 10.w),
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40.w,
          height: 35.h,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 6.h),
        Container(
          width: 50.w,
          height: 10.h,
          color: Colors.grey.shade400,
        ),
      ],
    ),
  );
}
