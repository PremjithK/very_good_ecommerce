import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/cart_page/repo/cart_repo.dart';
import 'package:ecommerce/checkout_page/view/checkout_page.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> cartItemList = [];

  //Current user's total bill
  double grandTotal = 0;
  //Current user's cart items
  String userID = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> productsToBuyList = [];
  Map<dynamic, dynamic> oneProduct = {};
  Set<Map<String, dynamic>> productsToBuySet = {};

  Set<String> cartIDSet = {};
  List<String> cartIDList = [];
  List<Map<String, dynamic>> fullCartItems = [];
  late Future<String> orderID;
  late List<Map<String, dynamic>> cartData = [];

  @override
  void initState() {
    super.initState();
    // Call a function to initialize the cartItemList
    initializeCartItems();
  }

  Future<void> initializeCartItems() async {
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

      cartData = [];

      for (final doc in cartItems.docs) {
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
                        future: getProductDetails(cartItem['product_id'] as String),
                        builder: (context, productSnapshot) {
                          if (productSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (productSnapshot.hasError) {
                            return Text('Error: ${productSnapshot.error.toString()}');
                          } else if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
                            return const Text('Product not found');
                          } else {
                            final productData = productSnapshot.data!;

                            final quantity = int.parse(cartItem['quantity'].toString());

                            final subtotal =
                                quantity * double.parse(productData['product_price'].toString());

                            grandTotal += subtotal;

                            // All fields
                            final productId = productData['product_id'];
                            final productImage = productData['product_image'];
                            final productName = productData['product_name'];
                            final productStock = int.parse(productData['stock'].toString());
                            final cartItemID = cartItem['cart_id'].toString();

                            cartIDSet.add(cartItemID);

                            //* Check if the product is already in productsToBuyList
                            var existingProductIndex = -1;
                            for (var i = 0; i < productsToBuyList.length; i++) {
                              if (productsToBuyList[i]['id'] == productId) {
                                existingProductIndex = i;
                                break;
                              }
                            }

                            if (existingProductIndex != -1) {
                              // If it exists, update the quantity
                              productsToBuyList[existingProductIndex]['quantity'] =
                                  double.parse(cartItem['quantity'].toString());
                            } else {
                              // If not, add a new entry
                              final oneProduct = {
                                'id': productId,
                                'name': productName,
                                'price': '${productData['product_price']}',
                                'quantity': '${cartItem['quantity']}',
                              };
                              productsToBuyList.add(oneProduct);
                            }

                            //
                            fullCartItems.add({
                              'product_id': productData['product_id'],
                              'quantity': quantity,
                              'subtotal': subtotal,
                            });

                            return SizedBox(
                              height: 100,
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(productImage.toString()),
                                ),
                                title: Text(
                                  productData['product_name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  subtotal.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          //! check if qty > stock
                                          if (quantity < productStock) {
                                            FirebaseFirestore.instance
                                                .collection('CartCollection')
                                                .doc(cartItem['cart_id'].toString())
                                                .update({'quantity': '${quantity + 1}'});
                                          } else {
                                            print('exceeding stock');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                'Exeeding Stock',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        });
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        size: 30,
                                      ),
                                    ),
                                    widthSpacer(10),
                                    Text('${cartItem['quantity']}'),
                                    widthSpacer(10),
                                    if (quantity > 1)
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('CartCollection')
                                                .doc(cartItem['cart_id'].toString())
                                                .update({'quantity': '${quantity - 1}'});
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove,
                                          size: 30,
                                        ),
                                      )
                                    else
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('CartCollection')
                                                .doc(cartItem['cart_id'].toString())
                                                .delete();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.delete_forever,
                                          size: 30,
                                        ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            //* Placing Order as pending status
                            final s = await OrderRepo().placeOrder(userID, fullCartItems);

                            await Get.off(
                              CheckoutPage(
                                productsToBuy: productsToBuyList.toSet().toList(),
                                grandTotal: grandTotal,
                                orderID: s,
                                fullCartItems: fullCartItems,
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> getProductDetails(String productId) async {
    final productDocument =
        await FirebaseFirestore.instance.collection('ProductCollection').doc(productId).get();
    return productDocument;
  }
}
