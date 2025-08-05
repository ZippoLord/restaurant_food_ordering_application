// ignore_for_file: prefer_collection_literals, sort_child_properties_last
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_order_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/controllers/user_location_controller.dart';
import 'package:food_order_app/controllers/address_controller.dart';
import 'package:food_order_app/dimensions.dart';
import 'package:food_order_app/models/address.dart';
import 'package:food_order_app/widgets/address_list_widget.dart';
import 'package:food_order_app/widgets/home_snackbar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class ShippingAddress extends StatefulWidget {
  final int initialPage;

  const ShippingAddress({super.key, this.initialPage = 0});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  late final PageController _pageController;
  GoogleMapController? _mapController;
  final locationController = Get.put(UserLocationController());
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  final TextEditingController _doorNumber = TextEditingController();
  final TextEditingController _floorNumber = TextEditingController();
  LatLng? _selectedPosition;
  List<dynamic> _placesList = [];
  List<dynamic> _selectedPlace = [];
  final apiKey = AppConfig.apiKey;
  //List<Address> addressList = [];
  int _currentTabIndex = 0;
  final AddressController addressController = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
    addressController.fetchAddresses();
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
      String doorNumber = "";
      String floorNumber = "";
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
        _floorNumber.text = floorNumber;
        _doorNumber.text = doorNumber;
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
        title: Text('Szállítási cím', style: TextStyle(fontWeight: FontWeight.w500)),
        leading: IconButton(
          onPressed: () {
            if (_currentTabIndex == 0) {
              Navigator.of(context).maybePop();
            } else {
              setState(() {
                _currentTabIndex--;
                _pageController.jumpToPage(_currentTabIndex);
              });
            }
          },
          icon: Icon(_currentTabIndex == 0 ? Icons.close_rounded : Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.inversePrimary),
        ),
        actions: [
          _currentTabIndex >= 2
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _currentTabIndex++;
                        _pageController.jumpToPage(_currentTabIndex);
                      });
                    },
                    icon: Icon(Icons.arrow_forward_rounded),
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
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
            setState(() {
              _currentTabIndex = index;
            });
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
                    TextField(
                      controller: _floorNumber,
                      decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0,
                        )
                      ),
                      hintText: 'Emelet',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _doorNumber,
                      decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0,
                        )
                      ),
                      hintText: 'Ajtó',
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
                            onChanged: (value) async {
                              // Get user and docRef here, since you need them for update
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;
                              final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

                              // Set all to false
                              for (var address in addressController.addressList) {
                                  address.defaultAddress = false;
                              }
                              locationController.setisDefault = value;

                              // Save back to Firestore
                              await docRef.update({
                                'address': addressController.addressList.map((a) => a.toJson()).toList(),
                              });
                              await addressController.fetchAddresses();
                              addressController.addressList.refresh();
                            },
                          ))
                        ],
                      ), 
                    ),
                     SizedBox(
                      height: 15,
                    ),
                    InkWell(
                   splashColor: Colors.red.withOpacity(0.2),
                    onTap: () async {
                      if(_searchController.text.isNotEmpty && _postalCode.text.isNotEmpty){
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
                        final docSnap = await docRef.get();

                        List<dynamic> addressList = docSnap.data()?['address'] ?? [];
                        int autoId = 1;

                        if (addressList.isNotEmpty) {
                          final ids = addressList.map((e) => e['id'] as int).toList();
                          autoId = ids.reduce((a, b) => a > b ? a : b) + 1; // Get the max id and increment by 1
                        }

                        if (locationController.isDefault) {
                          for (var addr in addressList) {
                            addr['default'] = false;
                          }
                        }

                        final newAddress = Address(
                          id: autoId,
                          addressLine1: _searchController.text,
                          postalCode: _postalCode.text,
                          floorNumber: _floorNumber.text,
                          doorNumber: _doorNumber.text,
                          defaultAddress: locationController.isDefault,
                          latitude: _selectedPosition!.latitude,
                          longitude: _selectedPosition!.longitude
                        );
                        addressList.add(newAddress.toJson());
                        await docRef.update({
                          'address': addressList,
                        });
                        locationController.setTabIndex = 2;
                        _pageController.jumpToPage(2); 
                        await addressController.fetchAddresses();
                      }
                    }, 
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("Hozzáadás", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),),
                    ),
                    )
                ],
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            Stack(
              children: [
                 Obx(() => AddressListWidget(addresses: addressController.addressList.toList())),
                 Align(
                   alignment: Alignment.bottomCenter,
                   child: Padding(
                     padding: EdgeInsets.only(bottom: 150.0),
                     child: MaterialButton(
                       onPressed: (){
                          Navigator.of(context).pop();
                          setState(() {
                            addressController.selectedAddress.value.isEmpty ? 
                            addressController.selectedAddress.value =
                            addressController.addressList.firstWhere((address) => address.defaultAddress).addressLine1
                            : addressController.selectedAddress.value;
                          });
                          showHomeSnackbar(context, "A szállítási cím: ${addressController.selectedAddress.value} 🏠",);
                         //print("Selected Address from the AddressWidget ${addressController.selectedAddress.value}");
                       }, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                       color: Colors.red,
                       textColor: Colors.white,
                       minWidth: 230.w,
                       height: 48,
                       child: Text('Bezárás', style: TextStyle(fontWeight: FontWeight.bold)),
                     ),
                   ),
                 ),
               ],
            )
          ],
        ),
      ),
    );
  }
}
