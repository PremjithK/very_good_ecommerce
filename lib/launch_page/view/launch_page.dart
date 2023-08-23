import 'package:ecommerce/custom_widgets/dashboard_option.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/customer_login_page/login_page.dart';
import 'package:ecommerce/customer_sign_up/customer_sign_up.dart';
import 'package:ecommerce/seller_login_page/seller_login_page.dart';
import 'package:ecommerce/seller_sign_up_page/sign_up_page.dart';
import 'package:flutter/material.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mainHeading('Welcome to E-Comm'),
            heightSpacer(20),
            dashboardItem(
              'Login as Customer',
              Icons.person,
              Colors.pinkAccent,
              CustomerLoginPage(),
            ),
            dashboardItem(
              'Sign Up as Customer',
              Icons.person,
              Colors.pinkAccent,
              CustomerSignupPage(),
            ),
            heightSpacer(10),
            dashboardItem(
              'Login as Seller',
              Icons.work,
              Colors.blue,
              SellerLoginPage(),
            ),
            dashboardItem(
              'Become a Seller',
              Icons.work,
              Colors.blue,
              SellerSignupPage(),
            ),
            heightSpacer(10),
          ],
        ),
      ),
    );
  }
}
