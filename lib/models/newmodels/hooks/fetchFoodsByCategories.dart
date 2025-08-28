import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:food_order_app/constants.dart';
import 'package:food_order_app/models/newmodels/category_model.dart';
import 'package:food_order_app/models/newmodels/food_model.dart';
import 'package:food_order_app/models/newmodels/hooks/hooks.dart';

FetchHooks useFetchFoods(List<CategoryModel> categories) {
  final foodItems = useState<List<FoodModel>>([]);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  final isMounted = useIsMounted();
  final cacheRef = useRef<Map<String, List<FoodModel>>>({});

  Future<void> fetchData() async {
    if (isMounted()) isLoading.value = true;
    List<FoodModel> allFoods = [];

    try {
      for (final category in categories) {
        if (cacheRef.value.containsKey(category.value)) {
          allFoods.addAll(cacheRef.value[category.value]!);
        } else {
          final res =
              await http.get(Uri.parse('$baseURL/api/food/${category.value}'));
          if (res.statusCode == 200) {
            final foods = foodModelFromJson(res.body);
            cacheRef.value[category.value] = foods;
            allFoods.addAll(foods);
          } else {
            if (isMounted()) {
              error.value = Exception(
                  "Hiba a(z) ${category.value} kategória lekérésénél: ${res.statusCode}");
            }
          }
        }
      }

      if (isMounted()) {
        foodItems.value = allFoods;
      }
    } catch (e) {
      if (isMounted()) {
        error.value = e is Exception ? e : Exception("Unexpected: $e");
      }
    } finally {
      if (isMounted()) {
        isLoading.value = false;
      }
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, [categories]);

  return FetchHooks(
    data: foodItems.value,
    isLoading: isLoading.value,
    exception: error.value,
    refetch: fetchData,
  );
}
