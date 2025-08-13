import 'dart:convert';

List<AddressModel> addressModelFromJson(String str) => List<AddressModel>.from(json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
    final String? id;
    final String userId;
    final String addressLine1;
    final String postalCode;
    bool defaultAddress;
    final String floorNumber;
    final String doorNumber;
    final double latitude;
    final double longitude;

    AddressModel({
        this.id,
        required this.userId,
        required this.addressLine1, 
        required this.floorNumber, 
        required this.doorNumber, 
        required this.postalCode, 
        required this.defaultAddress, 
        required this.latitude, 
        required this.longitude,
    });

    factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['_id'] ?? '',
        userId: json["userId"] ?? '',        
        addressLine1: json["addressLine1"] ?? '',
        postalCode: json["postalCode"] ?? '',
        floorNumber: json["floorNumber"] ?? '',
        doorNumber: json["doorNumber"] ?? '',
        defaultAddress: json["defaultAddress"] ?? false,
        latitude: double.tryParse(json['latitude'].toString()) ?? 0,
        longitude: double.tryParse(json['longitude'].toString()) ?? 0, 
    );

    Map<String, dynamic> toJson() => {
      "userId" : userId,
      "addressLine1" : addressLine1,   
      "postalCode" : postalCode,   
      "floorNumber" : floorNumber,   
      "doorNumber" : doorNumber,   
      "defaultAddress" : defaultAddress,   
      "latitude" : latitude,   
      "longitude" : longitude,   
    };
}

