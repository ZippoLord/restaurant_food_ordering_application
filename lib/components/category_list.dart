import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/models/food.dart';


class CategoryList extends StatelessWidget {
  final List<FoodCategory> categories;
  final TabController tabController;
  final int selectedIndex;

  const CategoryList({
    super.key,
    required this.categories,
    required this.tabController,
    required this.selectedIndex,
  });

  String _getImageForCategory(FoodCategory category) {
    if (category.name.toLowerCase().contains('pizza')) {
      return 'lib/images/navbaricons/pizza.png';
    } else if (category.name.toLowerCase().contains('ital')) {
      return 'lib/images/navbaricons/soda.png';
    } else if (category.name.toLowerCase().contains('burger')) {
      return 'lib/images/navbaricons/hamburger.png';
    }else if (category.name.toLowerCase().contains('menu')) {
      return 'lib/images/navbaricons/menu.png' ;
    } 
    else {
      return 'assets/images/placeholder.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      height: 80.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final category = categories[i];
          final isSelected = i == selectedIndex;

          return GestureDetector(
            onTap: () => tabController.animateTo(i),
            child: Container(
              width: 70.w,
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                // border: Border.all(
                //   color: isSelected ? Colors.red : Colors.grey.shade400,
                //   width: .5.w,
                // ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 35.h,
                    child: Image.asset(
                      _getImageForCategory(category),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    category.displayName,
                    style: TextStyle(
                      color: isSelected ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

