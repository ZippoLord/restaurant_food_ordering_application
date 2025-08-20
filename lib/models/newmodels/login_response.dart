// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    final bool status;
    final String id;
    final String username;
    final String email;
    final bool verification;
    final String phone;
    final String userType;
    final String profile;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;
    final String? address; // nullable
    final String userToken;

    LoginResponse({
        required this.status,
        required this.id,
        required this.username,
        required this.email,
        required this.verification,
        required this.phone,
        required this.userType,
        required this.profile,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        this.address, // nullable
        required this.userToken,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        id: json["_id"],
        username: json["username"] ?? "",
        email: json["email"],
        verification: json["verification"],
        phone: json["phone"],
        userType: json["userType"],
        profile: json["profile"] ?? "",
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
        address: json["address"], // null lehet
        userToken: json["userToken"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "username": username,
        "email": email,
        "verification": verification,
        "phone": phone,
        "userType": userType,
        "profile": profile,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "address": address, // null is ok
        "userToken": userToken,
    };
}
