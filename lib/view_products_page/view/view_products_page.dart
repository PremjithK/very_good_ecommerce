import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewProductsPage extends StatefulWidget {
  ViewProductsPage({super.key});

  @override
  State<ViewProductsPage> createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {
  final _auth = FirebaseAuth.instance;
  late CollectionReference _productsRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productsRef = FirebaseFirestore.instance.collection('ProductsCollection');
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            heightSpacer(50),
            mainHeading('My Products'),
            heightSpacer(10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsRef
                    .where('seller_id', isEqualTo: _auth.currentUser!.uid)
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  final List<DocumentSnapshot> products = snapshot.data!.docs;
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final pro = products[index];
                        return ListTile(
                          leading: Image.network(
                            pro['product_image'][0] as String,
                            height: 50,
                            width: 50,
                          ),
                          title: Text(
                            pro['product_name'] as String,
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'SL.NO: ${pro['product_serialno'] as String}'),
                          trailing:
                              Text('Rs. ${pro['product_price'] as String}'),
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
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
