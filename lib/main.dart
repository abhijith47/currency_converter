import 'package:currencyconverter/UI/calculator.dart';
import 'package:currencyconverter/UI/currencies.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Currency Calculator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Calculator(),
        routes: {
          Calculator.routeName: (context) => Calculator(),
          CurrenciesPage.routeName: (context) => const CurrenciesPage(),
        });
  }
}
