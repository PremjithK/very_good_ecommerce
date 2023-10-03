import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/dashboard_page/view/dashboard_page.dart';
import 'package:ecommerce/launch_page/view/launch_page.dart';
import 'package:ecommerce/seller_sign_up_page/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerLoginPage extends StatelessWidget {
  SellerLoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heightSpacer(60),
              Column(
                children: [
                  const Text(
                    'Seller Login',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  heightSpacer(20),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid Email';
                      }
                    },
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid Password';
                      }
                    },
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        //
                        final customerRef = FirebaseFirestore.instance
                            .collection('SellerCollection')
                            .where('email', isEqualTo: _emailController.text)
                            .get();
                        final result = await customerRef;
                        if (result.docs.isNotEmpty) {
                          try {
                            final auth = FirebaseAuth.instance;
                            await auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            await Get.to(DashboardPage());
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => DashboardPage(),
                            //     ));
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
                              content: Text('No Such Seller Exists'),
                            ),
                          );
                        }
                      },
                      child: const Text('Log In')),
                  TextButton(
                      onPressed: () {
                        Get.to(SellerSignupPage());
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SellerSignupPage(),
                        //   ),
                        // );
                      },
                      child: const Text('Create An Account')),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  Get.to(LaunchPage());
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
