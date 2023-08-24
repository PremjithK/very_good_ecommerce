import 'package:ecommerce/l10n/l10n.dart';
import 'package:ecommerce/launch_page/view/launch_page.dart';
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
        appBarTheme: const AppBarTheme(color: Colors.orangeAccent),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.orangeAccent,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LaunchPage(),
    );
  }
}
