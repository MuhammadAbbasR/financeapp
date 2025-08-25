import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  String accountId;
  double amount;
  String type;
  String category;
  DateTime date;
  String? note;

  TransactionModel({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      accountId: map['accountId'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      date: (map['date']).toDate(),
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
      'note': note,
    };
  }
}
