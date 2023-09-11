import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CartRepo {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _cartRef =
      FirebaseFirestore.instance.collection('CartCollection');
  Future<void> addToCart(
    String userID,
    String productID,
  ) async {
    final uuid = Uuid();
    final cartID = uuid.v4();
    final quantity = 1;

    try {
      await _cartRef.doc(cartID).set({
        'user_id': userID,
        'product_id': productID,
        'cart_id': cartID,
        'quantiy': quantity.toString(),
      });
    } catch (e) {
      throw Exception('Failed to add to cart');
    }
  }
}
