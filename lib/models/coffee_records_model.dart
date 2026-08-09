import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeRecordsModel {
  int? id;
  String? title;
  String? des;
  double? amount;
  DateTime? date;
  String? docId;

  CoffeeRecordsModel({
    this.id,
    this.title,
    this.des,
    this.amount,
    this.date,
    this.docId,
  });

  factory CoffeeRecordsModel.fromJson(Map<String, dynamic> json) {
    return CoffeeRecordsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      des: json['des'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date:
          json['date'] is Timestamp
              ? (json['date'] as Timestamp).toDate()
              : DateTime.now(),
      docId: json['doc_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'des': des,
      'amount': amount,
      'date': Timestamp.fromDate(date ?? DateTime.now()),
      'doc_id': docId ?? '',
    };
  }
}
