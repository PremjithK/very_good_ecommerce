import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/cart_page/view/cart_page.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/product_details_page/view/product_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDashboardPage extends StatelessWidget {
  UserDashboardPage({super.key});

  final _auth = FirebaseAuth.instance;
  // final productsRef =
  //     FirebaseFirestore.instance.collection('ProdcutsCollection');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text(
      //     'Welcome Customer',
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            heightSpacer(35),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ));
                },
                icon: Icon(Icons.shopping_cart_checkout)),
            heightSpacer(20),
            Center(
              child: mainHeading('Browse'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('ProductCollection').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot prod = snapshot.data!.docs[index];
                        print(prod);
                        return SizedBox(
                          height: 100,
                          width: 150,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsPage(
                                    productID: prod['product_id'] as String,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  heightSpacer(10),
                                  Image.network(
                                    prod['product_image'][0] as String,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                  heightSpacer(10),
                                  Text(
                                    prod['product_name'] as String,
                                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                  ),
                                  Text('Rs. ${prod['product_price'] as String}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
