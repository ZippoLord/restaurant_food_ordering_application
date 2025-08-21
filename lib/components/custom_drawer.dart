import 'package:flutter/material.dart';
import 'package:food_order_app/components/attention.dart';
import 'package:food_order_app/components/attention_order.dart';
import 'package:food_order_app/components/custom_drawer_tile.dart';
import 'package:food_order_app/components/custom_shipping_address.dart';
import 'package:food_order_app/controllers/address_controller.dart';
import 'package:food_order_app/controllers/login_controller.dart';
import 'package:food_order_app/models/newmodels/login_response.dart';
import 'package:food_order_app/pages/login_page.dart';
import 'package:food_order_app/pages/settings_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});


@override
  State<MyDrawer> createState() => MyDrawerState();
}


  class MyDrawerState extends State<MyDrawer> {
  String? email;
  final box = GetStorage();
  final AddressController addressController = Get.put(AddressController());
  final LoginController userController = Get.put(LoginController());

LoginResponse? getStoredUser() {
  String? rawData = box.read("userData");
  if (rawData != null) {
    return loginResponseFromJson(rawData);
  }
  return null;
}
String getToken() {
  return box.read("token");
}

String getUserId() {
  return box.read("userId");
}

void logout(){
  box.erase();
  Get.offAll(() => LoginPage(), transition: Transition.fade , duration: const Duration(milliseconds: 900)); 
  }

 @override
void initState() {
  super.initState();
  addressController.fetchAddresses(getToken(), getUserId());
  userController.fetchUserData(getToken());
}

  @override
  Widget build(BuildContext context) {
    final user = getStoredUser();
    return Drawer(
  child: SafeArea(
    child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Icon(
                  Icons.food_bank_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
               Padding(
                 padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 23.0),
                 child: Text("Felhasználó: ${user?.email}", style: TextStyle(fontWeight: FontWeight.w500),),
               ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              CustomDrawerTile(
                text: "Főoldal",
                icon: Icons.home,
                onTap: () => Navigator.pop(context),
              ),
              Obx(() {
              if (addressController.addresses.isNotEmpty && userController.firstSetup.value) {
                return CustomDrawerTile(
                  text: "Szállítási cím",
                  icon: Icons.delivery_dining,
                  onTap: () {
                    Get.to(() => const ShippingAddress(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 400));
                  },
                );
              } else {
                return AttentionOrder(
                  text: "Szállítási cím",
                  icon: Icons.delivery_dining,
                  onTap: () {
                    Get.to(() => const ShippingAddress(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 400));
                  },
                );
              }
            }),
              CustomDrawerTile(
                text: "Beállítások",
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
              // ide jöhetnek még menüpontok, ha vannak
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
          child: CustomDrawerTile(
            text: "Kijelentkezés",
            icon: Icons.logout,
            onTap: () {
              logout();
            },
          ),
        ),
      ],
    ),
  ),
);

  }
}
