import 'package:flutter/material.dart';
import 'package:food_order_app/components/icon_and_text_widget.dart';

class AppColumn extends StatelessWidget {
  final String foodName;
  final num foodPrice;
  final String foodTime;
  final String ratingCount;
  final double rating;
  const AppColumn({super.key, required this.foodPrice, required this.foodName, required this.foodTime, required this.ratingCount, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(foodName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(width: 20),
                    Text("${foodPrice.toInt()} Ft", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
                    ],
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: 
                    [Wrap(
                      children: List.generate(5, (index) {return Icon(Icons.star, color: Colors.red, size: 15,);}),
                    ),
                    SizedBox(width: 10,),
                    Text(rating.toString()),
                    SizedBox(width: 10,),
                    Text(ratingCount),
                    SizedBox(width: 10,),
                    Text("commentek")
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: 
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconAndTextWidget(iconColor:Colors.amber, icon: Icons.circle_sharp, text: "Normal", textColor: Theme.of(context).colorScheme.inversePrimary,),
                      IconAndTextWidget(iconColor:Colors.green, icon: Icons.location_on, text: "1.7km", textColor: Theme.of(context).colorScheme.inversePrimary),
                      IconAndTextWidget(iconColor:Colors.red, icon: Icons.access_time_rounded, text: "$foodTime perc", textColor: Theme.of(context).colorScheme.inversePrimary)
                    ],
                   ),
                  )
                ]
              );
  }
}