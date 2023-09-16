import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CartRepo {
  final CollectionReference _cartRef =
      FirebaseFirestore.instance.collection('CartCollection');
  //
  Future<void> addToCart(
    String userID,
    String productID,
  ) async {
    const uuid = Uuid();
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
  final CollectionReference _orderRef =
      FirebaseFirestore.instance.collection('OrderCollection');

  //
  Future<void> placeOrder(List<String> cartIDs) async {
    const uuid = Uuid();
    final orderID = uuid.v4();

    //
    final orderData = {
      'order_id': orderID,
      'status': 'pending',
      'item_ids': cartIDs,
    };

    try {
      await _orderRef.doc(orderID).set(orderData);
    } catch (e) {
      throw Exception('Failed to Make Order Collection');
    }
  }
}
