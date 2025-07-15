import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_drawer_tile.dart';
import 'package:food_order_app/components/custom_shipping_address.dart';
import 'package:food_order_app/pages/settings_page.dart';
import 'package:food_order_app/services/auth/auth_service.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
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
               CustomDrawerTile(
                text: "Szállítási cím",
                icon: Icons.delivery_dining,
                onTap: () {
                  Get.to(() => const ShippingAddress(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 400));
                },
              ),
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
              final authService = AuthService();
              authService.signOut();
            },
          ),
        ),
      ],
    ),
  ),
);

  }
}