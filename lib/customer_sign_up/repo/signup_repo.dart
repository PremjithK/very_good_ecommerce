import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerSignupRepo {
  Future<void> createUser(
    String name,
    String email,
    String phoneNo,
    String password,
    BuildContext context,
  ) async {
    final auth = FirebaseAuth.instance;
    final CollectionReference userRef =
        FirebaseFirestore.instance.collection('CustomerCollection');
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userRef.doc(userCredential.user!.uid).set({
        'user_id': auth.currentUser!.uid,
        'name': name,
        'email': email,
        'phone': phoneNo,
        'password': password,
      });
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed To Sign Up');
      print(e);
    }
  }
}
