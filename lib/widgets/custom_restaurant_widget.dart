import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantWidget extends StatelessWidget {
  const RestaurantWidget({super.key, required this.image, required this.name, this.onTap, required this.location, required this.openNow});
  final String image;
  final String name;
  final bool openNow;
  final String location;
  final void Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          width: 450.w*.75,
          height: 200.h,
          decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Theme.of(context).colorScheme.surface,
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                        width: 500.w*.75,
                        height: 150.h,
                      child: Image.asset(image, fit: BoxFit.fill,),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: ClipRect(
        
                    ),
                  )
                ],
              ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  openNow ? Text("Nyitva", style: TextStyle(color: Colors.green),) :Text("Zárva", style: TextStyle(color: Colors.red),),
                  Text("H-P 8:00 - 18:00", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.inversePrimary),)
                    ],
                  ),
                ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}