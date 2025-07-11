import 'package:flutter/material.dart';
import 'package:food_order_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_order_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
   return Container(
  height: 110,
  color: Theme.of(context).colorScheme.surface,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      
      CircleAvatar(
        radius: 25,
        backgroundColor: Colors.amberAccent,
        child: Icon(Icons.person, color: Colors.white),
      ),

      const SizedBox(width: 12),

      
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Szállítás",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Ide jön a szállítási cím",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(width: 12),

      // Dark mode váltó
      Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => CupertinoSwitch(
          value: themeProvider.isDarkMode,
          onChanged: (value) => themeProvider.toggleTheme(),
        ),
      ),
    ],
  ),
);

  }
}