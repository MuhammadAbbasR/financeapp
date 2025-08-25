import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../data/response/Status.dart';
import '../../models/GoalModel.dart';
import '../../view_model/Goal_VM.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();

  void _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final targetAmount =
          double.tryParse(_targetAmountController.text.trim()) ?? 0.0;

      final response = Provider.of<GoalViewModel>(context, listen: false);
      await response.addGoal(GoalModel(name: name, targetAmount: targetAmount));

      if (response.goalResponse.status == Status.completed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Goal Saved!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Goal not saved!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Financial Goal"),
        centerTitle: true,
      ),
      body: Consumer<GoalViewModel>(
        builder: (context, goalVM, _) {
          if (goalVM.goalResponse.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Goal Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Goal Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.flag),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? "Enter a goal name"
                            : null,
                      ),
                      const SizedBox(height: 20),


                      TextFormField(
                        controller: _targetAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Target Amount",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter target amount";
                          }
                          if (double.tryParse(val) == null) {
                            return "Enter a valid number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),


                      ElevatedButton(
                        onPressed: _saveGoal,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Save Goal",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
