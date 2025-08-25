import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import 'Budget_Feature/BudgetListPage.dart';
import 'Dashboard.dart';
import 'Goal_Feature/GoalLIst.dart';
import 'Transaction_Feature/TransactionPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    DashboardPage(),

    BudgetsListPage(),
    TransactionsPage(),
    GoalsListPage()

  ];

  void setScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: const Color(0xFF121212),

        barItems: [
          BarItem(title: "Home", icon: Icons.home),
          BarItem(title: "budget", icon: Icons.account_balance),
          BarItem(title: "Transactions", icon: Icons.receipt_long),

          BarItem(title: "Goals", icon: Icons.flag),

        ],
        selectedIndex: _selectedIndex,
        onButtonPressed: setScreen,
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        iconSize: 30,
      ),
    );
  }
}
