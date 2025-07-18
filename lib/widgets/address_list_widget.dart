import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/models/address.dart';
import 'package:food_order_app/widgets/address_tile.dart';

class AddressListWidget extends StatelessWidget {
  final List<Address> addresses;

  const AddressListWidget({super.key, required this.addresses});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red.withOpacity(0.5),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AddressTile(address: addresses[index]),
            ),
          );
      });
  }
}