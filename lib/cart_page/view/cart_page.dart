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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/cart_page/repo/cart_repo.dart';
import 'package:ecommerce/checkout_page/view/checkout_page.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> cartItemList = []; // Initialize as an empty list

  //Current user's total bill
  double grandTotal = 0;
  //Current user's cart items
  String userID = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> productsToBuyList = [];
  Map<dynamic, dynamic> oneProduct = {};
  Set<Map<String, dynamic>> productsToBuySet = {};

  Set<String> cartIDSet = {};
  List<String> cartIDList = [];

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
        title: const Text('Cart Page'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items in the cart.'));
          } else {
            //
            final cartItems = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartItems!.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      grandTotal = 0;
                      return FutureBuilder<DocumentSnapshot>(
                        future:
                            getProductDetails(cartItem['product_id'] as String),
                        builder: (context, productSnapshot) {
                          if (productSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (productSnapshot.hasError) {
                            return Text(
                                'Error: ${productSnapshot.error.toString()}');
                          } else if (!productSnapshot.hasData ||
                              !productSnapshot.data!.exists) {
                            return Text('Product not found');
                          } else {
                            final productData = productSnapshot.data!;

                            final quantity =
                                double.parse(cartItem['quantity'].toString());

                            final subtotal = quantity *
                                double.parse(
                                    productData['product_price'].toString());

                            grandTotal += subtotal;

                            final productId = productData['product_id'];
                            final productName = productData['product_name'];
                            final cartItemID = cartItem['cart_id'].toString();
                            cartIDSet.add(cartItemID);
                            print(cartIDSet);

                            //? Check if the product is already in productsToBuy
                            var existingProductIndex = -1;
                            for (var i = 0; i < productsToBuyList.length; i++) {
                              if (productsToBuyList[i]['id'] == productId) {
                                existingProductIndex = i;
                                break;
                              }
                            }

                            if (existingProductIndex != -1) {
                              // If it exists, update the quantity
                              productsToBuyList[existingProductIndex]
                                      ['quantity'] =
                                  double.parse(cartItem['quantity'].toString());
                            } else {
                              // If not, add a new entry
                              final oneProduct = {
                                'id': productId,
                                'name': productName,
                                'price': '${subtotal * quantity}',
                                'quantity': '${cartItem['quantity']}',
                              };
                              productsToBuyList.add(oneProduct);
                            }

                            return SizedBox(
                              height: 100,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                leading: CircleAvatar(),
                                title:
                                    Text(productData['product_name'] as String),
                                subtitle: Text(
                                  subtotal.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('CartCollection')
                                                .doc(cartItem['cart_id']
                                                    .toString())
                                                .update({
                                              'quantity': '${quantity + 1}'
                                            });
                                          });
                                        },
                                        child: Icon((Icons.add))),
                                    widthSpacer(10),
                                    Text('${cartItem['quantity']}'),
                                    widthSpacer(10),
                                    if (quantity > 1)
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              FirebaseFirestore.instance
                                                  .collection('CartCollection')
                                                  .doc(cartItem['cart_id']
                                                      .toString())
                                                  .update({
                                                'quantity': '${quantity - 1}'
                                              });
                                            });
                                          },
                                          child: const Icon(Icons.remove))
                                    else
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('CartCollection')
                                                .doc(cartItem['cart_id']
                                                    .toString())
                                                .delete();
                                          });
                                        },
                                        child: const Icon(Icons.delete_forever),
                                      ),
                                  ],
                                ),
                                // Add more product details as needed
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),

                  //G
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //! Grand Total (Need to modify)
                          // Text('GRAND TOTAL: $grandTotal'),

                          TextButton.icon(
                              onPressed: () {
                                // Creating order table

                                OrderRepo().placeOrder(cartIDSet.toList());

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckoutPage(
                                        productsToBuy:
                                            productsToBuyList.toSet().toList(),
                                        grandTotal: grandTotal,
                                        cartIDs: cartIDSet.toList(),
                                      ),
                                    ));
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Checkout'))
                        ],
                      )),
                ],
              ),
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
