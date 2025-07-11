import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/pages/cart_page.dart';
import 'package:food_order_app/pages/food_page.dart';
import 'package:food_order_app/services/auth/auth_gate.dart';
import 'package:food_order_app/firebase_options.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:food_order_app/themes/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';




void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  Get.put(CartController()); //load Controller
  try {
    await dotenv.load(fileName: ".env"); //load env varrialbes
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        // theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // restaurant provider
        ChangeNotifierProvider(create: (context) => Restaurant()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}