import 'package:flutter/material.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/dimensions.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({super.key, required this.containerContent});

  Widget containerContent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: MediaQuery.of(context).size.height * 0.75,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30)
        ),
        child: Container(
          color:  Theme.of(context).colorScheme.surface,
          child: containerContent,
        ),
      ),
    );
  }
}