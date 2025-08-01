import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/components/custom_drawer.dart';
import 'package:food_order_app/components/foods.dart';
import 'package:food_order_app/models/food.dart';
import 'package:food_order_app/models/newmodels/hooks/fetchCategories.dart';
import 'package:food_order_app/components/category_list.dart';
import 'package:food_order_app/widgets/custom_appbar.dart';
import 'package:food_order_app/widgets/custom_container.dart';
import 'package:food_order_app/widgets/sliver_tab_bar.dart';
import 'package:lottie/lottie.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesHook = useFetchCategories();
    final categories = categoriesHook.data;
    final isLoading = categoriesHook.isLoading;

    final selectedIndex = useState(0);

    if (categories == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tabController = useTabController(initialLength: categories.length);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });

    final selectedCategory = categories[selectedIndex.value];


    if(isLoading){
      Center(child: Lottie.asset("/lib/images/loaders/Food Carousel.json"));
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
          containerContent: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverTabBarDelegate(
                  child: SizedBox(
                    height: 80.h,
                    child: CategoryList(
                      categories: categories,
                      tabController: tabController,
                      selectedIndex: selectedIndex.value,
                    ),
                  ),
                ),
              ),
            ],
              body: TabBarView(
                controller: tabController,
                children: categories.map<Widget>((cat) {
                  return Foods(category: cat);
                }).toList(), 
              ),
          ),
        ),
      ),
    );
  }
}
