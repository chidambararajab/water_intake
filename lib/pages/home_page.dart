import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:water_intake/data/water_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController(text: "10");

  void saveWater(String amount) async {
    final url = Uri.https(
      'water-intaker-ecb31-default-rtdb.firebaseio.com',
      'water.json',
    );

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'amount': double.parse(amount),
        'unit': 'ml',
        'dateTime': DateTime.now().toString(),
      }),
    );

    if (response.statusCode >= 200) {
      print('Data Saved');
    } else {
      print('Data Not Saved');
    }
  }

  void addWater() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Water Intake'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("How much water did you drink?"),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Amount (ml)"),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  saveWater(amountController.text);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Water Intake'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.water_drop_outlined),
                onPressed: () {},
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        body: const Center(
          child: Text('Hello World!'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addWater,
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
