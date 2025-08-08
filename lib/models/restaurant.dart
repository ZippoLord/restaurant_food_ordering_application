import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/models/cart_item.dart';
import 'package:food_order_app/models/newmodels/additive.dart';
import 'package:food_order_app/models/newmodels/food.dart';
import 'package:food_order_app/pages/food_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'food.dart';



class Restaurant extends ChangeNotifier {
  static const String _addressesKey = 'saved_addresses';
  static const String _currentAddressKey = 'current_address';
  final controller = Get.find<CartController>();
  // user cart
  final List<CartItem> _cart = [];

  // list of saved addresses
  final List<String> _savedAddresses = [];

  // delivery address
  String _deliveryAddress = 'Válassz szállítási címet!';

  // constructor to load saved addresses when created
  Restaurant() {
    _loadAddresses();
  }

  /*
  GETTERS
  */

  List<CartItem> get cart => _cart;
  List<String> get savedAddresses => _savedAddresses;
  String get deliveryAddress => _deliveryAddress;

  /*
  OPERATIONS
  */

  

      List<CartItem> addToCart(FoodModel food, List<AdditiveModel> selectedAddons, {int quantity = 1}) {
        // see if there is a cart item already with the same food and addons selected
        CartItem? cartItem = _cart.firstWhereOrNull((item) {
          bool isSameFood = item.food == food;

          bool isSameAddons = ListEquality().equals(
            item.selectedAddons,
            selectedAddons,
          );
          return isSameFood && isSameAddons;
        });

        // if item already exists, increase it's quantity
        if (cartItem != null) {
          cartItem.quantity += quantity;
        }
        // otherwise, add a new cart item to the cart
        else {
          _cart.add(CartItem(food: food, selectedAddons: selectedAddons, quantity: quantity));
        }
        controller.cartItem.value = _cart.fold(0, (sum, item) => sum + item.quantity);
        controller.update();
        //print("Cartitem: ${controller.cartItem}");
        controller.resetQuantityToItems();
        notifyListeners();
        //print(_cart.map((e) => e.toJson()).toList());
        return _cart;
      }
  
  // add to cart
  // remove from cart
  void addItemToCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity++;
        controller.cartItem.value= _cart.fold(0, (sum, item) => sum + item.quantity);
        controller.update();
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }


  // remove from cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
        controller.cartItem.value = _cart.fold(0, (sum, item) => sum + item.quantity);
        controller.update();
    }
    notifyListeners();
  }

  // get total price of items in the cart
  double getTotalPrice() {
    double total = 0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

        for (AdditiveModel addon in cartItem.selectedAddons) {
          itemTotal += addon.price;
        }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  // get total number of items in the cart
  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  // clear cart
  void clearCart() {
    _cart.clear();
    controller.cartItem.value = 0;
    controller.update();
    notifyListeners();
  }

  // update delivery address
  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    _saveAddresses();
    notifyListeners();
  }

  // address management methods
  void addAddress(String address) {
    if (!_savedAddresses.contains(address)) {
      _savedAddresses.add(address);
      _saveAddresses();
      notifyListeners();
    }
  }

  void removeAddress(String address) {
    if (_savedAddresses.contains(address)) {
      _savedAddresses.remove(address);

      if (_deliveryAddress == address) {
        _deliveryAddress =
            _savedAddresses.isNotEmpty
                ? _savedAddresses[0]
                : 'Válaszd ki a szállítási címet!';
      }
      _saveAddresses();
      notifyListeners();
    }
  }

  // load addresses from SharedPreferences
  Future<void> _loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load saved addresses
      final addressesJson = prefs.getStringList(_addressesKey);
      if (addressesJson != null) {
        _savedAddresses.clear();
        _savedAddresses.addAll(addressesJson);
      }

      // Load current delivery address
      final currentAddress = prefs.getString(_currentAddressKey);
      if (currentAddress != null) {
        _deliveryAddress = currentAddress;
      }

      notifyListeners();
    } catch (e) {
      print('Error loading addresses: $e');
    }
  }

  // save addresses to SharedPreferences
  Future<void> _saveAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // save addresses list
      await prefs.setStringList(_addressesKey, _savedAddresses);

      // save current address
      await prefs.setString(_currentAddressKey, _deliveryAddress);
    } catch (e) {
      print('Error saving addresses: $e');
    }
  }




  /*
  HELPERS
  */
 String displayCartReceipt()
 {
   //generate a receipt
  
      final receipt = StringBuffer();
      receipt.writeln("Nyugta\n");

      // format date
      String formattedDate = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());

      receipt.writeln(formattedDate);
      receipt.writeln();
      receipt.writeln(
        "------------------------------------------------------------",
      );
      receipt.writeln();

      for (final cartItem in _cart) {
        receipt.writeln(
        //  "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}\n",
        );

        if (cartItem.selectedAddons.isNotEmpty) {
          receipt.writeln(
       //     "   Add-ons:\n   ${_formatAddons(cartItem.selectedAddons)}",
          );
        }
        receipt.writeln();
      }

      receipt.writeln(
        "------------------------------------------------------------",
      );
      receipt.writeln();
      receipt.writeln("Tételek száma: ${getTotalItemCount()}\n");
      //Rreceipt.writeln("Teljes ár: ${_formatPrice(getTotalPrice())}\n");
      receipt.writeln("Szállítási cím: $deliveryAddress\n");

      addToDatabaseJson();
      return receipt.toString();
    }

    // format money
    String _formatPrice(int price) {
      return "$price Ft";
    }


   
    List<Map<String, dynamic>> addToDatabaseJson() {
      try{
        final jsonList = _cart.map((e) => e.toJson()).toList();
        print("Itt vannak az adatok $jsonList");
        return jsonList;
      }
      catch(e)
      {
        print("Hiba tortent $e");
        return [];
      }
  }


}
 
 




