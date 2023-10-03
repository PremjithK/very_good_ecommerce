import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerSignupRepo {
  Future<void> createUser(
    String name,
    String email,
    String phoneNo,
    String password,
  ) async {
    final auth = FirebaseAuth.instance;
    final CollectionReference sellerRef = FirebaseFirestore.instance.collection('SellerCollection');
    try {
      final sellerCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sellerRef.doc(sellerCredential.user!.uid).set({
        'seller_id': auth.currentUser!.uid,
        'name': name,
        'email': email,
        'phone': phoneNo,
        'password': password,
        'type': 'seller',
      });
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed To Sign Up');
      print(e);
    }
  }
}
