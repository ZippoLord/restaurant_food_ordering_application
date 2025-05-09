import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/models/cart_item.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'food.dart';

class Restaurant extends ChangeNotifier {
  static const String _addressesKey = 'saved_addresses';
  static const String _currentAddressKey = 'current_address';

  final List<Food> _menu = [
    // burgers
    Food(
      name: "Classic Cheeseburger",
      description:
          "A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle.",
      imagePath: "lib/images/burgers/burger.png",
      price: 2790,
      foodCategory: FoodCategory.burgerek,
      availableAddons: [
        Addon(name: "Extra cheese", price: 150),
        Addon(name: "Bacon", price: 350),
        Addon(name: "Avocado", price: 200),
      ],
    ),

    Food(
      name: "Tomatonator",
      description:
          "A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle.",
      imagePath: "lib/images/burgers/burger.png",
      price: 2490,
      foodCategory: FoodCategory.burgerek,
      availableAddons: [
        Addon(name: "Extra cheese", price: 150),
        Addon(name: "Bacon", price: 350),
        Addon(name: "Avocado", price: 200),
      ],
    ),

    Food(
      name: "Burger",
      description:
          "A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle.",
      imagePath: "lib/images/burgers/burger.png",
      price: 2390,
      foodCategory: FoodCategory.burgerek,
      availableAddons: [
        Addon(name: "Extra cheese", price: 150),
        Addon(name: "Bacon", price: 350),
        Addon(name: "Avocado", price: 200),
      ],
    ),

    // salads
    Food(
      name: "Caesar",
      description:
          "A juicy salad with yogurt, lettuce, tomato, and a hint of onion.",
      imagePath: "lib/images/salads/salad.png",
      price: 2990,
      foodCategory: FoodCategory.salatak,
      availableAddons: [
        Addon(name: "Tomato", price: 150),
        Addon(name: "Onion", price: 350),
        Addon(name: "Lettuce", price: 200),
      ],
    ),

    Food(
      name: "Greek salad",
      description:
          "A juicy salad with yogurt, lettuce, tomato, and a hint of onion.",
      imagePath: "lib/images/salads/salad.png",
      price: 2490,
      foodCategory: FoodCategory.salatak,
      availableAddons: [
        Addon(name: "Tomato", price: 150),
        Addon(name: "Onion", price: 350),
        Addon(name: "Lettuce", price: 200),
      ],
    ),

    Food(
      name: "Tuna salad",
      description:
          "A juicy salad with yogurt, lettuce, tomato, and a hint of onion.",
      imagePath: "lib/images/salads/salad.png",
      price: 3200,
      foodCategory: FoodCategory.salatak,
      availableAddons: [
        Addon(name: "Tomato", price: 150),
        Addon(name: "Onion", price: 350),
        Addon(name: "Lettuce", price: 200),
      ],
    ),

    // sides
    Food(
      name: "French fries",
      description: "Some fries with seasoning.",
      imagePath: "lib/images/sides/side.png",
      price: 1290,
      foodCategory: FoodCategory.koretek,
      availableAddons: [
        Addon(name: "Melted cheese", price: 150),
        Addon(name: "Pepper", price: 350),
        Addon(name: "Bacon", price: 200),
      ],
    ),

    Food(
      name: "Steak fries",
      description: "Some steak fries with seasoning.",
      imagePath: "lib/images/sides/side.png",
      price: 1590,
      foodCategory: FoodCategory.koretek,
      availableAddons: [
        Addon(name: "Melted cheese", price: 150),
        Addon(name: "Pepper", price: 350),
        Addon(name: "Bacon", price: 200),
      ],
    ),

    Food(
      name: "Croquette",
      description: "Some croquettes with seasoning.",
      imagePath: "lib/images/sides/side.png",
      price: 1690,
      foodCategory: FoodCategory.koretek,
      availableAddons: [
        Addon(name: "Melted cheese", price: 150),
        Addon(name: "Pepper", price: 350),
        Addon(name: "Bacon", price: 200),
      ],
    ),

    // drinks
    Food(
      name: "Coke",
      description: "Strawberry cake.",
      imagePath: "lib/images/drinks/drink.png",
      price: 750,
      foodCategory: FoodCategory.italok,
      availableAddons: [
        Addon(name: "Melted cheese", price: 150),
        Addon(name: "Pepper", price: 350),
        Addon(name: "Bacon", price: 200),
      ],
    ),

    Food(
      name: "Ice tea",
      description: "Strawberry cake.",
      imagePath: "lib/images/drinks/drink.png",
      price: 750,
      foodCategory: FoodCategory.italok,
      availableAddons: [
        Addon(name: "Melted cheese", price: 150),
        Addon(name: "Pepper", price: 350),
        Addon(name: "Bacon", price: 200),
      ],
    ),
    Food(
      name: "Lemonade",
      description: "Strawberry cake.",
      imagePath: "lib/images/drinks/drink.png",
      price: 750,
      foodCategory: FoodCategory.italok,
      availableAddons: [
        Addon(name: "Melted cheese", price: 150),
        Addon(name: "Pepper", price: 350),
        Addon(name: "Bacon", price: 200),
      ],
    ),
  ];

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

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  List<String> get savedAddresses => _savedAddresses;
  String get deliveryAddress => _deliveryAddress;

  /*
  OPERATIONS
  */

  // add to cart
  void addToCart(Food food, List<Addon> selectedAddons) {
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
      cartItem.quantity++;
    }
    // otherwise, add a new cart item to the cart
    else {
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
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
    }
    notifyListeners();
  }

  // get total price of items in the cart
  int getTotalPrice() {
    int total = 0;

    for (CartItem cartItem in _cart) {
      int itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
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

  // generate a receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Nyugta\n");

    // format date
    String formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());

    receipt.writeln("$formattedDate");
    receipt.writeln();
    receipt.writeln(
      "------------------------------------------------------------",
    );
    receipt.writeln();

    for (final cartItem in _cart) {
      receipt.writeln(
        "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}\n",
      );

      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln(
          "   Add-ons:\n   ${_formatAddons(cartItem.selectedAddons)}",
        );
      }
      receipt.writeln();
    }

    receipt.writeln(
      "------------------------------------------------------------",
    );
    receipt.writeln();
    receipt.writeln("Tételek száma: ${getTotalItemCount()}\n");
    receipt.writeln("Teljes ár: ${_formatPrice(getTotalPrice())}\n");
    receipt.writeln("Szállítási cím: $deliveryAddress\n");

    return receipt.toString();
  }

  // format money
  String _formatPrice(int price) {
    return "$price Ft";
  }

  // format list of addons
  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }
}
