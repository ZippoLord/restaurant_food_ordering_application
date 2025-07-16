import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/components/custom_drawer.dart';
import 'package:food_order_app/components/custom_food_tile.dart';
import 'package:food_order_app/models/food.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/food_page.dart';
import 'package:food_order_app/services/database/firestore.dart';
import 'package:food_order_app/components/category_list.dart';
import 'package:food_order_app/widgets/custom_appbar.dart';
import 'package:food_order_app/widgets/custom_container.dart';
import 'package:food_order_app/widgets/sliver_tab_bar.dart';
import 'package:food_order_app/components/Restaurants.dart';
import 'package:lottie/lottie.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final db = FirestoreService();

  List<Food> _menu = [];
  List<FoodCategory> _usedCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMenu();
  }

  Future<void> loadMenu() async {
    final fetchedMenu = await db.getAllFoodFromDatabase();
    final categories = fetchedMenu.map((f) => f.foodCategory).toSet().toList();

    setState(() {
      _menu = fetchedMenu;
      _usedCategories = categories;
      _tabController = TabController(length: _usedCategories.length, vsync: this);
      _isLoading = false;
    });

    // Frissít, ha oldalváltás történik
    _tabController.addListener(() {
      setState(() {}); // frissíti a selectedIndex-et a CategoryList-nek
    });
  }

  List<Widget> getFoodInThisCategory() {
    return _usedCategories.map((category) {
      List<Food> categoryMenu = _menu.where((f) => f.foodCategory == category).toList();
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          child: ListView.builder(
            itemCount: categoryMenu.length,
            itemBuilder: (context, index) {
              final food = categoryMenu[index];
              return FoodTile(
                food: food,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodPage(food: food)),
                ),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return  Scaffold(
        body: Center(child: Lottie.asset('lib/images/loaders/Food Carousel.json')),
      );
    }
    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: const CustomAppBar(),
      ),
      body: SafeArea(
        child: CustomContainer(
          containerContent: DefaultTabController(
            length: _usedCategories.length,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsSchrolled) => [
                SliverToBoxAdapter(
                  child: const Restaurants(mockMode: true,),
                ),
                SliverPersistentHeader( 
                  pinned: true,
                  delegate: SliverTabBarDelegate(
                    child: SizedBox(
                      height: 80.h,
                      child: CategoryList(
                        categories: _usedCategories,
                        tabController: _tabController,
                        selectedIndex: _tabController.index,
                      ),
                    ),
                  ),
                )
              ],
              body: TabBarView(
                controller: _tabController,
                children: getFoodInThisCategory(),
            ),
          ),
        ),)
      ),
    );
  }
}
