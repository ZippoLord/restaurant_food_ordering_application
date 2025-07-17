import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_order_app/models/address.dart';

class appUser {
  String uid;
  String email;
  Timestamp accountCreated;
  List<Address> address;

  appUser({
    required this.uid,
    required this.email, 
    required this.accountCreated,
    required this.address});


factory appUser.fromMap(Map<String, dynamic> map){
  return appUser(
    uid: map['uid'],
    email: map['email'],
    accountCreated: map['accountCreated'],
     address: map['address'] != null
          ? List<Address>.from(
              map['address'].map((x) => Address.fromJson(x)))
          : [],
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'accountCreated': accountCreated,
      'address': address.map((x) => x.toJson()).toList(),
    };
  }
}

