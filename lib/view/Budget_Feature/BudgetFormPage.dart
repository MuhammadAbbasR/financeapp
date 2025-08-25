import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/Status.dart';
import '../../dummy_data/CategoryDummyData.dart';
import '../../models/BudgetModel.dart';
import '../../view_model/Budget_Vm.dart';

class AddBudgetFormPage extends StatefulWidget {
  const AddBudgetFormPage({super.key});

  @override
  State<AddBudgetFormPage> createState() => _AddBudgetFormPageState();
}

class _AddBudgetFormPageState extends State<AddBudgetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? selectedCategory;
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final addBudget = Provider.of<BudgetViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Budget"),
        centerTitle: true,
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 1,
      ),
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Budget Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 20),

              // Budget Name
              _buildInputField(
                controller: nameController,
                label: "Budget Name",
                colorScheme: colorScheme,
                validatorMsg: "Enter budget name",
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              _buildDropdown(
                selectedValue: selectedCategory,
                items: categories
                    .where((e) => e.categorytype == "Expense")
                    .map((cat) => cat.categoryname)
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                label: "Category",
                colorScheme: colorScheme,
                validatorMsg: "Select category",
              ),
              const SizedBox(height: 16),

              // Amount
              _buildInputField(
                controller: amountController,
                label: "Amount",
                colorScheme: colorScheme,
                keyboardType: TextInputType.number,
                validatorMsg: "Enter amount",
              ),
              const SizedBox(height: 16),





              _buildInputField(
                controller: notesController,
                label: "Notes (Optional)",
                colorScheme: colorScheme,
                maxLines: 3,
              ),
              const SizedBox(height: 32),


              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {

                      await addBudget.addBudget(
                        BudgetModel(
                          title: nameController.text,
                          category: selectedCategory!,
                          totalAmount: double.parse(amountController.text),

                        ),
                      );
                      if (addBudget.budgetResponse.status == Status.completed) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: addBudget.budgetResponse.status == Status.loading
                      ? CircularProgressIndicator(
                    color: colorScheme.onPrimary,
                  )
                      : Text(
                    "Save Budget",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        child: Text(
          date != null ? "${date.toLocal()}".split(' ')[0] : "Select $label",
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
    );
  }


  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required ColorScheme colorScheme,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? validatorMsg,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validatorMsg != null
          ? (val) => val == null || val.isEmpty ? validatorMsg : null
          : null,
    );
  }


  Widget _buildDropdown({
    required String? selectedValue,
    required List<String> items,
    required void Function(String?) onChanged,
    required String label,
    required ColorScheme colorScheme,
    String? validatorMsg,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: items
          .map((val) => DropdownMenuItem(value: val, child: Text(val)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: colorScheme.onSurface),
      validator: validatorMsg != null
          ? (val) => val == null ? validatorMsg : null
          : null,
    );
  }
}
