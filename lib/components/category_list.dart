import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/models/food.dart';
import 'package:food_order_app/models/newmodels/category.dart';
import 'package:food_order_app/models/newmodels/hooks/fetchCategories.dart';
import 'package:food_order_app/widgets/skeleton.dart';


class CategoryList extends HookWidget {
  final List<CategoryModel> categories;
  final TabController tabController;
  final int selectedIndex;

  const CategoryList({
    super.key,
    required this.categories,
    required this.tabController,
    required this.selectedIndex,
  });

 
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchCategories();
    final isLoading = hookResult.isLoading;
   if (isLoading || hookResult.data == null) {
  return Center(child: const CircularProgressIndicator(),);
}

    final List<CategoryModel> categoriesList = hookResult.data!;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      height: 100.h,
      padding: EdgeInsets.only(left: 10.w, top: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        itemBuilder: (context, i) {
          CategoryModel category = categoriesList[i];
          final isSelected = i == selectedIndex;
    
          return GestureDetector(
            onTap: () => tabController.animateTo(i),
            child: Container(
              width: 80.w,
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35.h,
                    child: Image.network(
                  category.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 35.w,
                      height: 35.h,
                      color: Colors.grey.shade300,
                    );
                  },
                )
                  ),
                  SizedBox(height: 4),
                  Text(
                    category.title,
                    maxLines: 1,
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

