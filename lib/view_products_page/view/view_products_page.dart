import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('My Prodcuts'),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _productsRef.where('seller_id', isEqualTo: _auth.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  final List<DocumentSnapshot> products = snapshot.data!.docs;
                  if (snapshot.hasData) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => heightSpacer(10),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final pro = products[index];
                        return ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          tileColor: Colors.white,
                          leading: Image.network(
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress != null) {
                                return const CircularProgressIndicator();
                              } else {
                                return child;
                              }
                            },
                            pro['product_image'][0] as String,
                            fit: BoxFit.contain,
                            width: 80,
                          ),
                          title: Text(
                            pro['product_name'] as String,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              textAlign: TextAlign.start,
                              'SL.NO: ${pro['product_details'] as String}'),
                          trailing: Text('Rs. ${pro['product_price'] as String}'),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            // TextButton.icon(
            //   onPressed: () {
            //     Get.to(DashboardPage());
            //   },
            //   icon: const Icon(Icons.arrow_back),
            //   label: const Text('Go Back'),
            // ),
          ],
        ),
      ),
    );
  }
}
