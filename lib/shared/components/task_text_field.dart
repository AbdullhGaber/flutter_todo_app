import 'package:flutter/material.dart';

Widget taskTextField({
  TextEditingController? controller,
  String? Function(String?)? validator,
  void Function()? onTap,
  bool enabled = true,
  bool isPassword = false,
  String label = "",
  Widget? prefixIcon,
  Widget? suffixIcon,
  TextInputType? keyboardType
}) => TextFormField(
  controller: controller,
  onTap: onTap,
  validator: validator,
  enabled: enabled,
  obscureText: isPassword,
  decoration: InputDecoration(
    label: Text(label),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(),
  ),
  keyboardType: keyboardType,
);