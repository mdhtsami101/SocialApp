

import 'package:ayhaga/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../styles/icon_broken.dart';

// Widget defaultAppBar({
//   required BuildContext context,
//     String title,
//   List<Widget>? actions,
// }) => AppBar(
//   leading: IconButton(
//     onPressed: ()
//     {
//       Navigator.pop(context);
//     },
//     icon: Icon(
//       IconBroken.Arrow___Left_2,
//     ),
//   ),
//   titleSpacing: 5.0,
//   title: Text(
//    title!,
//   ),
//   actions: actions,
// );


Widget defaultButton({
   double width = double.infinity ,
   double radius = 0.0 ,
   Color background=Colors.blue ,
   bool isUpperCase = true,
  required Function  ,
  required String text ,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed:   Function ,
        child: Text(
         isUpperCase? text.toUpperCase():text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );


Widget defaultTextButton({
  required Function ,
  required String text ,
})=>TextButton(
onPressed:Function,
child: Text(text.toUpperCase(),),
);




Widget defaultFormField ({
  required TextEditingController controller,
  required TextInputType type,
  onSubmit,
  onChange,
  onTap,
  required  validat,
  bool isPassword = false,
  required String lable ,
  required IconData prefix,
  IconData? suffix ,
  suffixPressed,
})=>
TextFormField(
  controller: controller,
  keyboardType: type ,
  onFieldSubmitted:onSubmit ,
  onChanged: onChange,
  validator: validat,
  onTap: onTap,
  obscureText: isPassword,
  decoration: InputDecoration(
    labelText:lable, //hintText: 'Email Address'
    border: OutlineInputBorder(),
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed:suffixPressed ,
      icon: Icon(
          suffix,
      ),
    ) : null,
  ),
);







Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);



void navigateTo(context , widget)=> Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=>widget,
  ),
);

void navigateAndFinish (context , widget)=> Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context)=>widget,
  ),
  (Route<dynamic>route) => false,
);

void showToast({
  required String text,
  required ToastStates state,
})=> Fluttertoast.showToast(

    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates {SUCCESS , ERROR , WARNING}

Color chooseToastColor( ToastStates state){
  Color color ;
  switch(state){
    case ToastStates.SUCCESS:
      color= Colors.green;
      break;
    case ToastStates.ERROR:
      color= Colors.red;
      break;
    case ToastStates.WARNING:
      color= Colors.amber;
      break;
  }

  return color;

}
