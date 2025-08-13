import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildSkeletonLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: 16,
      width: 150,
      color: Colors.white,
    ),
  );
}
