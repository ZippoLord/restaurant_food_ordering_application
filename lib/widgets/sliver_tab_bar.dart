import 'package:flutter/material.dart';

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SliverTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child is PreferredSizeWidget
      ? (child as PreferredSizeWidget).preferredSize.height
      : child is SizedBox
          ? (child as SizedBox).height ?? 50.0
          : 50.0;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant SliverTabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
