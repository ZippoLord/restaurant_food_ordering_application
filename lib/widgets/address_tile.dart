import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/components/custom_shipping_address.dart';
import 'package:food_order_app/models/address.dart';
import 'package:get/get.dart';

class AddressTile extends StatefulWidget {
  final Address address;
  final bool selected;
  final VoidCallback? onAddressDeleted;

  const AddressTile({
    super.key,
    required this.address,
    this.selected = false,
    this.onAddressDeleted,
  });

  @override
  State<AddressTile> createState() => _AddressTileState();
}

class _AddressTileState extends State<AddressTile> {
  late final AddressController addressController;

  @override
  void initState() {
    super.initState();
    addressController = Get.find<AddressController>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.selected ? Colors.red.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ListTile(
        onTap: (){},
        visualDensity: VisualDensity.compact,
        leading: Icon(Icons.pin_drop_outlined, 
        color: Theme.of(context).colorScheme.primary, 
        size: 28.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.address.addressLine1,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (widget.address.defaultAddress)
              Text(
                "Alapértelmezett cím",
                style: TextStyle(fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red, size: 20.h),
            onPressed: () => showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            "Biztos törölni akarod a címet?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Mégse"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await addressController.deleteAddressById(widget.address.id);
                                Navigator.pop(context);
                                widget.onAddressDeleted?.call();
                              },
                              child: const Text("Igen"),
                            ),
                          ],
                        ),
                  )
          ),
      ),
    );
  }
}