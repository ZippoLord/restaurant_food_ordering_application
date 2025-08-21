import 'package:food_order_app/constants.dart';
import 'package:food_order_app/models/newmodels/category_model.dart';
import 'package:food_order_app/models/newmodels/food_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_order_app/models/newmodels/apiError.dart';
import 'package:food_order_app/models/newmodels/hooks/hooks.dart';

FetchHooks useFetchFoods(List<CategoryModel> categories) {
  final foodItems = useState<List<FoodModel>>([]);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    List<FoodModel> allFoods = [];

    try {
      for (final category in categories) {
        final categoryValue = category.value;
        final res = await http.get(Uri.parse('$baseURL/api/food/$categoryValue'));
          print("📦 Lekért kategória: ${category.title} - value: ${category.value}");
        if (res.statusCode == 200) {
          final foods = foodModelFromJson(res.body);
          allFoods.addAll(foods);
          for (final food in foods) {
            print("🍕 ${food.title} (${food.category} ${food.additives})");
          }     
        } else {
          print("❌ Error in ${category.value}: ${res.statusCode}");
        }
      }

      foodItems.value = allFoods;
    } catch (e) {
      error.value = e is Exception ? e : Exception('Unexpected: $e');
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, [categories]); 
  void refetch() => fetchData();

  return FetchHooks(
    data: foodItems.value,
    isLoading: isLoading.value,
    exception: error.value,
    refetch: refetch,
  );
}
