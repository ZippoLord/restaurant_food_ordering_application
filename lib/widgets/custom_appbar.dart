import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/controllers/user_location_controller.dart';
import 'package:food_order_app/themes/theme_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  Future<void> _getCurrentLocation() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      print("helymeghatarozas ki van kapcsolva");
      return;
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied){ 
      print('Helyhozzaferes megtagadva');
      return;
    }

    try{
      final controller = Get.put(UserLocationController());
      Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
      LatLng currentLocation = LatLng(position.latitude, position.longitude); //TODO: LEHET CSAK AZ EMULATORBA NEM MUKODIK (nem a pontos poziciot keri le) position.latitude positiion.longitude
      //print("✅ currenmt location ${currentLocation}");
      controller.setPosition(currentLocation);
      controller.getUserAddress(currentLocation);

    print(currentLocation);
    }catch(e){
      print("valami hiba tortent ${e}");
    }
    
  } 


  @override
  void initState(){
    super.initState();
    //_getCurrentLocation();  // <- Kell a helymeghatarozashoz. Enelkul nem mukodik semmilyen resze
  }

  @override
  Widget build(BuildContext context) {
  final controller = Get.put(UserLocationController());

  return Container(
  height: 130.h,
  color: Theme.of(context).colorScheme.surface,
  padding: const EdgeInsets.only(left:10, right:10, top: 50),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
     Builder(
  builder: (context) => InkWell(
    onTap: () {
      Scaffold.of(context).openDrawer(); 
    },
    child: CircleAvatar(
      radius: 25,
      backgroundColor: Colors.amberAccent,
      child: Icon(Icons.person, color: Colors.white),
    ),
  ),
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
              child: Text(controller.address == "" ? "Nem sikerült lekérni a címet" : controller.address,
              overflow: TextOverflow.ellipsis,),
            ))
           
          ],
        ),
      ),

      const SizedBox(width: 12),

      // Dark m váltó
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