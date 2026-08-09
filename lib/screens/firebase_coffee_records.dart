import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';
import 'package:summer_iub_app/state_management/coffee_state_management.dart';
import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';

class FirebaseCoffeRecordsScreen extends StatelessWidget {
  const FirebaseCoffeRecordsScreen({super.key});

  void showEditDialog(
    BuildContext context,
    CoffeeRecordsModel record,
    String docId,
  ) {
    final titleController = TextEditingController(text: record.title ?? '');

    final descriptionController = TextEditingController(text: record.des ?? '');

    final amountController = TextEditingController(
      text: record.amount?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Coffee Record"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;

                final csm = Provider.of<CoffeeStateManagement>(
                  context,
                  listen: false,
                );

                await csm.updateCoffeeRecordInFirebase(
                  docId: docId,
                  title: titleController.text.trim(),
                  des: descriptionController.text.trim(),
                  amount: amount,
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Firebase Coffee Records",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),

      body: AppBackgroudDesignWidget(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              firestore
                  .collection("coffee_records")
                  .orderBy("date")
                  .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No Coffee Records Found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),

              itemCount: snapshot.data!.docs.length,

              itemBuilder: (context, index) {
                final document = snapshot.data!.docs[index];

                final coffeeRecord = CoffeeRecordsModel.fromJson(
                  document.data(),
                );

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.coffee, color: Colors.brown),

                    title: Text(coffeeRecord.title ?? ''),

                    subtitle: Text(
                      "${coffeeRecord.des ?? ''}\n"
                      "Amount: ${coffeeRecord.amount ?? 0}",
                    ),

                    isThreeLine: true,

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // EDIT
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showEditDialog(context, coffeeRecord, document.id);
                          },
                        ),

                        // DELETE
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await firestore
                                .collection("coffee_records")
                                .doc(document.id)
                                .delete();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      // FIREBASE TEST RECORD BUTTON
      floatingActionButton: Consumer<CoffeeStateManagement>(
        builder: (context, csm, _) {
          return FloatingActionButton(
            onPressed: () async {
              await csm.addCoffeeRecordToFirebase(
                CoffeeRecordsModel(
                  id: DateTime.now().microsecondsSinceEpoch,
                  title: "New Coffee Record ${csm.items.length + 1}",
                  des: "This is test data",
                  amount: 10.0,
                  date: DateTime.now(),
                ),
              );
            },
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            child: const Icon(Icons.local_cafe),
          );
        },
      ),
    );
  }
}
