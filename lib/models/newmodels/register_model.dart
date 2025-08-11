import 'package:meta/meta.dart';
import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
    final String email;
    final String password;
    final String passwordVerification;
    RegisterModel({
        required this.email,
        required this.password,
        required this.passwordVerification
    });

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        email: json["email"],
        password: json["password"],
        passwordVerification: json["passwordVerification"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "passwordVerification": passwordVerification
    };
}
