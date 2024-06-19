import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/models/water_model.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({
    super.key,
    required this.waterModel,
  });

  final WaterModel waterModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            const Icon(
              Icons.water_drop,
              size: 20,
              color: Colors.blue,
            ),
            Text(
              "${waterModel.amount.toString()} ml",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        subtitle: Text(
            '${waterModel.dateTime.day}/${waterModel.dateTime.month}/${waterModel.dateTime.year}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            var data = await Provider.of<WaterData>(context, listen: false)
                .deleteWaterData(waterModel.id.toString());

            print("data : $data");
            if (data == 200) {
              SnackBar snackBar = const SnackBar(
                content: Text("Deleted Successfully"),
                backgroundColor: Colors.blue,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              SnackBar snackBar = const SnackBar(
                content: Text("Failed to Deleted Item"),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ),
    );
  }
}
