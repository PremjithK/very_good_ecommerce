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
    // getConfirmedOrders();
    // print("object");
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
  //       child: Column(
  //         children: [
  //           // Your heading widgets here
  //           FutureBuilder(
  //             future: getConfirmedOrders(),
  //             builder: (context, snapshot) {
  //               final data = snapshot.data;
  //               return ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: finalMap.length,
  //                 itemBuilder: (context, index) {
  //                   final orderedProduct = finalMap[index];
  //                   return ListTile(
  //                     title: Text(orderedProduct['name'] as String),
  //                     subtitle: Text('Quantity: ${orderedProduct['quantity']}'),
  //                     trailing: Text('Subtotal: ${orderedProduct['subtotal']}'),
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

//! UI
//   @override
//   Widget build(BuildContext context) {
//     print('Current Seller : $sellerID');
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('OrderCollection').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final orders = snapshot.data!.docs;
//             return ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final productIDMap = orders[index]['product_ids'] as Map<String, dynamic>;
//                 final quantityMap = orders[index]['quantity'] as Map<String, dynamic>;
//                 final userID = orders[index]['user_id'] as String;
//                 final productIDs = productIDMap.values;
//                 print(productIDs);
//                 for (final pid in productIDs) {
//                   return StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection('ProductCollection')
//                         .where('product_id', isEqualTo: pid)
//                         .where('seller_id', isEqualTo: sellerID)
//                         .snapshots(),
//                     builder: (context, productSnapshot) {
//                       if (!productSnapshot.hasData) {
//                         return CircularProgressIndicator();
//                       } else if (productSnapshot.hasData) {
//                         final product = productSnapshot.data!.docs[0];

//                         print(product['product_name']);
//                         return Text(
//                           '${product['product_name']} x ${quantityMap[pid]} for ${userID}',
//                         );
//                       }
//                       return const Center(child: Text('No Product Data'));
//                     },
//                   );
//                 }
//               },
//             );
//           }
//           return const Center(child: Text('No Order Data'));
//         },
//       ),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     print('Current Seller: $sellerID');
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('OrderCollection').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final orders = snapshot.data!.docs;
//             return ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final productIDMap = orders[index]['product_ids'] as Map<String, dynamic>;
//                 final quantityMap = orders[index]['quantity'] as Map<String, dynamic>;
//                 final userID = orders[index]['user_id'] as String;

//                 return FutureBuilder(
//                   future: fetchProductData(productIDMap),
//                   builder: (context, productSnapshot) {
//                     if (productSnapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator();
//                     } else if (productSnapshot.hasError) {
//                       return Text('Error: ${productSnapshot.error}');
//                     } else if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
//                       return Text('No Products Found');
//                     } else {
//                       List<Widget> productWidgets = [];
//                       final productData = productSnapshot.data as Map<String, dynamic>;

//                       for (final pid in productIDMap.values) {
//                         if (productData.containsKey(pid) &&
//                             productData[pid]['seller_id'] == sellerID) {
//                           final product = productData[pid];
//                           print(product['product_name']);
//                           productWidgets.add(
//                             Container(
//                               width: double.infinity,
//                               margin: EdgeInsets.all(10),
//                               padding: EdgeInsets.all(10),
//                               color: Colors.grey.shade300,
//                               child: Text(
//                                   '${quantityMap[pid]} X ${product['product_name']}  for $userID'),
//                             ),
//                           );
//                         } else {
//                           //productWidgets.add(Text('Product not found for $pid'));
//                         }
//                       }

//                       return Column(
//                         children: productWidgets,
//                       );
//                     }
//                   },
//                 );
//               },
//             );
//           }
//           return const Center(child: Text('No Order Data'));
//         },
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> fetchProductData(Map<String, dynamic> productIDMap) async {
//     final List<Future<Map<String, dynamic>>> productFutures = [];

//     for (final pid in productIDMap.values) {
//       final productSnapshot = await FirebaseFirestore.instance
//           .collection('ProductCollection')
//           .doc(pid.toString())
//           .get();

//       if (productSnapshot.exists) {
//         productFutures.add(Future.value(productSnapshot.data() as Map<String, dynamic>));
//       } else {
//         productFutures.add(Future.value({}));
//       }
//     }

//     final List<Map<String, dynamic>> productDataList = await Future.wait(productFutures);
//     final Map<String, dynamic> productData = {};

//     for (int i = 0; i < productDataList.length; i++) {
//       productData[productIDMap.values.elementAt(i).toString()] = productDataList[i];
//     }

//     return productData;
//   }
// }

//!
//   @override
//   Widget build(BuildContext context) {
//     print('Current Seller: $sellerID');
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('OrderCollection').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final orders = snapshot.data!.docs;
//             return ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final productIDMap = orders[index]['product_ids'] as Map<String, dynamic>;
//                 final quantityMap = orders[index]['quantity'] as Map<String, dynamic>;
//                 final userID = orders[index]['user_id'] as String;

//                 return FutureBuilder(
//                   future: fetchProductData(productIDMap),
//                   builder: (context, productSnapshot) {
//                     if (productSnapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator();
//                     } else if (productSnapshot.hasError) {
//                       return Text('Error: ${productSnapshot.error}');
//                     } else if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
//                       return Text('No Products Found');
//                     } else {
//                       List<Widget> productWidgets = [];
//                       final productData = productSnapshot.data as Map<String, dynamic>;

//                       for (final pid in productIDMap.values) {
//                         if (productData.containsKey(pid) &&
//                             productData[pid]['seller_id'] == sellerID) {
//                           final product = productData[pid];
//                           print(product['product_name']);

//                           // Fetch the customer's name
//                           return FutureBuilder(
//                             future: fetchCustomerName(userID),
//                             builder: (context, customerSnapshot) {
//                               if (customerSnapshot.connectionState == ConnectionState.waiting) {
//                                 return CircularProgressIndicator();
//                               } else if (customerSnapshot.hasError) {
//                                 return Text('Error: ${customerSnapshot.error}');
//                               } else if (!customerSnapshot.hasData) {
//                                 return Text('No Customer Data');
//                               } else {
//                                 final customerName = customerSnapshot.data as String;
//                                 productWidgets.add(
//                                   Container(
//                                     width: double.infinity,
//                                     margin: EdgeInsets.all(10),
//                                     padding: EdgeInsets.all(10),
//                                     color: Colors.grey.shade300,
//                                     child: Text(
//                                       '${quantityMap[pid]} X ${product['product_name']} for $customerName',
//                                     ),
//                                   ),
//                                 );
//                               }
//                               return SizedBox();
//                             },
//                           );
//                         } else {
//                           //productWidgets.add(Text('Product not found for $pid'));
//                         }
//                       }

//                       return Column(
//                         children: productWidgets,
//                       );
//                     }
//                   },
//                 );
//               },
//             );
//           }
//           return const Center(child: Text('No Order Data'));
//         },
//       ),
//     );
//   }
// }

// Future<Map<String, dynamic>> fetchProductData(Map<String, dynamic> productIDMap) async {
//   final List<Future<Map<String, dynamic>>> productFutures = [];

//   for (final pid in productIDMap.values) {
//     final productSnapshot =
//         await FirebaseFirestore.instance.collection('ProductCollection').doc(pid.toString()).get();

//     if (productSnapshot.exists) {
//       productFutures.add(Future.value(productSnapshot.data() as Map<String, dynamic>));
//     } else {
//       productFutures.add(Future.value({}));
//     }
//   }

//   final List<Map<String, dynamic>> productDataList = await Future.wait(productFutures);
//   final Map<String, dynamic> productData = {};

//   for (int i = 0; i < productDataList.length; i++) {
//     productData[productIDMap.values.elementAt(i).toString()] = productDataList[i];
//   }

//   return productData;
// }

// Future<String> fetchCustomerName(String userID) async {
//   final customerSnapshot =
//       await FirebaseFirestore.instance.collection('CustomerCollection').doc(userID).get();

//   if (customerSnapshot.exists) {
//     return customerSnapshot['name'] as String;
//   } else {
//     return '';
//   }
// }

  @override
  Widget build(BuildContext context) {
    print('Current Seller: $sellerID');
    return Scaffold(
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
                      return CircularProgressIndicator();
                    } else if (productSnapshot.hasError) {
                      return Text('Error: ${productSnapshot.error}');
                    } else if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                      return Text('No Products Found');
                    } else {
                      List<Widget> productWidgets = [];
                      final productData = productSnapshot.data as Map<String, dynamic>;

                      // Fetch user data and include the user's name
                      Future<Map<String, dynamic>> userDataFuture = fetchUserData(userID);

                      return FutureBuilder(
                        future: userDataFuture,
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
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
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    color: Colors.grey.shade300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'User: ${userName},  Phone: ${userPhoneNum}',
                                          style:
                                              TextStyle(fontSize: 16), // Adjust font size as needed
                                        ),
                                        Text(
                                          '${quantityMap[pid]} X ${product['product_name']}',
                                          style:
                                              TextStyle(fontSize: 16), // Adjust font size as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                // Product not found for pid
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
          }
          return const Center(child: Text('No Order Data'));
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
