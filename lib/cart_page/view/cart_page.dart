// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce/custom_widgets/page_title.dart';
// import 'package:ecommerce/custom_widgets/spacer.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class CartPage extends StatefulWidget {
//   CartPage({super.key});

//   final auth = FirebaseAuth.instance;
//   final List cartItemsList = [];

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           children: [
//             heightSpacer(40),
//             mainHeading('My Cart'),
//             heightSpacer(30),
//             StreamBuilder<QuerySnapshot>(
//               stream: getCartItemsStream(),
//               builder: (BuildContext context, snapshot) {
//                 if (snapshot.hasData) {
//                   final cartItemsList = snapshot.data!.docs;

//                   print(cartItemsList.length);
//                   print(cartItemsList[1]);
//                   //
//                   return ListView.builder(
//                     itemCount: cartItemsList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       //print(products[index]);

//                       final cartItem = cartItemsList[index];
//                       if (cartItem != null) {
//                         print("${cartItem} **********************************");
//                         return FutureBuilder(
//                           future: getProductByID(cartItem.id),
//                           builder: (context, productSnapshot) {
//                             if (productSnapshot.hasData) {
//                               final productData = productSnapshot.data!;

//                               return ListTile(
//                                 title:
//                                     Text(productData['product_name'] as String),
//                               );
//                             } else {
//                               return Center(child: CircularProgressIndicator());
//                             }
//                           },
//                         );
//                       } else {
//                         print('No Cart Item---------------------');
//                         return CircularProgressIndicator();
//                       }
//                     },
//                   );
//                 } else {
//                   // try {} on FirebaseFirestoreException
//                   // catch (e) {
//                   //   ScaffoldMessenger.of(context)
//                   //       .showSnackBar(SnackBar(content: Text(e.toString())));
//                   // }

//                   return ListTile(
//                     title: Center(child: CircularProgressIndicator()),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Future<DocumentSnapshot> getProductByID(String productID) async {
//   final productDoc = await FirebaseFirestore.instance
//       .collection('ProductCollection')
//       .doc(productID)
//       .get();
//   return productDoc;
// }

// Stream<QuerySnapshot> getCartItemsStream() async* {
//   final user = FirebaseAuth.instance.currentUser;
//   final auth = FirebaseAuth.instance;

//   if (user != null) {
//     final cartItems = FirebaseFirestore.instance
//         .collection('CartCollection')
//         .where('user_id', isEqualTo: auth.currentUser!.uid)
//         .snapshots();

//     yield* cartItems;
//   } else {
//     print('No user-------------------------');
//   }
// }

import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> cartItemList = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    // Call a function to initialize the cartItemList
    initializeCartItems();
  }

  void initializeCartItems() async {
    final cartData = await getCartItems();
    setState(() {
      cartItemList = cartData;
    });
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final cartItems = await FirebaseFirestore.instance
          .collection('CartCollection')
          .where('user_id', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> cartData = [];

      for (var doc in cartItems.docs) {
        cartData.add(doc.data());
      }

      return cartData;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items in the cart.'));
          } else {
            final cartItems = snapshot.data;
            return ListView.builder(
              itemCount: cartItems!.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: getProductDetails(cartItem['product_id'] as String),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (productSnapshot.hasError) {
                      return Text('Error: ${productSnapshot.error.toString()}');
                    } else if (!productSnapshot.hasData ||
                        !productSnapshot.data!.exists) {
                      return Text('Product not found');
                    } else {
                      final productData = productSnapshot.data!;
                      return SizedBox(
                        height: 150,
                        child: ListTile(
                          leading: CircleAvatar(),
                          title: Text(productData['product_name'] as String),
                          subtitle:
                              Text(productData['product_price'] as String),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(onTap: () {}, child: Icon((Icons.add))),
                              widthSpacer(10),
                              Text('${cartItem['quantiy']}'),
                              widthSpacer(10),
                              InkWell(onTap: () {}, child: Icon(Icons.remove)),
                            ],
                          ),
                          // Add more product details as needed
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> getProductDetails(String productId) async {
    final productDocument = await FirebaseFirestore.instance
        .collection('ProductCollection')
        .doc(productId)
        .get();
    return productDocument;
  }
}
