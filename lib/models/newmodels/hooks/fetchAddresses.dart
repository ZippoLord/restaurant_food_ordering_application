import 'package:food_order_app/constants.dart';
import 'package:food_order_app/controllers/login_controller.dart';
import 'package:food_order_app/models/newmodels/additive_model.dart';
import 'package:food_order_app/models/newmodels/address_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_order_app/models/newmodels/apiError.dart';
import 'package:food_order_app/models/newmodels/category_model.dart';
import 'package:food_order_app/models/newmodels/hooks/hooks.dart';

FetchHooks  useFetchAddresses(){
  final addresses = useState<List<AddressModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future <void> fetchData() async {
    isLoading.value = true;
    final userId = box.read("userId");
    try{
      final response = await http.get(Uri.parse('$baseURL/api/address/getAllAddress/$userId'));
      if(response.statusCode == 200){
        addresses.value = addressModelFromJson(response.body);
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

  return FetchHooks(data: addresses.value, isLoading: isLoading.value, exception: error.value, refetch: refetch);
}