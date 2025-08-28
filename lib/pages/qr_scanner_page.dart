import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_order_app/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;


class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController cameraController = MobileScannerController();
  String? lastScanned;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchOrderStatus(String id) async {
    final url = Uri.parse('$baseURL/api/orders/$id/status');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // Például: { "valid": true, "deliveryStatus": "Pending", "orderNumber": 123 }
    } else {
      throw Exception('Failed to fetch order status');
    }
  }

  void onBarcodeDetected(String code) async {
    if (code == null || code == lastScanned) return;
    lastScanned = code;

    String orderId = code;

    // Ha a QR kód JSON, pl: {"id":"12345"}
    try {
      final parsed = jsonDecode(code);
      if (parsed['id'] != null) {
        orderId = parsed['id'].toString();
      }
    } catch (_) {
      // Nem JSON, sima string-ként kezeljük
    }

    Map<String, dynamic> orderData;
    try {
      orderData = await fetchOrderStatus(orderId);
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Could not fetch order status: $e'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final bool canAccept = orderData['valid'] ?? false;
    final String status = orderData['deliveryStatus'] ?? 'Unknown';
    final int orderNumber = orderData['orderNumber'] ?? 0;

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(canAccept ? 'Order #$orderNumber is Pending' : 'Order #$orderNumber'),
        content: Text(canAccept
            ? 'Do you want to accept this order?'
            : 'This order cannot be accepted. Current status: $status'),
        actions: [
          if (canAccept)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await acceptOrder(orderId);
              },
              child: const Text('Accept'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> acceptOrder(String id) async {
    final url = Uri.parse('$baseURL/api/orders/$id/status'); // itt a backendben kell, hogy kezelje az "Accept" műveletet
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'accept'}),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order accepted successfully!')),
        );
      } else {
        throw Exception('Failed to accept order');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: cameraController,
            fit: BoxFit.cover,
            onDetect: (barcodeCapture) {
              final barcode = barcodeCapture.barcodes.first;
              final code = barcode.rawValue;
              if (code != null) {
                onBarcodeDetected(code);
              }
            },
          ),
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
