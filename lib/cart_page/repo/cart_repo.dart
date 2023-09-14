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
    const quantity = 1;

    try {
      await _cartRef.doc(cartID).set({
        'user_id': userID,
        'product_id': productID,
        'cart_id': cartID,
        'quantity': quantity.toString(),
      });
    } catch (e) {
      throw Exception('Failed to add to cart');
    }
  }
}

class OrderRepo {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _orderRef =
      FirebaseFirestore.instance.collection('OrderCollection');

  //
  Future<void> placeOrder(List<String> cartIDs) async {
    final uuid = Uuid();
    final orderID = uuid.v4();

    try {
      await _orderRef.doc(orderID).set({
        'order_id': orderID,
        'status': 'pending',
        'item_ids': cartIDs,
      });
    } catch (e) {
      throw Exception('Failed to add to cart');
    }
  }
}
