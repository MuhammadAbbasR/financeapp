import 'package:flutter/material.dart';

import '../data/response/Api_response.dart';
import '../data/response/Status.dart';
import '../models/BudgetModel.dart';
import '../models/TransactionModel.dart';
import '../service/BudgetService.dart';
import 'Transaction_VM.dart';

class BudgetViewModel extends ChangeNotifier {
  final BudgetService _budgetService;
  final TransactionViewModel transactionVM;
  void setTransactionViewModel(TransactionViewModel transactionVM) {
    transactionVM = transactionVM;

    transactionVM!.addListener(() {
      getBudget();
    });
  }

  ApiResponse<List<BudgetModel>> _budgetResponse = ApiResponse.notStarted();
  ApiResponse<List<TransactionModel>> _tranResponse = ApiResponse.notStarted();
  ApiResponse<List<BudgetModel>> get budgetResponse => _budgetResponse;
  ApiResponse<List<TransactionModel>> get tranResponse => _tranResponse;

  BudgetViewModel(this._budgetService, this.transactionVM) {
    transactionVM.addListener(_recalculateBudgets);
  }

  void _recalculateBudgets() async {
    if (transactionVM.getTranscationResponse.status == Status.completed) {
      await getBudget();
    }
  }

  Future<void> getBudget() async {
    _budgetResponse = ApiResponse.loading();
    notifyListeners();

    try {
      final budgets = await _budgetService.getBudgets();

      for (var budget in budgets) {

        final transactions = await _budgetService.getTransactionsByCategory(
          category: budget.category,
        );

        double spent = 0.0;
        for (var t in transactions) {
          spent += t.amount;
        }

        budget.spentAmount = spent;
      }

      _budgetResponse = ApiResponse.completed(budgets);
    } catch (e) {
      _budgetResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> addBudget(BudgetModel budgetModel) async {
    _budgetResponse = ApiResponse.loading();
    notifyListeners();

    try {
      await _budgetService.addBudget(budgetModel);
      await getBudget();
    } catch (e) {
      _budgetResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> removeBudget(BudgetModel budgetModel) async {
    _budgetResponse = ApiResponse.loading();
    notifyListeners();

    try {
      await _budgetService.removeBudget(budgetModel);
      await getBudget();
    } catch (e) {
      _budgetResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> getTransaction(BudgetModel budgetModel) async {
    _tranResponse = ApiResponse.loading();
    notifyListeners();
    try {
      final value = await _budgetService.getTransactionsByCategory(
          category: budgetModel.category,
        );
      _tranResponse = ApiResponse.completed(value);
    } catch (e) {
      _tranResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  @override
  void dispose() {
    transactionVM.removeListener(_recalculateBudgets);
    super.dispose();
  }
}
