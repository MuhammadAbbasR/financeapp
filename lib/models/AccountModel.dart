import 'package:flutter/foundation.dart';

class AccountModel {
  String id;
  String name;
  double balance;

  AccountModel({
    required this.id,
    required this.name,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'],
      name: map['name'],
      balance: (map['balance'] ?? 0).toDouble(),
    );
  }
}
