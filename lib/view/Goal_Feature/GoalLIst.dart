import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../confi/NavigationServices.dart';
import '../../confi/routes/routesname.dart';
import '../../data/response/Status.dart';
import '../../view_model/Goal_VM.dart';

class GoalsListPage extends StatefulWidget {
  const GoalsListPage({super.key});

  @override
  State<GoalsListPage> createState() => _GoalsListPageState();
}

class _GoalsListPageState extends State<GoalsListPage> {
  void initState() {
    super.initState();

    Future.microtask(() {
      final goalVM = Provider.of<GoalViewModel>(context, listen: false);
      goalVM.getGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Financial Goals"),
      ),
      body: Consumer<GoalViewModel>(
        builder: (context, goalVM, child) {
          if (goalVM.goalResponse.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (goalVM.goalResponse.status == Status.notStarted) {
            return const Center(child: Text("Please add Goal."));
          }
          if (goalVM.goalResponse.status == Status.error) {
            return Center(
                child: Text("Error ${goalVM.goalResponse.message.toString()}"));
          }

          if (goalVM.goalResponse.data!.isEmpty) {
            return const Center(child: Text("No goals added yet."));
          }

          return ListView.builder(
            itemCount: goalVM.goalResponse.data!.length,
            itemBuilder: (context, index) {
              final goal = goalVM.goalResponse.data![index];
              final progress = goal.currentAmount / goal.targetAmount;

              return GestureDetector(
                onTap: () {
                  NavigatorServices.Navigatetowithparamters(
                      RoutesName.goalmain, goal);
                },
                child: Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Goal Name + Target
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              goal.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₨${goal.targetAmount.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Progress Bar
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: progress >= 1 ? Colors.green : Colors.blue,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 8),

                        // Current Amount + Deadline
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Saved: ₨${goal.currentAmount.toStringAsFixed(0)}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigatorServices.NavigationTo(RoutesName.goalform);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
