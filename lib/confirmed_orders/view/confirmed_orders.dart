import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConfirmedOrders extends StatefulWidget {
  ConfirmedOrders({super.key});

  void getConfirmedOrders() async {
    final auth = FirebaseAuth.instance;
    final ordersRef = await FirebaseFirestore.instance
        .collection('OrderCollection')
        .where('status', isEqualTo: 'confirmed')
        .get();

    for (var order in ordersRef.docs) {
      
    }
  }
  // 1. Confirmed orders
  // 2. Cart Items -> product_id -> seller_id = current_seller_id ?

  @override
  State<ConfirmedOrders> createState() => _ConfirmedOrdersState();
}

class _ConfirmedOrdersState extends State<ConfirmedOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            heightSpacer(20),
            mainHeading('Orders'),
            heightSpacer(20),
          ],
        ),
      ),
    );
  }
}
