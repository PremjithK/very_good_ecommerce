import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CartRepo {
  Future<void> addToCart(String userID, String productID) async {
    const quantity = 1;

    try {
      final cartDoc = await FirebaseFirestore.instance
          .collection('CartCollection')
          .where('product_id', isEqualTo: productID)
          .get();

      if (cartDoc.docs.isEmpty) {
        const uuid = Uuid();
        final cartID = uuid.v4();
        await FirebaseFirestore.instance.collection('CartCollection').doc(cartID).set({
          'cart_id': cartID,
          'product_id': productID,
          'quantity': quantity,
          'user_id': userID,
        });
      } else {
        throw Exception('AlreadyAddedToCart');
      }
    } catch (e) {
      throw Exception('Failed to add to cart');
    }
  }
}

class OrderRepo {
  final CollectionReference _orderRef = FirebaseFirestore.instance.collection('OrderCollection');

  Future<String> placeOrder(
    String userID,
    List<Map<String, dynamic>> cartItems,
  ) async {
    const uuid = Uuid();
    final orderID = uuid.v4();

    final orderData = {
      'order_id': orderID,
      'user_id': userID, // Store user ID instead of item IDs
      'status': 'pending',
      'quantity': {}, // Initialize as an empty map
      'subtotal': {}, // Initialize as an empty map
      'product_ids': {}, // Initialize as an empty map
    };

    try {
      await _orderRef.doc(orderID).set(orderData);

      return orderID;
    } catch (e) {
      throw Exception('Failed to Make Order Collection');
    }
  }
}
