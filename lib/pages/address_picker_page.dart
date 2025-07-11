import 'package:flutter/material.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class AddressPicker extends StatefulWidget {
  AddressPicker({super.key});
  final String apikey = dotenv.env['GOOGLE_API_KEY'] ?? 'default_key';

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  // REPLACE WITH OWN API KEY
 
  late GooglePlace _googlePlace;
  @override
  void initState() {
    super.initState();
    _googlePlace = GooglePlace(widget.apikey);
  }

  void _showAddAddressDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    List<AutocompletePrediction> predictions = [];
    String errorMessage = '';

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text("Cím keresése"),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: "Írd be a címed...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) async {
                            if (value.isNotEmpty) {
                              // clear error message when user types
                              if (errorMessage.isNotEmpty) {
                                setState(() {
                                  errorMessage = '';
                                });
                              }

                              var result = await _googlePlace.autocomplete.get(
                                value,
                                language: "hu",
                                components: [Component("country", "hu")],
                                types: "address", // focus on street addresses
                              );
                              if (result != null &&
                                  result.predictions != null) {
                                setState(() {
                                  predictions = result.predictions!;
                                });
                              }
                            } else {
                              setState(() {
                                predictions = [];
                              });
                            }
                          },
                        ),
                        if (errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: predictions.length,
                            itemBuilder: (context, index) {
                              final prediction = predictions[index];
                              String displayText = _formatAddressDisplay(
                                prediction,
                              );

                              return ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text(
                                  displayText,
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  bool isStreetLevel = _isStreetLevelAddress(
                                    prediction,
                                  );

                                  if (isStreetLevel) {
                                    // check if address already contains a house number
                                    final addressInfo = _extractAddressInfo(
                                      displayText,
                                    );

                                    if (addressInfo['houseNumber'] != null) {
                                      // address already has a house number, save it directly
                                      Navigator.pop(context);
                                      final fullAddress = displayText;
                                      context.read<Restaurant>().addAddress(
                                        fullAddress,
                                      );
                                      context
                                          .read<Restaurant>()
                                          .updateDeliveryAddress(fullAddress);
                                    } else {
                                      // no house number found, show dialog to input it
                                      Navigator.pop(context);
                                      _showHouseNumberDialog(
                                        context,
                                        displayText,
                                      );
                                    }
                                  } else {
                                    // show error if not street level
                                    setState(() {
                                      errorMessage =
                                          'Please select a street-level address, not just a city or area';
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Mégse"),
                    ),
                  ],
                ),
          ),
    );
  }

  String _formatAddressDisplay(AutocompletePrediction prediction) {
    if (prediction.structuredFormatting == null) {
      return prediction.description ?? "";
    }

    final mainText = prediction.structuredFormatting?.mainText ?? "";
    final secondaryText = prediction.structuredFormatting?.secondaryText ?? "";

    final postalCodeRegex = RegExp(r'\b\d{4}\b');
    final postalMatch = postalCodeRegex.firstMatch(secondaryText);
    String postalCode = "";

    if (postalMatch != null) {
      postalCode = postalMatch.group(0) ?? "";
    }

    String cityName = "";
    if (secondaryText.contains(',')) {
      final parts = secondaryText.split(',');
      for (final part in parts) {
        final trimmed = part.trim();
        if (!trimmed.contains(postalCodeRegex) && trimmed.isNotEmpty) {
          cityName = trimmed;
          break;
        }
      }
    } else {
      cityName = secondaryText.replaceAll(postalCodeRegex, '').trim();
    }

    // format display text
    if (postalCode.isNotEmpty && cityName.isNotEmpty) {
      return "$postalCode, $cityName, $mainText";
    } else if (cityName.isNotEmpty) {
      return "$cityName, $mainText";
    } else {
      return prediction.description ?? "";
    }
  }

  // helper method for street name and house number
  Map<String, String?> _extractAddressInfo(String address) {
    final houseNumberRegex = RegExp(
      r'\b\d+(?:[-\/]?\w*)?(?:\s*[-\/]\s*\d+(?:\w*)?)?$',
    );
    final match = houseNumberRegex.firstMatch(address);

    if (match != null) {
      final houseNumber = match.group(0);
      final streetPart = address.substring(0, match.start).trim();

      return {'street': streetPart, 'houseNumber': houseNumber};
    }

    return {'street': address, 'houseNumber': null};
  }

  // helper method to check if address contains a street
  bool _isStreetLevelAddress(AutocompletePrediction prediction) {
    final description = prediction.description?.toLowerCase() ?? "";
    final types = prediction.types ?? [];

    bool hasStreetComponent =
        types.contains('route') ||
        types.contains('street_address') ||
        description.contains('utca') ||
        description.contains('út') ||
        description.contains('tér') ||
        description.contains('körút');

    if (prediction.structuredFormatting != null) {
      final mainText =
          prediction.structuredFormatting?.mainText?.toLowerCase() ?? "";
      // check if main text contains street type name
      if (mainText.contains('utca') ||
          mainText.contains('út') ||
          mainText.contains('tér') ||
          mainText.contains('körút')) {
        return true;
      }
    }

    return hasStreetComponent;
  }

  void _showHouseNumberDialog(BuildContext context, String street) {
    final TextEditingController houseNumberController = TextEditingController();
    bool isError = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text("Add meg a házszámot!"),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cím: $street",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        SizedBox(height: 16),

                        // house number input field
                        TextField(
                          controller: houseNumberController,
                          decoration: InputDecoration(
                            hintText: "Házszám",
                            labelText: "Házszám",
                            errorText:
                                isError ? "Add meg a házszámot!" : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    // cancel button
                    MaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Mégse"),
                    ),

                    // save button
                    MaterialButton(
                      onPressed: () {
                        // check if house number is provided
                        if (houseNumberController.text.trim().isEmpty) {
                          setState(() {
                            isError = true;
                          });
                          return;
                        }

                        // street + and house number
                        final fullAddress =
                            "$street ${houseNumberController.text.trim()}";

                        // save full address
                        context.read<Restaurant>().addAddress(fullAddress);
                        context.read<Restaurant>().updateDeliveryAddress(
                          fullAddress,
                        );

                        Navigator.pop(context);
                      },
                      child: const Text("Mentés"),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cím kiválasztása"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(context),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Consumer<Restaurant>(
        builder: (context, restaurant, child) {
          if (restaurant.savedAddresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Kattints a plusz gombra az első cím hozzáadásához!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          // if there are saved addresses, show them as a list
          return ListView.builder(
            itemCount: restaurant.savedAddresses.length,
            padding: const EdgeInsets.only(
              bottom: 80,
            ), // add padding at the bottom
            itemBuilder: (context, index) {
              final address = restaurant.savedAddresses[index];
              final isSelected = address == restaurant.deliveryAddress;

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2)
                          : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      isSelected
                          ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                          : null,
                ),
                child: ListTile(
                  title: Text(
                    address,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => restaurant.removeAddress(address),
                  ),
                  onTap: () {
                    restaurant.updateDeliveryAddress(address);
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
