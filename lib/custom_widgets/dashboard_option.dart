import 'package:ecommerce/add_product_page/add_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dashboardItem(
  String title,
  IconData icon,
  Color color,
  Widget destination,
) {
  return ListTile(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    onTap: () {
      Get.to(destination);
    },
    leading: CircleAvatar(
      backgroundColor: color,
      foregroundColor: Colors.white,
      child: Icon(icon),
    ),
    title: Container(
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    ),
  );
}
