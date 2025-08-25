import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../confi/NavigationServices.dart';
import '../../confi/routes/routesname.dart';
import '../../data/response/Status.dart';
import '../../models/BudgetModel.dart';
import '../../view_model/Budget_Vm.dart';

class BudgetsListPage extends StatefulWidget {
  const BudgetsListPage({super.key});

  @override
  State<BudgetsListPage> createState() => _BudgetsListPageState();
}

class _BudgetsListPageState extends State<BudgetsListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BudgetViewModel>(context, listen: false).getBudget();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Budgets"),
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 1,
      ),
      body: Consumer<BudgetViewModel>(
        builder: (context, vm, _) {
          final response = vm.budgetResponse;

          switch (response.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.error:
              return Center(
                child: Text(
                  "Error: ${response.message}",
                  style: theme.textTheme.bodyMedium,
                ),
              );
            case Status.completed:
              final budgets = response.data ?? [];

              if (budgets.isEmpty) {
                return Center(
                  child: Text(
                    "No budgets added yet.",
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final BudgetModel budget = budgets[index];
                  final spent = budget.spentAmount ?? 0.0;
                  final limit = budget.totalAmount ?? 1.0;
                  final progress = (spent / limit).clamp(0.0, 1.0);

                  return GestureDetector(
                    onTap: () {
                      NavigatorServices.Navigatetowithparamters(
                          RoutesName.budgetmain, budget);
                    },
                    child: Card(
                      color: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    budget.category,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Spent: ${spent.toStringAsFixed(2)} / ${limit.toStringAsFixed(2)}",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 6,
                                    backgroundColor:
                                    colorScheme.onSurface.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      progress >= 1.0
                                          ? colorScheme.error
                                          : colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    "${(progress * 100).toStringAsFixed(0)}%",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

            default:
              return Center(
                child: Text(
                  "Press + to add a budget.",
                  style: theme.textTheme.bodyMedium,
                ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "BudgetList",
        backgroundColor: colorScheme.primary,
        onPressed: () {
          NavigatorServices.NavigationTo(RoutesName.addBudgetform);
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: colorScheme.background,
    );
  }
}
