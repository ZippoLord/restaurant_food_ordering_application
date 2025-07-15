import 'dart:convert';
import 'package:food_order_app/config.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;

class UserLocationController extends GetxController{
  LatLng position = const LatLng(0, 0);

  void setPosition(LatLng value){
    position = value;
    update();
  }

  final RxString _address = ''.obs;

  String get address => _address.value; 

  set setAddress(String value){
    _address.value = value;
  } 
  final RxString _postalCode = ''.obs;

  String get postalCode => _postalCode.value; 

  set setPostalCode(String value){
      _postalCode.value = value;
  } 

  void getUserAddress(LatLng position) async{
    final String lat = '47.6689506';
    final String long = '18.682617800000003';
    final apiKey = AppConfig.apiKey;
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey',
    );
    final response = await http.get(url);

    if(response.statusCode == 200){
      final responseBody = jsonDecode(response.body);

      final address = responseBody['results'][0]['formatted_address'];
      setAddress = address;
      print(address);
      
      final addressComponents = responseBody['results'][0]['address_components'];
      
      for(var component in addressComponents){
        if(component['types'].contains('postal_code')){
          setPostalCode = component['long_name'];
        }
      }

    }
  }

}