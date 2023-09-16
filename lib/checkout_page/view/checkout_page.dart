import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    required this.productsToBuy,
    required this.grandTotal,
    required this.cartIDs,
    super.key,
  });
  final double grandTotal;
  final List<Map<String, dynamic>> productsToBuy;
  final List<String> cartIDs;
  //
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
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
                                horizontal: 30, vertical: 10),
                            shape: StadiumBorder()),
                        onPressed: () {
                          //? Proceed To Payment Page
                          //? Create Order Table and Fill In

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
                                          shape: StadiumBorder(),
                                        ),
                                        onPressed: () {},
                                        child: Text('Cash On Delivery')),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(),
                                            backgroundColor: Colors.indigo),
                                        onPressed: () {},
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
                        physics: NeverScrollableScrollPhysics(),
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
