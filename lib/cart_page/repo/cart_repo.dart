import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AddProductRepo {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _cartRef =
      FirebaseFirestore.instance.collection('CartCollection');
  Future<void> addToCart(
    String userID,
    String productID,
  ) async {
    final uuid = Uuid();
    final cartID = uuid.v4();
  }
}
