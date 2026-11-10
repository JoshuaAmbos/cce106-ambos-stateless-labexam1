import 'package:flutter/material.dart';
import 'shopping_cart_page.dart';

void main() {
  runApp(const StatelessLabExamApp());
}

typedef MyApp = StatelessLabExamApp;

class StatelessLabExamApp extends StatelessWidget {
  const StatelessLabExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateless Lab Exam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1972E6)),
        useMaterial3: true,
      ),
      home: const ShoppingCartPage(),
    );
  }
}