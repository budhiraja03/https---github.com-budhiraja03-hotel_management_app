import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'deletefooditem.dart'; // Import the DeleteFoodItemDialog or equivalent
import 'editfooditem.dart'; // Import the EditFoodItemDialog or equivalent
import 'foodItemModel.dart';

class FoodItemTile extends StatelessWidget {
  final FoodItem foodItem;

  const FoodItemTile({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Text(
                  foodItem.name,
                  style: GoogleFonts.getFont(
                    'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Description: ${foodItem.description}, Price: \$${foodItem.price.toStringAsFixed(2)}',
              style: GoogleFonts.getFont(
                'PT Sans',
                fontSize: 16,
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditFoodItemDialog(foodItem: foodItem);
                    },
                  );
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteFoodItemDialog(foodItem: foodItem);
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return ['edit', 'delete'].map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option == 'edit' ? 'Edit' : 'Delete'),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
