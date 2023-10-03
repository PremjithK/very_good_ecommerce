import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/dashboard_page/view/dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewProductsPage extends StatefulWidget {
  const ViewProductsPage({super.key});

  @override
  State<ViewProductsPage> createState() => _ViewProductsPageState();
}

class _ViewProductsPageState extends State<ViewProductsPage> {
  final _auth = FirebaseAuth.instance;
  late CollectionReference _productsRef;

  @override
  void initState() {
    super.initState();
    _productsRef = FirebaseFirestore.instance.collection('ProductCollection');
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            heightSpacer(50),
            mainHeading('My Products'),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _productsRef.where('seller_id', isEqualTo: _auth.currentUser!.uid).snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  final List<DocumentSnapshot> products = snapshot.data!.docs;
                  if (snapshot.hasData) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => heightSpacer(10),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final pro = products[index];
                        return ListTile(
                          tileColor: Colors.white,
                          leading: Image.network(
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress != null)
                                return CircularProgressIndicator();
                              else
                                return child;
                            },
                            pro['product_image'][0] as String,
                            fit: BoxFit.contain,
                            width: 100,
                          ),
                          title: Text(
                            pro['product_name'] as String,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              textAlign: TextAlign.start,
                              'SL.NO: ${pro['product_details'] as String}'),
                          trailing: Text('Rs. ${pro['product_price'] as String}'),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Get.to(DashboardPage());
              },
              icon: Icon(Icons.arrow_back),
              label: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
