import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WaterData(),
      child: MaterialApp(
        title: 'Water Intake',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
