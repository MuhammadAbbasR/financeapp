import 'package:finance_app/confi/routes/routesname.dart';
import 'package:finance_app/view/Transaction_Feature/TransactionFormPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/BudgetModel.dart';
import '../../models/GoalModel.dart';
import '../../models/TransactionModel.dart';
import '../../view/AnalaysisPage.dart';
import '../../view/Authientication_Feature/LoginPage.dart';
import '../../view/Authientication_Feature/SignPage.dart';
import '../../view/Authientication_Feature/SplashPage.dart';
import '../../view/Budget_Feature/BudgetFormPage.dart';
import '../../view/Budget_Feature/BudgetPage.dart';
import '../../view/Goal_Feature/AddGoalPage.dart';
import '../../view/Goal_Feature/GoalLIst.dart';
import '../../view/Goal_Feature/GoalPage.dart';
import '../../view/Goal_Feature/addGoalTransaction.dart';
import '../../view/HomePage.dart';
import '../../view/Transaction_Feature/addTransactionPage.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> _routeNavigatorState =
  GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
      navigatorKey: _routeNavigatorState,
      initialLocation: RoutesName.splash_route,
      routes: <RouteBase>[
        GoRoute(
          path: RoutesName.splash_route,
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen();
          },
        ),
        GoRoute(
          path: RoutesName.home_route,
          builder: (BuildContext context, GoRouterState state) {
            return HomePage();
          },
        ),
        GoRoute(
          path: RoutesName.login_route,
          builder: (BuildContext context, GoRouterState state) {
            return LoginPage();
          },
        ),
        GoRoute(
          path: RoutesName.signup_route,
          builder: (BuildContext context, GoRouterState state) {
            return SignupPage();
          },
        ),

        GoRoute(
          path: RoutesName.addtransaction,
          builder: (BuildContext context, GoRouterState state) {
            return AddTransactionPage();
          },
        ),
        GoRoute(
            name: RoutesName.formtransaction,
            path: RoutesName.formtransaction,
            builder: (BuildContext context, GoRouterState state) {
              final transaction = state.extra as TransactionModel;
              return AddTransactionFormPage(
                transactionModel: transaction,
              );
            }),
        GoRoute(
          path: RoutesName.goallist,
          builder: (BuildContext context, GoRouterState state) {
            return GoalsListPage();
          },
        ),
        GoRoute(
          name: RoutesName.goalmain,
          path: RoutesName.goalmain,
          builder: (BuildContext context, GoRouterState state) {
            final goal = state.extra as GoalModel;
            return GoalsPage(
              goalModel: goal,
            );
          },
        ),
        GoRoute(
          path: RoutesName.goalform,
          builder: (BuildContext context, GoRouterState state) {
            return AddGoalPage();
          },
        ),
        GoRoute(
          name: RoutesName.addtrangoalfrom,
          path: RoutesName.addtrangoalfrom,
          builder: (BuildContext context, GoRouterState state) {
            final goal = state.extra as GoalModel;
            return AddGoalTransactionPage(
              goal: goal,
            );
          },
        ),
        GoRoute(
          path: RoutesName.addBudgetform,
          builder: (BuildContext context, GoRouterState state) {
            return AddBudgetFormPage();
          },
        ),
        GoRoute(
          name: RoutesName.budgetmain,
          path: RoutesName.budgetmain,
          builder: (BuildContext context, GoRouterState state) {
            final budget = state.extra as BudgetModel;
            return BudgetPage(
              budgetModel: budget,
            );
          },
        ),
        GoRoute(
          path: RoutesName.analaysispage,
          builder: (BuildContext context, GoRouterState state) {
            return AnalysisPage();
          },
        ),
      ]);
}
