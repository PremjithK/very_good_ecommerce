import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditStockPage extends StatefulWidget {
  const EditStockPage({super.key});

  @override
  State<EditStockPage> createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Initialized
  }

  final sellerID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stock'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('ProductCollection')
                .where('seller_id', isEqualTo: sellerID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final productSnapshot = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: productSnapshot.length,
                  itemBuilder: (context, index) {
                    final product = productSnapshot[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        tileColor: Colors.grey.shade200,
                        leading: Image.network(
                          product['product_image'][0].toString(),
                          fit: BoxFit.cover,
                          height: 150,
                        ),
                        title: Text(
                          product['product_name'].toString(),
                          style: const TextStyle(
                            fontVariations: [FontVariation('wght', 800)],
                          ),
                        ),
                        subtitle: Text(
                          'Current stock: '.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'x${product['stock'].toString()}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            widthSpacer(5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(
                                      () {
                                        FirebaseFirestore.instance
                                            .collection('ProductCollection')
                                            .doc(
                                              product['product_id'].toString(),
                                            )
                                            .update(
                                          {'stock': FieldValue.increment(1)},
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    size: 25,
                                  ),
                                ),
                                widthSpacer(2),
                                if (int.parse(product['stock'].toString()) > 1)
                                  InkWell(
                                    onTap: () {
                                      final productsRef = FirebaseFirestore.instance
                                          .collection('ProductCollection')
                                          .doc(
                                            product['product_id'].toString(),
                                          )
                                          .update(
                                        {'stock': FieldValue.increment(-1)},
                                      );
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      size: 25,
                                    ),
                                  )
                                else
                                  InkWell(
                                    onTap: () {
                                      final productsRef = FirebaseFirestore.instance
                                          .collection('ProductCollection')
                                          .doc(
                                            product['product_id'].toString(),
                                          )
                                          .delete();
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      size: 30,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: Text('No Products'));
            },
          ),
        ),
      ),
    );
  }
}
