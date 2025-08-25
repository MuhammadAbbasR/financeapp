import 'package:flutter/material.dart';

import '../data/response/Api_response.dart';
import '../models/GoalModel.dart';
import '../models/TransactionGoalModel.dart';
import '../service/GoalService.dart';

class GoalViewModel extends ChangeNotifier {
  final GoalService _goalService;
  GoalViewModel(this._goalService);

  ApiResponse<List<GoalModel>> _goalResponse = ApiResponse.notStarted();
  ApiResponse<List<TransactionGoalModel>> _trangoalResponse =
  ApiResponse.notStarted();
  ApiResponse<List<GoalModel>> get goalResponse => _goalResponse;
  ApiResponse<List<TransactionGoalModel>> get trangoalResponse =>
      _trangoalResponse;

  GoalModel? selectedGoal;

  void setSelectedGoal(GoalModel goal) {
    selectedGoal = goal;
    notifyListeners();
  }

  Future getGoal() async {
    _goalResponse = ApiResponse.loading();
    notifyListeners();

    try {
      final value = await _goalService.getGoals();
      _goalResponse = ApiResponse.completed(value);
    } catch (e) {
      _goalResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future addGoal(GoalModel goalModel) async {
    _goalResponse = ApiResponse.loading();
    notifyListeners();
    try {
      await _goalService.addGoals(goalModel);
      await getGoal();
    } catch (e) {
      _goalResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future removeGoal(GoalModel goalModel) async {
    _goalResponse = ApiResponse.loading();
    notifyListeners();
    try {
      await _goalService.removeGoals(goalModel);
      await getGoal();
    } catch (e) {
      _goalResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future getTranGoal(GoalModel goalModel) async {
    _trangoalResponse = ApiResponse.loading();
    notifyListeners();

    try {
      final value = await _goalService.getTransactions(goalModel.name);
      _trangoalResponse = ApiResponse.completed(value);
    } catch (e) {
      _trangoalResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future addTranGoal(
      GoalModel goalModel, TransactionGoalModel transactionGoalModel) async {
    _trangoalResponse = ApiResponse.loading();
    notifyListeners();
    try {
      await _goalService.addTransaction(goalModel.name, transactionGoalModel);
      final index =
      _goalResponse.data?.indexWhere((g) => g.name == goalModel.name);
      if (index != null && index >= 0) {
        final updatedGoal = _goalResponse.data![index];
        updatedGoal.currentAmount += transactionGoalModel.amount;
        _goalResponse.data![index] = updatedGoal;
        setSelectedGoal(updatedGoal);
      }
      await getTranGoal(goalModel);
      await getGoal();
    } catch (e) {
      _trangoalResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future removeTranGoal(
      GoalModel goalModel, TransactionGoalModel transactionGoalModel) async {
    _trangoalResponse = ApiResponse.loading();
    notifyListeners();
    try {
      await _goalService.removeTransaction(
          goalModel.name, transactionGoalModel);
      final index =
      _goalResponse.data?.indexWhere((g) => g.name == goalModel.name);
      if (index != null && index >= 0) {
        final updatedGoal = _goalResponse.data![index];
        updatedGoal.currentAmount -= transactionGoalModel.amount;
        _goalResponse.data![index] = updatedGoal;
        setSelectedGoal(updatedGoal);
      }
      await getTranGoal(goalModel);
      await getGoal();
    } catch (e) {
      _trangoalResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
