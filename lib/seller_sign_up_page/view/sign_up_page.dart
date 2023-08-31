import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/seller_login_page/view/seller_login_page.dart';
import 'package:ecommerce/seller_sign_up_page/repo/signup_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerSignupPage extends StatelessWidget {
  SellerSignupPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              heightSpacer(1),
              Column(
                children: [
                  mainHeading('Become A Seller'),
                  heightSpacer(10),
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Username';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Merchant Name'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Email';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Phone Number';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Phone No.'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an Password';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(SellerLoginPage());
                      },
                      child: Text('Already Have An Account? Click Here')),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await SellerSignupRepo().createUser(
                          _usernameController.text,
                          _emailController.text,
                          _phoneController.text,
                          _passwordController.text,
                          context,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerLoginPage(),
                          ),
                        );
                      }
                    },
                    child: const Text('Create Account'),
                  )
                ],
              ),
              heightSpacer(10),
            ],
          ),
        ),
      ),
    );
  }
}
