import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/controllers/address_controller.dart';
import 'package:food_order_app/models/address.dart';
import 'package:get/get.dart';
class AddressTile extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onSelected;
  final VoidCallback? onAddressDeleted;

  const AddressTile({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onSelected,
    this.onAddressDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final addressController = Get.find<AddressController>();

    return ListTile(
      onTap: onSelected,
      visualDensity: VisualDensity.compact,
      leading: Icon(
        Icons.pin_drop_outlined,
        color: Theme.of(context).colorScheme.primary,
        size: 28.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.addressLine1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (address.defaultAddress)
            const Text(
              "Alapértelmezett cím",
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red, size: 20.h),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Biztos törölni akarod a címet?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Mégse"),
              ),
              TextButton(
                onPressed: () async {
                  await addressController.deleteAddressById(address.id);
                  addressController.selectedAddress.value = '';
                  Navigator.pop(context);
                  onAddressDeleted?.call();
                },
                child: const Text("Igen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
