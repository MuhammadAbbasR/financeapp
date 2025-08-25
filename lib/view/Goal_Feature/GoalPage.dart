import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../confi/NavigationServices.dart';
import '../../confi/routes/routesname.dart';
import '../../data/response/Status.dart';
import '../../models/GoalModel.dart';
import '../../view_model/Goal_VM.dart';
import '../../widget/popup.dart';

class GoalsPage extends StatefulWidget {
  final GoalModel goalModel;

  const GoalsPage({super.key, required this.goalModel});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final goalVM = Provider.of<GoalViewModel>(context, listen: false);
      goalVM.setSelectedGoal(widget.goalModel);
      goalVM.getTranGoal(widget.goalModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Goal Details"),
        actions: [
          IconButton(
            onPressed: () {
              NavigatorServices.Navigatetowithparamters(
                  RoutesName.addtrangoalfrom, widget.goalModel);
            },
            icon: const Icon(Icons.add, color: Colors.blueAccent),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              showConfirmationDialog(
                context,
                title: "Delete Goal",
                content: "Are you sure you want to delete this goal?",
                onConfirm: () async {
                  final deleteGoal =
                  Provider.of<GoalViewModel>(context, listen: false);

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  );

                  await deleteGoal.removeGoal(widget.goalModel);

                  Navigator.of(context).pop();

                  if (deleteGoal.goalResponse.status == Status.completed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Goal deleted successfully")),
                    );
                    Navigator.of(context).pop(); // back to list
                  } else if (deleteGoal.goalResponse.status == Status.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                          Text(deleteGoal.goalResponse.message ?? "Error")),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer<GoalViewModel>(
            builder: (context, goalVM, child) {
              final goal = goalVM.selectedGoal ?? widget.goalModel;
              double progress =
              (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular Progress
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 140,
                            width: 140,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey[300],
                              color: progress >= 1 ? Colors.green : Colors.blue,
                            ),
                          ),
                          Text(
                            "${(progress * 100).toStringAsFixed(1)}%",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Goal Name
                      Text(
                        goal.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Target & Saved Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoCard(
                              "Target", goal.targetAmount, colorScheme.primary),
                          SizedBox(
                            width: 10,
                          ),
                          _buildInfoCard(
                              "Saved", goal.currentAmount, Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Transactions List
          const Text(
            "Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Consumer<GoalViewModel>(
            builder: (context, goalVM, child) {
              final transactions = goalVM.trangoalResponse;

              if (transactions.status == Status.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (transactions.status == Status.notStarted ||
                  transactions.data == null ||
                  transactions.data!.isEmpty) {
                return const Center(child: Text("No transactions yet."));
              }

              if (transactions.status == Status.error) {
                return Center(
                    child: Text("Error: ${transactions.message ?? ""}"));
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
                      title: Text("${tx.date.toLocal()}"
                          .split(' ')[0]), // formatted date
                      subtitle: Text(
                        "- ${tx.amount.toStringAsFixed(0)} PKR",
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await goalVM.removeTranGoal(widget.goalModel, tx);
                        },
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

  Widget _buildInfoCard(String title, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: color, fontSize: 14)),
            const SizedBox(height: 6),
            Text(
              "${amount.toStringAsFixed(0)} PKR",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
