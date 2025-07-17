// ignore_for_file: prefer_collection_literals, sort_child_properties_last
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_order_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/controllers/user_location_controller.dart';
import 'package:food_order_app/dimensions.dart';
import 'package:food_order_app/models/address.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({super.key});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  late final PageController _pageController = PageController(initialPage: 0);
  GoogleMapController? _mapController;
  final locationController = Get.put(UserLocationController());
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  LatLng? _selectedPosition;
  List<dynamic> _placesList = [];
  List<dynamic> _selectedPlace = [];
  final apiKey = AppConfig.apiKey;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSearchChange(String query) async {
    if (query.isNotEmpty) {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&region=HU&language=hu',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _placesList = json.decode(response.body)['predictions'];
        });
      }
    } else {
      _placesList = [];
    }
  }

  void _getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&region=HU&language=hu',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final location = json.decode(response.body);
      final lat = location['result']['geometry']['location']['lat'] as double;
      final lng = location['result']['geometry']['location']['lng'] as double;

      final address = location['result']['formatted_address'];

      String postalCode = "";
      final addressComponents = location['result']['address_components'];

      for (var component in addressComponents) {
        if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
          break;
        }
      }

      setState(() {
        _selectedPosition = LatLng(lat, lng);
        _searchController.text = address;
        _postalCode.text = postalCode;
        moveToSelectedPosition();
        _placesList = [];
      });
    }
  }

  void moveToSelectedPosition() {
    if (_selectedPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _selectedPosition!, zoom: 15),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Szállítási cím', style: TextStyle(fontWeight: FontWeight.w500),),
        leading: Obx(
          () => Padding(
            padding: EdgeInsets.only(right: 0.w),
            child:
                locationController.tabIndex == 0
                    ? IconButton(
                      onPressed: () {
                        //?
                        Get.back();
                      },
                      icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.inversePrimary),
                    )
                    : IconButton(
                      onPressed: () {
                        locationController.setTabIndex = 0;
                        _pageController.previousPage(
                        duration: const Duration(milliseconds: 300), 
                        curve: Curves.easeIn);
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.inversePrimary),
                    ),
          ),
        ),
        actions: [
          Obx(() => locationController.tabIndex >= 2? 
            const SizedBox.shrink() : Padding(
              padding:  EdgeInsets.only(top: 6.h),
              child: IconButton(onPressed: (){
                  locationController.setTabIndex = locationController.tabIndex + 1;
                  _pageController.nextPage(duration: const Duration(microseconds: 500), curve: Curves.easeIn);
              }, icon: Icon(Icons.arrow_forward_rounded), color: Theme.of(context).colorScheme.inversePrimary),
            )
          ),
        ],
      ),
      body: SizedBox(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          pageSnapping: false,
          onPageChanged: (index) {
            _pageController.jumpToPage(index);
          },
          children: [
            Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _selectedPosition ?? LatLng(
                      locationController.position.latitude, 
                      locationController.position.longitude), //TODO: custom_app_barba hard codeolva 
                      zoom: 15,                              //van de nem keri le a megfelelo tartozkodasi kordinatakat
                  ),
                  markers:
                      _selectedPosition == null
                          ? Set.of([
                            Marker(
                              markerId: const MarkerId('Itt vagy'),
                              position: LatLng(
                                locationController.position.latitude, 
                                locationController.position.longitude), //ugyan ez ↑
                              draggable: true,
                              onDragEnd: (LatLng position) {
                              },
                            ),
                          ])
                          : Set.of([
                            Marker(
                              markerId: const MarkerId('LOCATION'),
                              position: _selectedPosition!,
                              draggable: true,
                              onDragEnd: (LatLng position) {
                              },
                            ),
                          ]),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      color: Theme.of(context).colorScheme.surface,
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChange,
                        decoration: InputDecoration(
                          hintText: "Keresés címre",
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
                        ),
                      ),
                    ),
                    _placesList.isEmpty
                        ? const SizedBox()
                        : Expanded(
                          child: ListView(
                            children: List.generate(_placesList.length, (
                              index,
                            ) {
                              return Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: ListTile(
                                  visualDensity: VisualDensity.compact,
                                  title: Text(
                                    _placesList[index]['description'],
                                  ),
                                  onTap: () {
                                    _getPlaceDetails(
                                      _placesList[index]['place_id'],
                                    );
                                    _selectedPlace.add(_placesList[index]);
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                  ],
                ),
              ],
            ),
            Container(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                       border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0,
                        )
                      ),
                      hintText: 'Cím',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                     TextField(
                      controller: _postalCode,
                      decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0,
                        )
                      ),
                      hintText: 'Irányítószám',
                      ),
                    ),
                     SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Beállítás alapértelmezettnek", style: TextStyle(fontWeight: FontWeight.w600),),
                          Obx(() => CupertinoSwitch(
                            thumbColor: Colors.white,
                            trackColor: Colors.grey[300],
                            value: locationController.isDefault,
                            onChanged: (value){
                              locationController.setisDefault = value;
                            },
                          ))
                        ],
                      ), 
                    ),
                     SizedBox(
                      height: 15,
                    ),
                    TextButton(
                    style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                     backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () async {
                      if(_searchController.text.isNotEmpty && _postalCode.text.isNotEmpty){
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
                        final docSnap = await docRef.get();

                        List<dynamic> addressList = docSnap.data()?['address'] ?? [];
                        final newAddress = Address(
                        addressLine1: _searchController.text,
                        postalCode: _postalCode.text,
                        defaultAddress: locationController.isDefault,
                        latitude: _selectedPosition!.latitude,
                        longitude: _selectedPosition!.longitude);
                        addressList.add(newAddress.toJson());
                        await docRef.update({
                          'address': addressList,
                        }); 
                      }
                    }, child: Text("Beállít"))
                ],
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            Container(
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
