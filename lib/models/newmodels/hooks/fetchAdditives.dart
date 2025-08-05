import 'package:food_order_app/constants.dart';
import 'package:food_order_app/models/newmodels/additive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_order_app/models/newmodels/apiError.dart';
import 'package:food_order_app/models/newmodels/category.dart';
import 'package:food_order_app/models/newmodels/hooks/hooks.dart';

FetchHooks  useFetchAdditives(){
  final additives = useState<List<AdditiveModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future <void> fetchData() async {
    isLoading.value = true;

    try{
      final response = await http.get(Uri.parse('$baseURL/api/additives'));
      if(response.statusCode == 200){
        additives.value = additiveModelFromJson(response.body);
      }else{
        apiError.value = apiErrorFromJson(response.body);
      }
    }catch(e){
      error.value = e as Exception;
    }finally{
      isLoading.value = false;
    }
  }

  useEffect(() {
  fetchData();
  return null;
  }, []);

  void refetch(){
    isLoading.value = true;
    fetchData();
  }

  return FetchHooks(data: additives.value, isLoading: isLoading.value, exception: error.value, refetch: refetch);
}