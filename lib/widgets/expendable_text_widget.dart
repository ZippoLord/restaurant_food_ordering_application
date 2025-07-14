import 'package:flutter/material.dart';
import 'package:food_order_app/dimensions.dart';

class ExpendableTextWidget extends StatefulWidget {
  final String description; 
  const ExpendableTextWidget({super.key, required this.description});

  @override
  State<ExpendableTextWidget> createState() => _ExpendableTextWidgetState();
}

class _ExpendableTextWidgetState extends State<ExpendableTextWidget> {
  late String firstHalf;
  late String secondtHalf;
  
  bool hiddenText = true;

  double textHeight = Dimensions.screenHeight/5.63;
 
 
 @override 
  void initState(){
    super.initState();
    if(widget.description.length>textHeight){
      firstHalf = widget.description.substring(0, textHeight.toInt());  
      secondtHalf = widget.description.substring(textHeight.toInt()+1, widget.description.length);  
    }else{
      firstHalf=widget.description;
      secondtHalf="";
    } 
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondtHalf.isEmpty?Text(firstHalf) : Column(
        children: [
          Text(hiddenText?(firstHalf+"..."):(firstHalf+secondtHalf)),
          InkWell(
            onTap: (){
            setState(() {
              hiddenText=!hiddenText;
            });
            },
            child: Row(
              children: [
                Text(hiddenText?"Mutass többet":"Mutass kevesebbet",style: TextStyle(color: Colors.red),),
                Icon(hiddenText?Icons.arrow_drop_down : Icons.arrow_drop_up, color: Colors.red,),
              ],
            ),
          )
        ],
      ),
    );
  }
}