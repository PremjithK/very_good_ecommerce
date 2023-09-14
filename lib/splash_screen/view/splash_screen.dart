import 'package:ecommerce/launch_page/view/launch_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void changeScreen() {
    Future.delayed(
      Duration(seconds: 3),
      () { 
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LaunchPage(),
            ));
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.network(
            //   'https://marketplace.canva.com/EAFauoQSZtY/1/0/1600w/canva-brown-mascot-lion-free-logo-qJptouniZ0A.jpg',
            //   height: 100,
            //   width: 100,
            // ),
            Lottie.asset(
              'assets/lottie_animations/animation_llyyf3lq.json',
              height: 200,
              width: 200,
            ),
            Text(
              'E-Commerce',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
