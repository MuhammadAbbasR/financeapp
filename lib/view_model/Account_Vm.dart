import 'package:flutter/material.dart';
import '../data/response/Api_response.dart';
import '../models/AccountModel.dart';
import '../service/AccountService.dart';


class AccountViewModel extends ChangeNotifier {
  AccountService accountservice;
  AccountViewModel(this.accountservice);
  ApiResponse<List<AccountModel>> response = ApiResponse.notStarted();
  ApiResponse<List<AccountModel>> get getresponse => response;

  Future<void> getAccount() async {
    response = ApiResponse.loading();
    notifyListeners();

    try {
      final accounts = await accountservice.getAccounts();
      response = ApiResponse.completed(accounts);
    } catch (e) {
      response = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> addAccount(String id, String name, double amount) async {
    response = ApiResponse.loading();
    notifyListeners();
    try {
      final value = await accountservice
          .addAccount(AccountModel(id: id, name: name, balance: amount));
      if (value) {
        response = ApiResponse.success("Account Created");
        await getAccount();
      }
    } catch (e) {
      response = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future removeAccount(String id) async {
    response = ApiResponse.loading();
    notifyListeners();
    try {
      final result = await accountservice.removeAccount(id);
      if (result) {
        response = ApiResponse.success("Succes");
        getAccount();
      } else {
        response = ApiResponse.error("Not successfull");
      }
    } catch (e) {
      response = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future updateaccount(String id, double balance) async {
    response = ApiResponse.loading();
    notifyListeners();
    try {
      final value = await accountservice.updateaccountbalance(id, balance);
      if (value) {
        response = ApiResponse.success("Successfull");
      } else {
        response = ApiResponse.success("Not Successfull");
      }
    } catch (e) {
      response = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
