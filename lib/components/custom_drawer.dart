import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_drawer_tile.dart';
import 'package:food_order_app/pages/settings_page.dart';
import 'package:food_order_app/services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final _authService = AuthService();
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // app logo
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
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

          // home list tile
          CustomDrawerTile(
            text: "Főoldal",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          // settings list tile
          CustomDrawerTile(
            text: "Beállítások",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(context) => const SettingsPage(),
                ),
              );
            },
          ),

          const Spacer(),

          // log out list tile
          CustomDrawerTile(
            text: "Kijelentkezés",
            icon: Icons.logout,
            onTap: logout,
          ),

          const SizedBox(height: 25.0),
        ],
      ),
    );
  }
}