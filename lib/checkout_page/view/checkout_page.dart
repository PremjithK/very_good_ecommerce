import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/customer_dashboard_page/customer_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({
    required this.productsToBuy,
    required this.grandTotal,
    required this.cartIDs,
    super.key,
  });
  final double grandTotal;
  final List<Map<String, dynamic>> productsToBuy;
  final List<String> cartIDs;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Razorpay _razorpay;
  final _auth = FirebaseAuth.instance;
  final _cartRef = FirebaseFirestore.instance.collection('CartCollection');

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
  
    //? Clearing the cart and Updating Order Statuses
    updateOrderStatus(_auth.currentUser!.uid, widget.cartIDs);
    //? Route back to user homepage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDashboardPage(),
      ),
    );
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
          'wallets': ['Paytm', 'Gpay']
        }
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  //? method for Updating Order Status And Clearing Cart
  Future<void> updateOrderStatus(
    String userId,
    List<String> cartIDs,
  ) async {
    print('USER ID:  $userId <<<<<<<<<<<<<<<');
    final orderRef = await FirebaseFirestore.instance
        .collection('OrderCollection')
        .where('item_ids', arrayContainsAny: cartIDs)
        .get();
    // Updating Order Status to confirmed
    for (final doc in orderRef.docs) {
      await doc.reference.update({
        'status': 'confirmed',
        
      });
    }
    // Clearing the user's cart
    final querySnapshot =
        await _cartRef.where('user_id', isEqualTo: userId).get();
    for (final item in querySnapshot.docs) {
      await item.reference.delete();
    }
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    //
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
                            shape: StadiumBorder()),
                        onPressed: () {
                          //? Proceed To Payment Page
                          //? Create Order Table and Set Order Status As Pending

                          showDialog(
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
                                        child: Text('Cash On Delivery')),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          backgroundColor: Colors.indigo,
                                        ),
                                        onPressed: () {
                                          //? MAKING THE PAYMENT
                                          payment(widget.grandTotal);
                                        },
                                        child: Text('Razorpay')),
                                  ),
                                ],
                              ));
                            },
                          );
                        },
                        icon: Icon(Icons.payment),
                        label: Text('Pay'))
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
                          final subTotal =
                              double.parse(listItem['price'].toString()) *
                                  double.parse(listItem['quantity'].toString());

                          return ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: CircleAvatar(
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
