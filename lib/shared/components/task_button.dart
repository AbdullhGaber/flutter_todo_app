import 'package:flutter/material.dart';

Widget taskButton({
  required double width,
  required String label,
  required void Function() onPressed
}) => SizedBox(
  width: double.infinity,
  child: TextButton(
      style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10)),
          backgroundColor: WidgetStatePropertyAll(Colors.blue),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.zero))
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
            fontSize: 16
        ),
      )
  ),
);