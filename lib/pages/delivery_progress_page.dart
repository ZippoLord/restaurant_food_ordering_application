import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_receipt.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/services/database/firestore.dart';
import 'package:provider/provider.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  // get access to database
  FirestoreService db = FirestoreService();

  @override
  void initState() {
    super.initState();

    // if we get to this page, submit order to firestore db
    String receipt = context.read<Restaurant>().displayCartReceipt();
    db.saveOrderToDatabase(receipt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Szállítás folyamatban..."),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          CustomReceipt(),
        ],
      ),
    );
  }
}