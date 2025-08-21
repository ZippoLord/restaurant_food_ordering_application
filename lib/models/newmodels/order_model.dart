// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));


String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
    final String userId;
    final List<OrderItem> orderItems;
    final int orderTotal;
    final int fee;
    final int grandTotal;
    final int orderNumber;
    final String deliveryAddress;
    final String paymentMethod;
    final String paymentStatus;
    final String deliveryStatus;

    OrderModel({
        required this.userId,
        required this.orderItems,
        required this.orderTotal,
        required this.fee,
        required this.grandTotal,
        required this.orderNumber,
        required this.deliveryAddress,
        required this.paymentMethod,
        required this.paymentStatus,
        required this.deliveryStatus,
    });

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        userId: json["userId"],
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
        orderTotal: json["orderTotal"],
        fee: json["Fee"],
        grandTotal: json["grandTotal"],
        orderNumber: json["orderNumber"],
        deliveryAddress: json["deliveryAddress"],
        paymentMethod: json["paymentMethod"],
        paymentStatus: json["paymentStatus"],
        deliveryStatus: json["deliveryStatus"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "Fee": fee,
        "grandTotal": grandTotal,
        "orderNumber": orderNumber,
        "deliveryAddress": deliveryAddress,
        "paymentMethod": paymentMethod,
        "paymentStatus": paymentStatus,
        "deliveryStatus": deliveryStatus,
    };
}

class OrderItem {
    final String foodId;
    final int quantity;
    final int price;
    final List<String> additives;

    OrderItem({
        required this.foodId,
        required this.quantity,
        required this.price,
        required this.additives,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: json["foodId"],
        quantity: json["quantity"],
        price: json["price"],
        additives: List<String>.from(json["additives"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "foodId": foodId,
        "quantity": quantity,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
    };
}
