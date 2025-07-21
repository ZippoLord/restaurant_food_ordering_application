import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_order_app/models/address.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddressController extends GetxController {
  
  RxList<Address> addressList = <Address>[].obs;  
  RxString selectedAddress = ''.obs;

  Future<void> fetchAddresses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnap = await docRef.get();
    List<dynamic> addressesRaw = docSnap.data()?['address'] ?? [];
    final parsedAddresses = addressesRaw.map((e) => Address.fromJson(Map<String, dynamic>.from(e))).toList();

    addressList.value = parsedAddresses;
  }

  Future<void> deleteAddressById(int id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    addressList.removeWhere((address) => address.id == id);
    await docRef.update({
      'address': addressList.map((a) => a.toJson()).toList(),
    });
    await fetchAddresses();
  }

  Future<void> getDefaultAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnap = await docRef.get();
    List<dynamic> addressesRaw = docSnap.data()?['address'] ?? [];
    final parsedAddresses = addressesRaw.map((e) => Address.fromJson(Map<String, dynamic>.from(e))).toList();

    addressList.value = parsedAddresses.where((address) => address.defaultAddress).toList();
  }
}
