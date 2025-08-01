import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_order_app/components/custom_food_tile.dart';
import 'package:food_order_app/models/newmodels/category.dart';
import 'package:food_order_app/models/newmodels/hooks/fetchFoodsByCategories.dart';
import 'package:food_order_app/pages/food_page.dart';
import 'package:lottie/lottie.dart';

class Foods extends HookWidget {
  final CategoryModel category;

  const Foods({super.key, required this.category});

  @override
Widget build(BuildContext context) {
  final selectedCategoryList = useMemoized(() => [category], [category]);
  final foodHook = useFetchFoods(selectedCategoryList);

  if (foodHook.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (foodHook.exception != null) {
    return Center(child: Text('Hiba: ${foodHook.exception}'));
  }

  final foodList = foodHook.data;

  if (foodList.isEmpty) {
   return  Center(child: Text("Nincs ebben a kategoriaban etel"),);
  }

  return ListView.builder(
    itemCount: foodList.length,
    itemBuilder: (context, index) {
      final food = foodList[index];
      return FoodTile(
        food: food,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodPage(food: food)),
        ),
      );
    },
  );
}
}

