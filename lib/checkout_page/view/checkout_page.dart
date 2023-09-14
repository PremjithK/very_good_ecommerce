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
        title: Text('Checkout From Cart'),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
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
                      mainHeading('Rs. ${widget.grandTotal}'),
                    ],
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: StadiumBorder()),
                      onPressed: () {
                        //? Proceed To Payment Page
                        //? Create Order Table and Fill In

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                titlePadding: EdgeInsets.only(bottom: 200),
                                icon: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Payment Method'),
                                    ElevatedButton(
                                        onPressed: () {}, child: Text('COD')),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Razorpay')),
                                  ],
                                ));
                          },
                        );
                      },
                      icon: Icon(Icons.payment),
                      label: Text('Pay'))
                ],
              ),
              heightSpacer(20),
              SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.productsToBuy.length,
                      itemBuilder: (BuildContext context, int index) {
                        final listItem = widget.productsToBuy[index];

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                          ),
                          title: Text(listItem['name'].toString()),
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
    );
  }
}
