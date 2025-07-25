import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/models/newmodels/hooks/fetchCategories.dart';

class CategoryListVer2 extends HookWidget{
  const CategoryListVer2({super.key});

  @override
  Widget build(BuildContext context){
    final hookResult = useFetchCategories();
    return Container(
      height: 75.h,
      padding: EdgeInsets.only(left: 12.w, top:10.h),
      // child: ListView(scrollDirection: Axis.horizontal,
      // children: List.generate(categories.length, (i){
      //     var category = catergories[i];
      //   }
      //   )
      // ,),
    );
  }
}