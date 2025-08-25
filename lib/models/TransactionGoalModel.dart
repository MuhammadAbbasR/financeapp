import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionGoalModel {
  String id;

  double amount;
  String type;
  DateTime date;
  String? note;

  TransactionGoalModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  });

  factory TransactionGoalModel.fromMap(Map<String, dynamic> map) {
    return TransactionGoalModel(
      id: map['id'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      type: map['type'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'date': date,
      'note': note,
    };
  }
}
