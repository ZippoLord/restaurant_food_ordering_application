import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:food_order_app/components/custom_button.dart';
import 'package:food_order_app/pages/delivery_progress_page.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:food_order_app/pages/payment_method_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  // scanner controller
  final CardScanOptions _scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    enableDebugLogs: true,
    validCardsToScanBeforeFinishingScan: 5,
    considerPastDatesInExpiryDateScan: false,
  );

  // scan card method
  Future<void> _scanCard() async {
    try {
      // show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      var cardDetails = await CardScanner.scanCard(scanOptions: _scanOptions);

      // close loading indicator
      Navigator.pop(context);

      if (cardDetails != null) {
        setState(() {
          // format card number
          cardNumber = cardDetails.cardNumber;

          // handle expiry date
          expiryDate = cardDetails.expiryDate;

          // set cardholder name
          cardHolderName = cardDetails.cardHolderName;

          // focus on CVV (becuase it's not scanned)
          isCvvFocused = true;
        });
      }
    } catch (e) {
      // close loading indicator (if still showing)
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error scanning card: $e")));
    }
  }

  // user wants to pay
  void userTappedPay() {
    if (formKey.currentState!.validate()) {
      // only show dialog if form is valid
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Confirm payment"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text("Kártyaszám: $cardNumber"),
                    Text("Lejárati dátum: $expiryDate"),
                    Text("Kártyához tartozó név: $cardHolderName"),
                    Text("CVC: $cvvCode"),
                  ],
                ),
              ),
              actions: [
                // cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                // yes button
                TextButton(
                  onPressed:
                      () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryProgressPage(),
                          ),
                        ),
                      },
                  child: const Text("Yes"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     foregroundColor: Theme.of(context).colorScheme.inversePrimary,
    //     title: const Text("Fizetési mód"),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         // credit card widget
    //         CreditCardWidget(
    //           cardNumber: cardNumber,
    //           expiryDate: expiryDate,
    //           cardHolderName: cardHolderName,
    //           cvvCode: cvvCode,
    //           showBackView: isCvvFocused,
    //           onCreditCardWidgetChange: (p0) {},
    //         ),

    //         // scan card button
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 25.0),
    //           child: ElevatedButton.icon(
    //             onPressed: _scanCard,
    //             icon: const Icon(Icons.camera_alt),
    //             label: const Text("Kártya beolvasása"),
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: Theme.of(context).colorScheme.surface,
    //               foregroundColor: Theme.of(context).colorScheme.inversePrimary,
    //               minimumSize: const Size(double.infinity, 45),
    //             ),
    //           ),
    //         ),

    //         const SizedBox(height: 10),

    //         // credit card form
    //         CreditCardForm(
    //           cardNumber: cardNumber,
    //           expiryDate: expiryDate,
    //           cardHolderName: cardHolderName,
    //           cvvCode: cvvCode,
    //           onCreditCardModelChange: (data) {
    //             setState(() {
    //               cardNumber = data.cardNumber;
    //               expiryDate = data.expiryDate;
    //               cardHolderName = data.cardHolderName;
    //               cvvCode = data.cvvCode;
    //               isCvvFocused = data.isCvvFocused;
    //             });
    //           },
    //           formKey: formKey,
    //         ),

    //         const SizedBox(height: 20),

    //         CustomButton(onTap: userTappedPay, text: "Fizetes"),

    //         const SizedBox(height: 25),
    //       ],
    //     ),
    //   ),
    // );
    return PaymentMethodPage();
  }
}
