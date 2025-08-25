import 'package:finance_app/models/TransactionGoalModel.dart';


class GoalModel {
  String name;
  double targetAmount;
  double currentAmount;
  List<TransactionGoalModel> transactions;

  GoalModel({
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.transactions = const [],
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'transactions': transactions.map((t) => t.toMap()).toList(),
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      name: map['name'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      currentAmount: (map['currentAmount'] ?? 0).toDouble(),
      transactions: map['transactions'] != null
          ? List<TransactionGoalModel>.from((map['transactions'] as List)
          .map((x) => TransactionGoalModel.fromMap(x)))
          : [],
    );
  }
}
