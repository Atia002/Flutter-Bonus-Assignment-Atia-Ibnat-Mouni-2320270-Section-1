import 'package:flutter/material.dart';
import 'package:summer_iub_app/screens/coffe_records_screen.dart';
import 'package:summer_iub_app/screens/create_coffee_record_screen.dart';
import 'package:summer_iub_app/screens/firebase_coffee_records.dart';
import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String pageTitle;

  const HomePage({super.key, required this.pageTitle});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _coffeeCount = 0;

  Future<void> incrememntCoffeeCount() async {
    _coffeeCount++;

    setState(() {});

    print("Coffee Count: $_coffeeCount");

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection("count_collection").add({
      "coffee_count": _coffeeCount,
      "timestamp": Timestamp.now(),
    });
  }

  void navigateToCoffeeRecordsScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CoffeRecordsScreen()));
  }

  void navigateToCreateCoffeeRecordScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreateCoffeeRecordScreen()),
    );
  }

  void navigateToFirebaseCoffeeRecordsScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FirebaseCoffeRecordsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pageTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.00,
          ),
        ),
        backgroundColor: Colors.brown,
      ),

      body: AppBackgroudDesignWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10.00,
                horizontal: 20.00,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 25.00),
              child: Column(
                children: [
                  const Text(
                    "Welcome To Coffe House",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.00,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10.00),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          navigateToCreateCoffeeRecordScreen();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.00,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.brown,
                        ),
                        label: const Text(
                          "Order Now",
                          style: TextStyle(
                            color: Colors.brown,
                            fontSize: 18.00,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10.00),

                      IconButton.filled(
                        onPressed: () {
                          navigateToCoffeeRecordsScreen();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 30.00,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Firebase Button
                  ElevatedButton.icon(
                    onPressed: () {
                      navigateToFirebaseCoffeeRecordsScreen();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.cloud, color: Colors.brown),
                    label: const Text(
                      "Check Firebase",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30.00),

            const Text(
              "How many coffee cups did you drink today?",
              style: TextStyle(color: Colors.brown, fontSize: 18.00),
            ),

            Text(
              _coffeeCount.toString(),
              style: const TextStyle(
                color: Colors.brown,
                fontSize: 36.00,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          incrememntCoffeeCount();
        },
        child: const Icon(Icons.local_cafe),
      ),
    );
  }
}
