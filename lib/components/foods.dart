import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_order_app/components/custom_food_tile.dart';
import 'package:food_order_app/models/newmodels/category_model.dart';
import 'package:food_order_app/models/newmodels/hooks/fetchFoodsByCategories.dart';
import 'package:food_order_app/pages/food_page.dart';

class Foods extends HookWidget {
  final CategoryModel category;

  const Foods({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // csak akkor hoz létre új listát, ha a category tényleg változik
    final selectedCategoryList = useMemoized(() => [category], [category]);
    final foodHook = useFetchFoods(selectedCategoryList);

    // betöltés
    if (foodHook.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // hiba
    if (foodHook.exception != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hiba történt: ${foodHook.exception}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: foodHook.refetch,
              child: const Text("Újrapróbálom"),
            ),
          ],
        ),
      );
    }

    final foodList = foodHook.data;

    // üres lista
    if (foodList.isEmpty) {
      return const Center(
        child: Text("Nincs ebben a kategóriában étel"),
      );
    }

    // lista megjelenítése
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
