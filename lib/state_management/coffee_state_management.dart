import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';

class CoffeeStateManagement with ChangeNotifier {
  List<CoffeeRecordsModel> items = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Original local functionality
  void addData() {
    items.add(
      CoffeeRecordsModel(
        id: DateTime.now().microsecondsSinceEpoch,
        title: "Coffee Record ${items.length + 1}",
        des: "Details about Coffee Record ${items.length + 1}",
        amount: 10.0,
        date: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  // Original local add
  void addCoffeeRecord(CoffeeRecordsModel coffeeRecord) {
    items.add(coffeeRecord);
    notifyListeners();
  }

  // CREATE - Firebase
  Future<void> addCoffeeRecordToFirebase(
    CoffeeRecordsModel coffeeRecord,
  ) async {
    final dataModel = CoffeeRecordsModel(
      id: DateTime.now().microsecondsSinceEpoch,
      title: coffeeRecord.title,
      des: coffeeRecord.des,
      amount: coffeeRecord.amount,
      date: coffeeRecord.date,
    );

    final docRef = await firestore.collection("coffee_records").add({
      'id': dataModel.id,
      'title': dataModel.title,
      'des': dataModel.des,
      'amount': dataModel.amount,
      'date': Timestamp.fromDate(dataModel.date ?? DateTime.now()),
      'doc_id': '',
    });

    final docId = docRef.id;

    await firestore.collection("coffee_records").doc(docId).update({
      "doc_id": docId,
    });

    dataModel.docId = docId;

    items.add(dataModel);
    notifyListeners();
  }

  // UPDATE - Firebase
  Future<void> updateCoffeeRecordInFirebase({
    required String docId,
    required String title,
    required String des,
    required double amount,
  }) async {
    await firestore.collection("coffee_records").doc(docId).update({
      "title": title,
      "des": des,
      "amount": amount,
    });
  }
}
