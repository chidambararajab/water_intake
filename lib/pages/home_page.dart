import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/models/water_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController(text: "10");

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
                  saveWater();
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              )
            ],
          );
        });
  }

  void saveWater() async {
    Provider.of<WaterData>(context, listen: false).addWaterData(
      WaterModel(
        amount: double.parse(amountController.text),
        dateTime: DateTime.now(),
        id: DateTime.now().toString(),
        unit: 'ml',
      ),
    );

    if (!context.mounted) {
      // ? Reason: We want to do this because since we're inside of an async await function, the widget might be disposed before the await function is done doing its job. so we need to check if the widget is still mounted before we do anything. Otherwise we end up getting an error.
      return; // ? Reason: if widget not mounted don't do anything.
    }
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
        body: FutureBuilder<List<WaterModel>>(
          future: WaterData().getWaterData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No books found.'));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    WaterModel data = snapshot.data![index];
                    return ListTile(
                      title: Text(data.amount.toString()),
                    );
                  });
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addWater,
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
