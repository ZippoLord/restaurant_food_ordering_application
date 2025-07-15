// ignore_for_file: prefer_collection_literals
import 'dart:convert';

import 'package:food_order_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/controllers/user_location_controller.dart';
import 'package:food_order_app/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
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
final TextEditingController _searchController = TextEditingController();
final TextEditingController _postalCode = TextEditingController();
LatLng? _selectedPosition;
List<dynamic> _placesList = [];
List<dynamic> _selectedPlace = [];
final apiKey = AppConfig.apiKey;

@override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        
      });
    });
    super.initState();    
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  void _onSearchChange(String query) async {
      if(query.isNotEmpty){
       
        final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey',
      );
      final response  = await http.get(url);
      if(response.statusCode == 200){
        setState(() {
          _placesList = json.decode(response.body)['predictions'];
        });
      }
      }else{
        _placesList = [];
      }
  }

  void _getPlaceDetails(String placeId) async {

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey',
      );

        final response  = await http.get(url);
        if(response.statusCode == 200)
        {
          final location = json.decode(response.body);
          final lat = location['result']['geometry']['location']['lat'] as double;
          final lng = location['result']['geometry']['location']['lng'] as double;

          final address = location['result']['formatted_address'];

          String postalCode = "";
          final addressComponents = location['result']['address_components'];

          for(var component in addressComponents){
            if(component['types'].contains('postal_code')){
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

  void moveToSelectedPosition(){
    if(_selectedPosition != null && _mapController != null){
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _selectedPosition!, zoom: 15)));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Shipping Address'),
        leading: Obx(() => Padding(
          padding: EdgeInsets.only(right:  0.w),
          child: IconButton(onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: kPrimary,)),
        )),
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
                  onMapCreated: (GoogleMapController controller){
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: 
                    _selectedPosition ?? LatLng(47.6689519, 18.6826182), 
                    zoom: 15),
                    markers: _selectedPosition == null ? Set.of([
                         Marker(
                        markerId: const MarkerId('Itt vagy'),
                        position: const LatLng(47.6689519, 18.6826182),
                        draggable: true,
                        onDragEnd: (LatLng position){
                          print(position);
                        }
                      )
                    ]) : Set.of([
                      Marker(
                        markerId: const MarkerId('LOCATION'),
                        position: _selectedPosition!,
                        draggable: true,
                        onDragEnd: (LatLng position){
                          print(position);
                        }
                      )
                    ]),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          color: Colors.white,
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChange,
                            decoration: const InputDecoration(
                              hintText: "Keresés címre"
                            ),
                          ),
                        ),
                        _placesList.isEmpty ? const SizedBox() : Expanded(
                          child: ListView(
                            children: 
                              List.generate(_placesList.length, (index) {
                                return Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      visualDensity: VisualDensity.compact,
                                      title: Text(
                                        _placesList[index]['description'],
                                      ),
                                      onTap: () {
                                        _getPlaceDetails(_placesList[index]['place_id']);
                                        _selectedPlace.add(_placesList[index]);
                                      },
                                    ),
                                );
                              })
                          ),
                        )
                      ],
                    )
              ],
            ),
          ],
        ),
      ),
    );
  }
}