import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:food_order_app/models/appUser.dart';
import 'package:food_order_app/services/database/firestore.dart';
import 'package:food_order_app/widgets/login_register_snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class AuthService {


  
  // get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // log in
  Future<Map<String, dynamic>> loginFirebase(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      print("✅ Itt a data ${data}");
      return data;
    } else {
      throw Exception("Nincs ilyen felhasználó az adatbázisban.");
    }

  } on FirebaseAuthException catch (e) {
    throw Exception("Hiba a bejelentkezésnél: ${e.code}");
  }
}






  Future<appUser> getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return appUser.fromMap(doc.data()!);
  }




  //Reistration and save the database
  Future<void> registrationFirebase(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;
       await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'address': [],
      'accountCreated': Timestamp.now(),
    });
    }
    on FirebaseAuthException catch (e) {
       String errorMsg;
        switch (e.code) {
          case 'email-already-in-use':
            errorMsg = 'Ez az e-mail cím már használatban van.';
            break;
          case 'invalid-email':
            errorMsg = 'Érvénytelen e-mail cím.';
            break;
          case 'weak-password':
            errorMsg = 'A jelszó túl gyenge. Legalább 6 karakter legyen.';
            break;
          default:
            errorMsg = 'Ismeretlen hiba történt';
        }
        print(errorMsg);
        showLoginRegisterSnackbar('Hiba:', message: errorMsg);
    }
  }

  // log out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
