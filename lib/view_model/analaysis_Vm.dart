import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/response/Api_response.dart';
import '../models/TransactionModel.dart';
import '../service/TransactionService.dart';

class AnalysisViewModel extends ChangeNotifier {
  final TransactionService service;

  ApiResponse<List<TransactionModel>> _analysisResponse =
  ApiResponse.notStarted();
  ApiResponse<List<TransactionModel>> get getAnalysisResponse =>
      _analysisResponse;
  ApiResponse<Map<String, double>> _chartresponse = ApiResponse.notStarted();
  ApiResponse<Map<String, double>> get getchartresponse => _chartresponse;
  Map<String, double> chart = {};
  //Map<String, double> get getChart => chart;
  AnalysisViewModel(this.service);
  String selectedtype = "Expense";
  String get getselectedtype => selectedtype;

  void setSelected(String type) {
    selectedtype = type;
  }

  Future<void> getCategoryAnalysis() async {
    _analysisResponse = ApiResponse.loading();
    _chartresponse = ApiResponse.loading();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      chart = {};
      final value = await service.getTransactionbyType(selectedtype);
      for (var t in value) {
        chart[t.category] = (chart[t.category] ?? 0) + t.amount.toDouble();
      }
      _analysisResponse = ApiResponse.completed(value);
      _chartresponse = ApiResponse.completed(chart);
    } catch (e) {
      _analysisResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
