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

  // Placing Order Method
  // Future<void> placeOrder(
  //   List<String> cartIDs,
  // ) async {
  //   const uuid = Uuid();
  //   final orderID = uuid.v4();
  // Future<void> placeOrder({
  //   String? user_id,
  //   List<String>? productIDs,
  // }) async {
  //   const uuid = Uuid();
  //   final orderID = uuid.v4();

  //
  // final orderData = {
  //   'order_id': orderID,
  //   'product_ids': cartIDs,
  //   'status': 'pending',
  // };
  //   final orderData = {
  //     'order_id': orderID,
  //     'user_id': user_id,
  //     'product_id': productIDs,
  //     'quantity': 'nil',
  //     'status': 'pending',
  //   };

  //   try {
  //     // await _orderRef.doc(orderID).set(orderData);
  //     await _orderRef.add(orderData);
  //   } catch (e) {
  //     throw Exception('Failed to Make Order Collection');
  //   }
  // }
  //

  Future<String> placeOrder(
    String userID,
    List<Map<String, dynamic>> cartItems,
  ) async {
    const uuid = Uuid();
    final orderID = uuid.v4();
    // const orderID = '0000';

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
      // print(orderID);
      //await updateProductQuantitiesAndSubtotal(orderID, cartItems);

      return orderID;
    } catch (e) {
      throw Exception('Failed to Make Order Collection');
    }
  }

  // Future<void> updateProductQuantitiesAndSubtotal(
  //     String orderId, List<Map<String, dynamic>> cartItems) async {
  //   try {
  //     for (final cartItem in cartItems) {
  //       final productId = cartItem['product_id'] as String;
  //       final quantity = int.parse(cartItem['quantity'].toString());
  //       final subtotal = double.parse(cartItem['subtotal'].toString());
  //       print(orderId);
  //       // print('$productId, $quantity, $subtotal');

  //       // await _orderRef.doc(orderId).update({
  //       //   'quantity.$productId': FieldValue.increment(quantity),
  //       //   'subtotal.$productId': FieldValue.increment(subtotal),
  //       //   'product_ids.$productId': true,
  //       // });
  //       await _orderRef.doc(orderId).delete();
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to update product quantities and subtotal');
  //   }
  // }
}
