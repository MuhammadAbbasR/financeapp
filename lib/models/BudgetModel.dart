import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  String title;
  String category;
  double totalAmount;
  double spentAmount;


  BudgetModel({
    required this.title,
    required this.category,
    required this.totalAmount,
    this.spentAmount = 0.0,

  });

  double get remaining => totalAmount - spentAmount;

  double get progress => (spentAmount / totalAmount).clamp(0.0, 1.0);

  String get percentage => "${(progress * 100).toStringAsFixed(0)}%";

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      title: map['title'] ?? '',
      category: map['category'] ?? 'Uncategorized',
      totalAmount: (map['totalAmount'] as num).toDouble(),
      spentAmount: (map['spentAmount'] as num?)?.toDouble() ?? 0.0,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'totalAmount': totalAmount,
      'spentAmount': spentAmount,

    };
  }
}
