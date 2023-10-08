import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProductRepo {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('ProductCollection');
  Future<void> addProduct(
    String productName,
    String productDetails,
    String productPrice,
    String productStock,
    List<XFile> productImageList,
  ) async {
    final uuid = Uuid();
    final productId = uuid.v4();
    final List<String>? image = [];

    try {
      for (final element in productImageList) {
        final ref = FirebaseStorage.instance.ref().child('ProductImages').child(element.name);

        final file = File(element.path);
        await ref.putFile(file);
        final productImage = await ref.getDownloadURL();
        image!.add(productImage);
      }

      await _productRef.doc(productId).set({
        'product_id': productId,
        'product_name': productName,
        'product_details': productDetails,
        'product_price': productPrice,
        'product_image': image,
        'stock': productStock,
        'seller_id': _auth.currentUser!.uid,
      });
    } catch (e) {
      throw Exception('Failed To Add Product!');
    }
  }
}
