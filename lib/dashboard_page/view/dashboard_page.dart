import 'package:ecommerce/add_product_page/view/add_product.dart';
import 'package:ecommerce/confirmed_orders/view/confirmed_orders.dart';
import 'package:ecommerce/custom_widgets/dashboard_option.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/launch_page/view/launch_page.dart';
import 'package:ecommerce/view_products_page/view/view_products_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //heightSpacer(120),
            mainHeading('Dashboard'),
            heightSpacer(20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dashboardItem('Add A Product', Icons.add_box_rounded,
                    Colors.blue, AddProductPage()),
                dashboardItem(
                  'View My Products',
                  Icons.list,
                  Colors.orange,
                  ViewProductsPage(),
                ),
                dashboardItem(
                  'View Orders',
                  Icons.list,
                  Colors.teal,
                  ConfirmedOrders(),
                ),

                //Logout Option
                ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  onTap: () async {
                    await _auth.signOut();
                    await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LaunchPage(),
                        ));
                  },
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
