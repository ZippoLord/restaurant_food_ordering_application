import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/components/attention.dart';
import 'package:food_order_app/controllers/address_controller.dart';
import 'package:food_order_app/controllers/login_controller.dart';
import 'package:food_order_app/controllers/user_location_controller.dart';
import 'package:food_order_app/models/newmodels/login_response.dart';
import 'package:food_order_app/themes/theme_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
class CustomAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final AddressController addressController = Get.put(AddressController());
  final UserLocationController controller = Get.put(UserLocationController());
  final LoginController userController = Get.put(LoginController());
  final token = GetStorage().read("token");
  final userId = GetStorage().read("userId");

      @override
    void initState() {
      super.initState();
      addressController.fetchAddresses(token, userId);
      userController.fetchUserData(token);
    }


  @override
  Widget build(BuildContext context) {

    print(addressController.addresses);
    return Container(
      height: 130.h,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              widget.scaffoldKey.currentState?.openDrawer();
            },
            child: Obx(() {
              final hasAddress = addressController.addresses.isNotEmpty;
              final setupDone = userController.firstSetup.value;

              if(hasAddress && setupDone){
                return CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.amberAccent,
                  child: Icon(Icons.person, color: Colors.white),
                );
              } else {
                return AttentionButton( //TODO: FIX 
                  child: Icon(Icons.person, color: Colors.white),
                  onTap: () {
                    widget.scaffoldKey.currentState?.openDrawer();
                  },
                );
              }
            })
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tartózkodási hely",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => SizedBox(
                    width: 500 * 0.65,
                    child: Text(
                      controller.address == ""
                          ? "Nem sikerült lekérni a címet"
                          : controller.address,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Dark mode váltó
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => CupertinoSwitch(
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}
