import 'package:flutter/material.dart';
import 'package:food_order_app/components/app_icon.dart';
import 'package:food_order_app/models/cart_item.dart';
import 'package:food_order_app/models/food.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/dimensions.dart';
import 'package:food_order_app/pages/cart_page.dart';
import 'package:food_order_app/widgets/addon_column.dart';
import 'package:food_order_app/widgets/app_column.dart';
import 'package:food_order_app/widgets/expendable_text_wigdet.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartController extends GetxController{

    int selectedItems = 0;
    var cartItem = 0.obs;

    void addQuantityToItem(){
      selectedItems++;
      print("incremented ${selectedItems}");
      update();
    }
    void removeQuantityToItem(){
      if(selectedItems > 0) 
      selectedItems--; 
      print("decremented ${selectedItems}");
      update();
    }

    void resetQuantityToItems(){
      selectedItems = 0;
    }

}



class FoodPage extends StatefulWidget {
  final Food food;
  final Map<Addon, bool> selectedAddons = {};

  FoodPage({
    super.key,
    required this.food,
  }){
    // initialize selected addons to be false

    if(food.availableAddons != null && food.availableAddons!.isNotEmpty){
      for (Addon addon in food.availableAddons!) {
        selectedAddons[addon] = false; 
      }
    }
  }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  // method to add to cart
  void addToCart(Food food, Map<Addon, bool> selectedAddons) {
    final controller = Get.find<CartController>();
    // close the current food page to go back to menu
    //Navigator.pop(context);

    // format the selected addons
    List<Addon> currentlySelectedAddons = [];
    for (Addon addon in widget.food.availableAddons!) {
      if (widget.selectedAddons[addon] == true) {
        currentlySelectedAddons.add(addon);
      }
    }
    // add to cart
    context.read<Restaurant>().addToCart(food, currentlySelectedAddons, quantity: controller.selectedItems);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: 320,
              decoration: BoxDecoration(
                image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.food.imagePath)
                ),
              ),
          ),
          ),
          Positioned(
            top: 45,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(1),
                  shape: const CircleBorder()
                ),
                child:const AppIcon(icon: Icons.arrow_back_ios),
              ),
              GetBuilder<CartController>(builder: (controller){
                return Stack(
                  children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                    child:AppIcon(icon: Icons.shopping_cart_outlined), 
                  ),
                  controller.cartItem >=1?
                  Positioned(
                    right: 0,
                    top: 0, 
                    child: 
                    AppIcon(icon: Icons.circle, size:22, 
                    iconColor: Colors.transparent, 
                    backgroundColor: Colors.red,)
                  )
                   : Container(),
                  controller.cartItem >=1?
                   Positioned(
                    right: 5,
                    top: 1,
                    child:
                    Text("${controller.cartItem}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                    ):Container()
                  ],
                );
              })
            ],
            )
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,            
            top: Dimensions.foodImgSize-80,
            child: Container(
            padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, top: Dimensions.height20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20)
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppColumn(foodName: widget.food.name, foodPrice: widget.food.price,),
                  SizedBox(height: Dimensions.height20,),
                  Text("Leírás", style: TextStyle(fontSize: 24, fontWeight:  FontWeight.w400),), 
                  ExpendableTextWidget(description: widget.food.description), 
                  SizedBox(height: 22,),
                  Text(widget.selectedAddons.isNotEmpty?"Extra feltétek 💥":" ", 
                  style: TextStyle(fontSize: 24, fontWeight:  FontWeight.w400),), 
                  AddonColumn(addons: widget.selectedAddons,
                  onSelectedChanged: (addon, selected){
                    setState(() {
                        widget.selectedAddons[addon] = selected;
                    });
                  },), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: Dimensions.bottomHeightBar,
        padding: EdgeInsets.only(top:Dimensions.height20, bottom: Dimensions.width20, left: Dimensions.width20, right: Dimensions.width20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20*2),
            topRight: Radius.circular(Dimensions.radius20*2),
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, right: Dimensions.width20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  SizedBox(width: Dimensions.width10/2,),
                  IconButton(
                  onPressed: () {
                    Get.find<CartController>().removeQuantityToItem(); 
                  },
                  icon:  Icon(Icons.remove, color: Colors.red),
                  ),
                  SizedBox(width: Dimensions.width10/2,),
                  GetBuilder<CartController>(
                    builder: (controller){
                      return Text("${controller.selectedItems}");
                    },
                  ),
                  SizedBox(width: Dimensions.width10/2,),
                  IconButton(
                  onPressed: () {
                    Get.find<CartController>().addQuantityToItem(); 
                  },
                  icon:  Icon(Icons.add, color: Colors.red),
                  )
                ],
              ),
            ),

            InkWell(
              onTap: (){
                final controller = Get.find<CartController>();
                if(controller.selectedItems == 0){
                   ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    dismissDirection: DismissDirection.up,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red[200],
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height-270,
                      left: Dimensions.width10,
                      right: Dimensions.width10,
                    ),
                    content: InkWell(
                    onTap: (){
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child:  
                    Text(style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500), 
                    'Adj meg egy mennyiséget! 🙄'),
                  ))
                );
                  return;
                } 
                addToCart(widget.food, widget.selectedAddons); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    dismissDirection: DismissDirection.up,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red[200],
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height-270,
                      left: Dimensions.width10,
                      right: Dimensions.width10,
                    ),
                    content: InkWell(
                    onTap: (){
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child:  
                    Text(style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500), 
                    '${widget.food.name} hozzáadva a kosaradhoz 😋'),
                  ))
                );
              },
              child: 
              Container(
              padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, left: Dimensions.width20, right: Dimensions.width20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.red,
              ),
              child: Text("Kosárba", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
            )
          ,)
          ],
        ),
      )
    );
  }
}