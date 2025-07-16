import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/config.dart';
import 'package:food_order_app/widgets/custom_restaurant._widget.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class Restaurants extends StatefulWidget {
  final bool mockMode; // mock kapcsoló

  const Restaurants({super.key, this.mockMode = false});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Helymeghatározás nem elérhető');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Helymeghatározás megtagadva');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Végleges tiltás');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _fetchRestaurants() async {
    try {
      if (widget.mockMode) {
        // ✅ MOCK adatok
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          restaurants = [
            {
              'name': 'Mock Étterem 1',
              'vicinity': 'Mock utca 12',
              'imageUrl': 'lib/images/pizzas/pizzeria.jpg',
              'openNow': true,
            },
            {
              'name': 'Mock Étterem 2',
              'vicinity': 'Mock tér 7',
              'imageUrl': 'lib/images/pizzas/pizzeria_2.jpg',
              'openNow': false,
            },
          ];
          isLoading = false;
        });
        return;
      }

  
      final position = await _getCurrentPosition();
      final lat = position.latitude;
      final lng = position.longitude;
      final apiKey = AppConfig.apiKey;

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1500&type=restaurant&key=$apiKey&region=HU&language=hu',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        setState(() {
          restaurants = results.take(2).map<Map<String, dynamic>>((r) {
            return {
              'name': r['name'],
              'vicinity': r['vicinity'],
              'imageUrl': 'lib/images/pizzas/pizzeria.jpg', 
              'openNow': r['opening_hours']?['open_now'] ?? false,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('API hiba: ${response.statusCode}');
      }
    } catch (e) {
      print('Hiba: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  "Közeli éttermek",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurants.length,
                    itemBuilder: (context, i) {
                      final restaurant = restaurants[i];
                      return RestaurantWidget(
                        image: restaurant['imageUrl'],
                        name: restaurant['name'],
                        location: restaurant['vicinity'],
                        openNow: restaurant['openNow'],
                      );
                    },
                  ),
              ),
            ],
          ),
    );
  }
}
