import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/cart_page/view/cart_page.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/product_details_page/view/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});

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
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => CartPage(),
                //     ));
                Get.to(CartPage());
              },
              icon: const Icon(Icons.shopping_cart_checkout),
            ),
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
                        childAspectRatio: 0.9,
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final prod = snapshot.data!.docs[index];
                        final stock = int.parse(snapshot.data!.docs[index]['stock'].toString());

                        return SizedBox(
                          height: 100,
                          width: 150,
                          child: InkWell(
                            onTap: () {
                              if (stock > 0) {
                                Get.to(
                                  ProductDetailsPage(
                                    productID: prod['product_id'] as String,
                                  ),
                                );
                              }
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ProductDetailsPage(
                              //       productID: prod['product_id'] as String,
                              //     ),
                              //   ),
                              // );
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
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Rs. ${prod['product_price'] as String}'),
                                  if (stock < 1)
                                    const Text(
                                      'OUT OF STOCK',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    )
                                  else
                                    const SizedBox(
                                      height: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
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
