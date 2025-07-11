import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/components/custom_current_location.dart';
import 'package:food_order_app/components/custom_drawer.dart';
import 'package:food_order_app/components/custom_food_tile.dart';
import 'package:food_order_app/components/custom_sliver_app_bar.dart';
import 'package:food_order_app/components/custom_tab_bar.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/models/food.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/food_page.dart';
import 'package:food_order_app/services/database/firestore.dart';
import 'package:food_order_app/widgets/custom_appbar.dart';
import 'package:food_order_app/widgets/custom_container.dart';
import 'package:food_order_app/widgets/custom_indicator.dart';
import 'package:provider/provider.dart';


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

  
    // Derive used categories from fetched data
    final categories = fetchedMenu.map((food) => food.foodCategory).toSet().toList();

    setState(() {
      _menu = fetchedMenu;
      _usedCategories = categories;
      _tabController = TabController(length: _usedCategories.length, vsync: this);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Food> _filterMenuByCategory(FoodCategory category) {
    return _menu.where((food) => food.foodCategory == category).toList();
  }

  List<Widget> getFoodInThisCategory() {
    return _usedCategories.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category);


      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return FoodTile(
            food: food,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodPage(food: food),
              ),
            ),
          );
        },
      ),
      );
    }).toList();
  }

  List<Widget> _buildCategoryTabs() {
    return _usedCategories.map((category) {
      return Tab(
        child: SizedBox(
          width: 30,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 25,
              child: Image.asset('lib/images/navbaricons/pizza.png', 
              fit: BoxFit.contain
              )
            ),
          ],
        ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MyDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            appBar: PreferredSize(preferredSize: Size.fromHeight(130), child: CustomAppBar()),
            body: SafeArea(child: CustomContainer(
            containerContent:
              NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // CustomSliverAppBar(
                //   title: TabBar(
                //     controller: _tabController,
                //     isScrollable: true,
                //     tabs: _buildCategoryTabs(),
                //     labelColor: Colors.red,
                //     unselectedLabelColor: Colors.grey,
                //     indicatorColor: Colors.red,
                //   ),
                //   child: const Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       CustomCurrentLocation(),
                //     ],
                //   ),
                // ),
                  SliverAppBar(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(40),
                    child: Container(),
                  ),
                  toolbarHeight: 52,
                  flexibleSpace: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: TabBar(   
                      indicatorPadding: EdgeInsets.zero,
                    controller: _tabController,
                    isScrollable: true,
                    tabs: _buildCategoryTabs(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    labelColor: Theme.of(context).colorScheme.inversePrimary,
                    unselectedLabelColor: Colors.grey,
                    indicator: DotIndicator(
                      color: Colors.red,
                      radius: 4,
                    ),
                    indicatorWeight: 2,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                      unselectedLabelStyle: TextStyle(fontSize:  14),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: getFoodInThisCategory(),
              ),
            ), 
            )),
          )
    );
  }
}