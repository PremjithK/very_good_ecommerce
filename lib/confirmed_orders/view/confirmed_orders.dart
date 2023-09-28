import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConfirmedOrders extends StatefulWidget {
  ConfirmedOrders({super.key});

  // 1. Confirmed orders

  // 2. Cart Items -> product_id -> seller_id = current_seller_id ?

  @override
  State<ConfirmedOrders> createState() => _ConfirmedOrdersState();
}

class _ConfirmedOrdersState extends State<ConfirmedOrders> {
  Map<String, dynamic> productsMap = {};
  Map<String, dynamic> quantityMap = {};
  Map<String, dynamic> subtotalMap = {};

  List<Map<String, String>> finalMap = [];

  Future<void> getConfirmedOrders() async {
    final sellerID = FirebaseAuth.instance.currentUser!.uid;

    final ordersRef = await FirebaseFirestore.instance
        .collection('OrderCollection')
        .where('status', isEqualTo: 'confirmed')
        .get();

    for (final order in ordersRef.docs) {
      productsMap = order['product_ids'] as Map<String, dynamic>;
      quantityMap = order['quantity'] as Map<String, dynamic>;
      subtotalMap = order['subtotal'] as Map<String, dynamic>;

      // final productIds = order['product_ids'];
      // final productIds = order['product_ids'];
      //final productQuantities = order['quantity'];
    }

    print('${productsMap.keys}, ${quantityMap.values}, ${subtotalMap.values}');

    productsMap.forEach((key, value) async {
      // finalMap.add({
      //   'id': key,
      //   'name': '',
      //   'quantity': '',
      //   'total': '',
      // });

      // getting the products of current seller where : productIDs

      final productRef = await FirebaseFirestore.instance
          .collection('ProductCollection')
          .where('seller_id', isEqualTo: sellerID)
          .where('product_id', isEqualTo: key)
          .get();

      for (final prod in productRef.docs) {
        finalMap.add({
          'id': key,
          'name': prod['product_name'].toString(),
          'quantity': quantityMap[key].toString(),
          '': '',
        });
      }
    });
    print(finalMap);
  }

  //
  @override
  Widget build(BuildContext context) {
    getConfirmedOrders();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            heightSpacer(20),
            mainHeading('Orders'),
            heightSpacer(20),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
