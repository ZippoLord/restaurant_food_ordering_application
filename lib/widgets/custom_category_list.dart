import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/models/food.dart';

class CategoryList extends StatelessWidget {
  final List<FoodCategory> categories;

  const CategoryList({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((category) {
          return Container(
            margin: EdgeInsets.only(right: 5.w),
            padding:  EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 35.h,
                  child: Image.network('lib/images/navbaricons/pizza.png'),
                )
              ],
            )
          );
        }).toList(),
      ),
    );
  }
}
