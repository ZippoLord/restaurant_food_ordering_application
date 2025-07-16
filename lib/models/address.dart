import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
    final String addressLine1;
    final String postalCode;
    final bool defaultAddress;
    final double latitude;
    final double longitude;

    Address({
        required this.addressLine1, 
        required this.postalCode, 
        required this.defaultAddress, 
        required this.latitude, 
        required this.longitude,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressLine1: json["addressLine1"],
        postalCode: json["postalCode"],
        defaultAddress: json["default"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
      "addressLine1" : addressLine1,   
      "postalCode" : postalCode,   
      "default" : defaultAddress,   
      "latitude" : latitude,   
      "longitude" : longitude,   
    };
}

