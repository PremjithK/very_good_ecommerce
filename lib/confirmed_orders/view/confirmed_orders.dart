import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConfirmedOrders extends StatefulWidget {
  const ConfirmedOrders({super.key});

  @override
  State<ConfirmedOrders> createState() => _ConfirmedOrdersState();
}

class _ConfirmedOrdersState extends State<ConfirmedOrders> {
  List<Map<String, dynamic>> finalMap = [];
  final sellerID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

//!

  @override
  Widget build(BuildContext context) {
    // print('Current Seller: $sellerID');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmed Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('OrderCollection').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data!.docs;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final productIDMap = orders[index]['product_ids'] as Map<String, dynamic>;
                final quantityMap = orders[index]['quantity'] as Map<String, dynamic>;
                final userID = orders[index]['user_id'] as String;

                return FutureBuilder(
                  future: fetchProductData(productIDMap),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (productSnapshot.hasError) {
                      return Text('Error: ${productSnapshot.error}');
                    } else if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                      return const Center(child: Text('No Products Found'));
                    } else {
                      final List<Widget> productWidgets = [];
                      final productData = productSnapshot.data as Map<String, dynamic>;

                      // Fetch user data and include the user's name
                      final Future<Map<String, dynamic>> userDataFuture = fetchUserData(userID);

                      return FutureBuilder(
                        future: userDataFuture,
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (userSnapshot.hasError) {
                            return Text('Error: ${userSnapshot.error}');
                          } else {
                            final userName = userSnapshot.data?['name'] as String?;
                            final userPhoneNum = userSnapshot.data?['phone'] as String?;
                            for (final pid in productIDMap.values) {
                              if (productData.containsKey(pid) &&
                                  productData[pid]['seller_id'] == sellerID) {
                                final product = productData[pid];

                                productWidgets.add(
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(15),
                                    padding: const EdgeInsets.all(15),
                                    color: Colors.grey.shade300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'User: ${userName},  Phone: ${userPhoneNum}',
                                          style:
                                              TextStyle(fontSize: 16), // Adjust font size as needed
                                        ),
                                        const Divider(),
                                        Text(
                                          '${quantityMap[pid]} X ${product['product_name']}',
                                          style: const TextStyle(
                                              fontSize: 16), // Adjust font size as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                            return Column(
                              children: productWidgets,
                            );
                          }
                        },
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No Order Data'));
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchProductData(Map<String, dynamic> productIDMap) async {
    final List<Future<Map<String, dynamic>>> productFutures = [];

    for (final pid in productIDMap.values) {
      final productSnapshot = await FirebaseFirestore.instance
          .collection('ProductCollection')
          .doc(pid.toString())
          .get();

      if (productSnapshot.exists) {
        productFutures.add(Future.value(productSnapshot.data() as Map<String, dynamic>));
      } else {
        productFutures.add(Future.value({}));
      }
    }

    final List<Map<String, dynamic>> productDataList = await Future.wait(productFutures);
    final Map<String, dynamic> productData = {};

    for (int i = 0; i < productDataList.length; i++) {
      productData[productIDMap.values.elementAt(i).toString()] = productDataList[i];
    }

    return productData;
  }

  Future<Map<String, dynamic>> fetchUserData(String userID) async {
    final userSnapshot =
        await FirebaseFirestore.instance.collection('CustomerCollection').doc(userID).get();

    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }
}
