import 'package:flutter/foundation.dart';

import '../data/response/Api_response.dart';
import '../models/TransactionModel.dart';
import '../service/TransactionService.dart';

class TransactionViewModel extends ChangeNotifier {
  TransactionService service;
  ApiResponse<List<TransactionModel>> _transactionresponse =
  ApiResponse.notStarted();

  TransactionViewModel(this.service);
  ApiResponse<List<TransactionModel>> get getTranscationResponse =>
      _transactionresponse;

  Future<void> getTransaction() async {
    _transactionresponse = ApiResponse.loading();
    notifyListeners();
    try {
      final value = await service.getAllTransactions();
      _transactionresponse = ApiResponse.completed(value);
    } catch (e) {
      _transactionresponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future addTransaction(TransactionModel transactionModel) async {
    _transactionresponse = ApiResponse.loading();
    notifyListeners();
    try {
      await service.addTransaction(transactionModel);

      await getTransaction();
    } catch (e) {
      _transactionresponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future deleteTransaction(TransactionModel transactionModel) async {
    _transactionresponse = ApiResponse.loading();
    notifyListeners();

    try {
      await service.removeTransaction(transactionModel.id);

      await getTransaction();
    } catch (e) {
      _transactionresponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future updateTransaction(TransactionModel transactionModel) async {
    _transactionresponse = ApiResponse.loading();
    notifyListeners();
    try {
      await service.updateTransaction(transactionModel);

      await getTransaction();
    } catch (e) {
      _transactionresponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  double get totalIncome {
    if (_transactionresponse.data == null) return 0;
    return _transactionresponse.data!
        .where((tx) => tx.type == "Income")
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get totalExpense {
    if (_transactionresponse.data == null) return 0;
    return _transactionresponse.data!
        .where((tx) => tx.type == "Expense")
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get balance => totalIncome - totalExpense;
}
