import 'package:ecommerce/login_page/view/login_page.dart';
import 'package:ecommerce/sign_up_page/repo/signup_repo.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Signup As Seller',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter an Username';
                  }
                },
                decoration: InputDecoration(hintText: 'Username'),
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
                  onPressed: () => MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                  child: Text('Already Have An Account? Click Here')),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await SignupRepo().createUser(
                      _usernameController.text,
                      _emailController.text,
                      _phoneController.text,
                      _passwordController.text,
                      context,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  }
                },
                child: const Text('Create Account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
