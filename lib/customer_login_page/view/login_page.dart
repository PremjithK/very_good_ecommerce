import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/customer_dashboard_page/view/customer_dashboard_page.dart';
import 'package:ecommerce/customer_sign_up/customer_sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerLoginPage extends StatelessWidget {
  CustomerLoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //
  final userType = 'customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Row(
        children: [
          TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              label: Text('Back')),
          heightSpacer(10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mainHeading('Welcome, Customer.'),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid Email';
                  }
                },
                decoration: InputDecoration(hintText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid Password';
                  }
                },
                decoration: InputDecoration(hintText: 'Password'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final customerRef = FirebaseFirestore.instance
                        .collection('CustomerCollection')
                        .where('email', isEqualTo: _emailController.text)
                        .get();
                    final result = await customerRef;
                    if (result.docs.isNotEmpty) {
                      try {
                        final auth = FirebaseAuth.instance;
                        final userRef = await auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        Get.to(UserDashboardPage());
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Invalid Email Or Password'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('No Such User Exists'),
                        ),
                      );
                    }
                  },
                  child: const Text('Log In')),
              TextButton(
                  onPressed: () {
                    Get.to(CustomerSignupPage());
                  },
                  child: Text('Create An Account')),
            ],
          ),
        ),
      ),
    );
  }
}
