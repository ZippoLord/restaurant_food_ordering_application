import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/controllers/address_controller.dart';
import 'package:food_order_app/models/address.dart';
import 'package:food_order_app/widgets/address_tile.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddressListWidget extends StatefulWidget {
  final List<Address> addresses;

  const AddressListWidget({super.key, required this.addresses});

  @override
  State<AddressListWidget> createState() => _AddressListWidgetState();
}

class _AddressListWidgetState extends State<AddressListWidget> {
  int? _selectedIndex;
  final RxnString _selectedAddress = RxnString();
  final AddressController addressController = Get.find<AddressController>();
 


  void _handleSelectionChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedAddress.value = widget.addresses[index].addressLine1;
      addressController.selectedAddress.value = widget.addresses[index].addressLine1;
    });
   print("Selected Address: ${addressController.selectedAddress.value}");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.addresses.length,
      itemBuilder: (context, index){
        final address = widget.addresses[index];
        final isSelected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AddressTile(address: address, 
              isSelected: isSelected, 
              onSelected: () => _handleSelectionChanged(index),),
            ),
          );
      });
  }
}