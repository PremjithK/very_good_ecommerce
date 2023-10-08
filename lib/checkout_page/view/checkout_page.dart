import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/customer_dashboard_page/customer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({
    required this.productsToBuy,
    required this.grandTotal,
    required this.orderID,
    required this.fullCartItems,
    super.key,
  });

  final double grandTotal;
  final List<Map<String, dynamic>> productsToBuy;
  final String orderID;
  List<Map<String, dynamic>> fullCartItems;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Razorpay _razorpay;
  bool stockChanged = false;
  final _cartRef = FirebaseFirestore.instance.collection('CartCollection');
  final _orderRef = FirebaseFirestore.instance.collection('OrderCollection');

  // Confirm order after payment
  Future<void> confirmOrder(
    String orderId,
    List<Map<String, dynamic>> cartItems,
  ) async {
    try {
      for (final cartItem in cartItems) {
        final productId = cartItem['product_id'] as String;
        final quantity = cartItem['quantity'];
        final subtotal = cartItem['subtotal'];

        await _orderRef.doc(orderId).update({
          'quantity.$productId': quantity,
          'subtotal.$productId': subtotal,
          'product_ids.$productId': productId,
          'status': 'confirmed',
        });

        final snapshot = await _orderRef.doc(orderId).get();

        //? Clearing Cart
        if (snapshot.exists) {
          final user = snapshot['user_id'] as String;
          final cartDoc = await _cartRef.where('user_id', isEqualTo: user).get();
          for (final doc in cartDoc.docs) {
            await doc.reference.delete();
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to Confirm order');
    } finally {}
  }

  // Decrease stock after purchase was succesful
  Future<void> decrementStock(List<Map<String, dynamic>> cartItems) async {
    final productRef = FirebaseFirestore.instance.collection('ProductCollection');

    try {
      for (final cartItem in cartItems) {
        final productId = cartItem['product_id'] as String;
        final quantity = cartItem['quantity'] as int;

        // Retrieve the current stock of the product
        await productRef.doc(productId).get().then((doc) {
          // Update the 'stock' field in the 'ProductCollection'
          doc.reference.update({'stock': FieldValue.increment(-quantity)});
        });
      }
    } catch (e) {
      throw Exception('Failed to decrement product stock: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  //* Payment success event
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      backgroundColor: Colors.green.shade700,
      msg: 'Payment Successful: ${response.paymentId}',
      toastLength: Toast.LENGTH_SHORT,
    );

    //? (1) Updating Order Statuses
    confirmOrder(
      widget.orderID,
      widget.fullCartItems,
    );
    //? (2) Reducing the stock based on quantity purchased
    decrementStock(widget.fullCartItems);

    //? (2) Routing back to user homepage
    Get.to<Widget>(const UserDashboardPage());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      backgroundColor: Colors.red,
      msg: 'Error: ${response.code}',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'External Wallet: ${response.walletName}',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> payment(double amount) async {
    final options = {
      'key': 'rzp_test_sU9tdJwIpbnAHy',
      'key_secret': 'dekVTnDDsu0sDonSh3y1DbWd',
      'amount': amount * 100,
      'name': 'E-Commerce',
      'description': 'E commerce Cart Total',
      'retry': {
        'enabled': true,
        'max_count': 1,
      },
      'send_sms_hash': true,
      'prefil': {
        'contact': '909090',
        'email': 'ecommerce@gmail.com',
        'external': {
          'wallets': ['Paytm', 'Gpay'],
        },
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout From Cart'),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('GRAND TOTAL'),
                        mainHeading('₹ ${widget.grandTotal}'),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        // Shows dialog to pick payment method
                        showDialog<Widget>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              icon: Column(
                                children: [
                                  mainHeading('Payment Method'),
                                  heightSpacer(10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () {},
                                      child: const Text('Cash On Delivery'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        backgroundColor: Colors.indigo,
                                      ),
                                      onPressed: () {
                                        //? MAKING THE PAYMENT
                                        payment(widget.grandTotal);
                                      },
                                      child: const Text('Razorpay'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text('Pay'),
                    ),
                  ],
                ),
                heightSpacer(30),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.productsToBuy.length,
                        itemBuilder: (BuildContext context, int index) {
                          final listItem = widget.productsToBuy[index];
                          final subTotal = double.parse(listItem['price'].toString()) *
                              double.parse(listItem['quantity'].toString());

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              radius: 30,
                            ),
                            title: Text(listItem['name'].toString()),
                            subtitle: Text(subTotal.toString()),
                            trailing: Text(
                              'x ${listItem['quantity']}',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                heightSpacer(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
