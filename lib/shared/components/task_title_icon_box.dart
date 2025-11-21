import 'package:flutter/material.dart';

Widget taskTitleIconBox(
{
  required String label,
  required Widget prefixIcon,
  void Function()? onPressed,
  double width = double.infinity,
}) => GestureDetector(
  onTap: (){if(onPressed != null) onPressed();},
  child: Container(
    padding: EdgeInsetsDirectional.symmetric(vertical: 15, horizontal: 10),
    width: width,
    decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black,
            width: 1
        ),
        borderRadius: BorderRadiusGeometry.all(Radius.circular(5))
    ),
    child: Row(
      children: [
        prefixIcon,
        SizedBox(width: 15),
        Text(label)
      ],
    ),
  ),
);