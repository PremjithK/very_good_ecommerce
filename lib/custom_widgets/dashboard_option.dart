import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dashboardItem(
  String title,
  IconData icon,
  Color color,
  Widget destination,
) {
  return ListTile(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    onTap: () {
      Get.to<Widget>(destination);
    },
    leading: CircleAvatar(
      radius: 21,
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
