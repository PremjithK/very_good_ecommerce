import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProductRepo {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('ProductsCollection');
  Future<void> createImageTask(
    String productName,
    String productSerialNo,
    String productPrice,
    List<XFile> productImageList,
  ) async {
    final uuid = Uuid();
    final productId = uuid.v4();
    final List<String>? image = [];

    try {
      for (final element in productImageList) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('ProductImages')
            .child(element.name);

        final file = File(element.path);
        await ref.putFile(file);
        final productImage = await ref.getDownloadURL();
        image!.add(productImage);
      }

      await _productRef.doc(productId).set({
        'product_name': productName,
        'product_serialno': productSerialNo,
        'product_price': productPrice,
        'product_image': image,
        'seller_id': _auth.currentUser!.uid,
      });
    } catch (e) {
      throw Exception('Failed To Add Product!');
    }
  }
}
