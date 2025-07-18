import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
    int id;
    final String addressLine1;
    final String postalCode;
    bool defaultAddress;
    final double latitude;
    final double longitude;

    Address({
        required this.id, 
        required this.addressLine1, 
        required this.postalCode, 
        required this.defaultAddress, 
        required this.latitude, 
        required this.longitude,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] ?? 0,
        addressLine1: json["addressLine1"] ?? '',
        postalCode: json["postalCode"] ?? '',
        defaultAddress: json["default"] ?? false,
        latitude: json["latitude"]?.toDouble() ?? 0.0,
        longitude: json["longitude"]?.toDouble() ?? 0.0, 
    );

    Map<String, dynamic> toJson() => {
      "id": id,
      "addressLine1" : addressLine1,   
      "postalCode" : postalCode,   
      "default" : defaultAddress,   
      "latitude" : latitude,   
      "longitude" : longitude,   
    };
}

