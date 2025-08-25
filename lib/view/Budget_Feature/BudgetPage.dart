import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/Status.dart';
import '../../models/BudgetModel.dart';
import '../../view_model/Budget_Vm.dart';
import '../../widget/popup.dart';

class BudgetPage extends StatefulWidget {
  final BudgetModel budgetModel;

  const BudgetPage({super.key, required this.budgetModel});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final budgetVM = Provider.of<BudgetViewModel>(context, listen: false);
      budgetVM.getTransaction(widget.budgetModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🔥 Central theme access
    final colorScheme = theme.colorScheme;

    double progress =
    (widget.budgetModel.spentAmount / widget.budgetModel.totalAmount)
        .clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.budgetModel.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              showConfirmationDialog(
                context,
                title: "Delete Budget",
                content: "Are you sure you want to delete this Budget?",
                onConfirm: () async {
                  final deleteGoal =
                  Provider.of<BudgetViewModel>(context, listen: false);

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                  await deleteGoal.removeBudget(widget.budgetModel);
                  Navigator.of(context).pop();

                  if (deleteGoal.budgetResponse.status == Status.completed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Goal deleted successfully")),
                    );
                    Navigator.of(context).pop();
                  } else if (deleteGoal.budgetResponse.status == Status.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              deleteGoal.budgetResponse.message ?? "Error")),
                    );
                  }
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: theme.dividerColor,
                            color: colorScheme.primary, // 🔥 theme color
                          ),
                        ),
                        Text(
                          "${(progress * 100).toStringAsFixed(1)}%",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Target & Spent Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: colorScheme.primary, width: 1),
                          ),
                          child: Column(
                            children: [
                              Text("Target",
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(
                                "${widget.budgetModel.totalAmount.toDouble()} PKR",
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border:
                            Border.all(color: colorScheme.error, width: 1),
                          ),
                          child: Column(
                            children: [
                              Text("Spent",
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(
                                "${widget.budgetModel.spentAmount.toDouble()} PKR",
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Transactions
          Text(
            "${widget.budgetModel.category} Expense ",
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Consumer<BudgetViewModel>(
            builder: (context, goalVM, child) {
              final transactions = goalVM.tranResponse;

              if (transactions.status == Status.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (transactions.status == Status.notStarted) {
                return const Center(child: Text("Please add Goal."));
              }
              if (transactions.status == Status.error) {
                return Center(
                    child: Text("Error ${transactions.message.toString()}"));
              }
              if (transactions.data == null || transactions.data!.isEmpty) {
                return const Center(child: Text("No transactions yet."));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.data!.length,
                itemBuilder: (context, index) {
                  final tx = transactions.data![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading:
                      Icon(Icons.attach_money, color: colorScheme.primary),
                      title: Text(
                        tx.date.toString(),
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: Text(
                        "- ${tx.amount} PKR",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
