import 'package:ecommerce/app/app.dart';
import 'package:ecommerce/bootstrap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await bootstrap(() => const App());
}
