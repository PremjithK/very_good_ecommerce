import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/cart_page/repo/cart_repo.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({required this.productID, super.key});
  final String productID;

  final user_id = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    // UI
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Row(
        children: [
          TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              label: Text('Back')),
          heightSpacer(10),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('ProductCollection')
            .doc(productID)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        heightSpacer(60),
                        Image.network(
                          product['product_image'][0] as String,
                          fit: BoxFit.cover,
                          height: 300,
                        ),
                        heightSpacer(20),
                        mainHeading(product['product_name'] as String),
                        Text(
                          'Rs. ${product['product_price'] as String}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21),
                        ),
                        heightSpacer(15),
                        Text(
                          product['product_details'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        heightSpacer(20),
                        ElevatedButton.icon(
                            onPressed: () {
                              CartRepo().addToCart(user_id, productID);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Item Added To Cart'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                            label: Text('Add To Cart')),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
