import 'package:finance_app/service/AccountService.dart';
import 'package:finance_app/service/BudgetService.dart';
import 'package:finance_app/service/GoalService.dart';
import 'package:finance_app/service/TransactionService.dart';
import 'package:finance_app/view_model/Account_Vm.dart';
import 'package:finance_app/view_model/Budget_Vm.dart';
import 'package:finance_app/view_model/Goal_VM.dart';
import 'package:finance_app/view_model/Transaction_VM.dart';
import 'package:finance_app/view_model/analaysis_Vm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'confi/constants/Color.dart';
import 'confi/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyAAVxxqWVxb_0yYNW9zwnHONjh71GUmGZg',
        appId: '1:222135710420:android:a08aef630fabc90be04141',
        messagingSenderId: '222135710420',
        projectId: 'practicefyp-c3931',
        storageBucket: 'practicefyp-c3931.firebasestorage.app'),
  );



  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AccountViewModel(AccountService())),
        ChangeNotifierProvider(
            create: (_) => AnalysisViewModel(TransactionService())),
        ChangeNotifierProvider(
            create: (_) => TransactionViewModel(TransactionService())),
        ChangeNotifierProvider(create: (_) => GoalViewModel(GoalService())),
        ChangeNotifierProxyProvider<TransactionViewModel, BudgetViewModel>(
          create: (_) => BudgetViewModel(
              BudgetService(), TransactionViewModel(TransactionService())),
          update: (_, transactionVM, budgetVM) {
            budgetVM!.setTransactionViewModel(transactionVM);
            return budgetVM;
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light(),
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: AppRoutes.router,
    );
  }
}
