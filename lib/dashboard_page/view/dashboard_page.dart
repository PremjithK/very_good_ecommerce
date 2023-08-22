import 'package:ecommerce/add_product_page/view/add_product.dart';
import 'package:ecommerce/custom_widgets/dashboard_option.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:ecommerce/view_products_page/view/view_products_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            heightSpacer(120),
            mainHeading('Dashboard'),
            heightSpacer(20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dashboardItem('Add A Product', Icons.add_box_rounded,
                    Colors.blue, AddProductPage()),
                dashboardItem('View My Products', Icons.list, Colors.orange,
                    ViewProductsPage()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
