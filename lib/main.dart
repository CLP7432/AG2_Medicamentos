import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const MedicamentosApp());

class MedicamentosApp extends StatelessWidget {
  const MedicamentosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconocimiento de Medicamentos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}