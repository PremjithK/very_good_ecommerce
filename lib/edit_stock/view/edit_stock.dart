import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EditStockPage extends StatefulWidget {
  const EditStockPage({super.key});

  @override
  State<EditStockPage> createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Initialized
  }

  final sellerID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stock'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('ProductCollection')
                .where('seller_id', isEqualTo: sellerID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final productSnapshot = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: productSnapshot.length,
                  itemBuilder: (context, index) {
                    final product = productSnapshot[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        tileColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        leading: Image.network(
                          product['product_image'][0].toString(),
                          fit: BoxFit.cover,
                          height: 150,
                        ),
                        title: Text(
                          product['product_name'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'x${product['stock'].toString()}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            widthSpacer(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(Icons.add),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(Icons.remove),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: Text('No Products'));
            },
          ),
        ),
      ),
    );
  }
}
