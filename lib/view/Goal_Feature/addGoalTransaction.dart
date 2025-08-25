import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/Status.dart';
import '../../models/GoalModel.dart';
import '../../models/TransactionGoalModel.dart';
import '../../view_model/Goal_VM.dart';


class AddGoalTransactionPage extends StatefulWidget {
  final GoalModel goal;

  const AddGoalTransactionPage({super.key, required this.goal});

  @override
  State<AddGoalTransactionPage> createState() => _AddGoalTransactionPageState();
}

class _AddGoalTransactionPageState extends State<AddGoalTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Goal Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 24),


              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: "Note (optional)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),


              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final transaction = TransactionGoalModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        amount: double.tryParse(_amountController.text) ?? 0.0,
                        type: "Savings",
                        note: _noteController.text,
                        date: DateTime.now(),
                      );

                      final goalVM =
                      Provider.of<GoalViewModel>(context, listen: false);

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Container(
                          color: Colors.black54,
                          child: const Center(
                            child:
                            CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      );

                      await goalVM.addTranGoal(widget.goal, transaction);
                      Navigator.of(context).pop();

                      if (goalVM.trangoalResponse.status == Status.completed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Transaction Saved!")),
                        );
                        Navigator.pop(context);
                      } else if (goalVM.trangoalResponse.status ==
                          Status.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Transaction error! ${goalVM.trangoalResponse.message ?? ''}",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  label: const Text(
                    "Save Transaction",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
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
