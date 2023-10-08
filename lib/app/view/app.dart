import 'dart:ui';

import 'package:ecommerce/l10n/l10n.dart';
import 'package:ecommerce/launch_page/view/launch_page.dart';
//import 'package:ecommerce/splash_screen/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PlusJakarta',
        appBarTheme: const AppBarTheme(
          color: Colors.purple,
          titleTextStyle: TextStyle(
            fontFamily: 'PlusJakarta',
            fontSize: 20,
            letterSpacing: 0.25,
            fontVariations: [
              FontVariation('wght', 800),
            ],
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.purple,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LaunchPage(),
    );
  }
}
