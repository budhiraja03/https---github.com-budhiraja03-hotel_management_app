import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'foodItemModel.dart'; // Create a FoodItem model class
import 'foodTile.dart'; // Create a FoodItemTile or equivalent
import 'newfood.dart'; // Import the NewFoodItemForm or equivalent

class FoodMenuPage extends StatefulWidget {
  final User? user;
  const FoodMenuPage({Key? key, this.user}) : super(key: key);

  @override
  State<FoodMenuPage> createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  List<FoodItem> foodItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodMenu();
  }

  Future<List<FoodItem>> fetchFoodMenu() async {
    final foodItemQuery = await FirebaseFirestore.instance
        .collection('managers')
        .doc(widget.user!.uid)
        .collection('foodmenu')
        .get();
    final foodItemQuerySnapshot = foodItemQuery;
    final foodItemDocuments = foodItemQuerySnapshot.docs;
    final foodItems = foodItemDocuments.map((doc) {
      final data = doc.data();
      return FoodItem(
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        price: data['price'] != null
            ? double.tryParse(data['price'].toString()) ?? 0.0
            : 0.0,
      );
    }).toList();
    return foodItems;
  }

  Future<void> _fetchFoodMenu() async {
    final menuList = await fetchFoodMenu();
    setState(() {
      foodItems = menuList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildFoodMenu(), // Call a function to build the food menu
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: customFAB(context),
    );
  }

  FloatingActionButton customFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => newFoodDialog(context),
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.add),
    );
  }

  newFoodDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewFoodItemForm();
      },
    ).then((value) => setState(() {}));
  }

  Widget _buildFoodMenu() {
    if (foodItems.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return FoodItemTile(foodItem: foodItems[index]);
          },
          childCount: foodItems.length,
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: Center(
          child: Text('There is nothing to show'),
        ),
      );
    }
  }
}

