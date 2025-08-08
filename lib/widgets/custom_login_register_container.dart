import 'package:flutter/material.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/dimensions.dart';

class CustomLoginRegisterContainer extends StatelessWidget {
  CustomLoginRegisterContainer({super.key, required this.containerContent});

  Widget containerContent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: MediaQuery.of(context).size.height * 0.75,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        ),
        child: Container(
          color:  Theme.of(context).colorScheme.surface,
          child: containerContent,
        ),
      ),
    );
  }
}