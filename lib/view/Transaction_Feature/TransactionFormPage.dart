import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/response/Status.dart';
import '../../dummy_data/CategoryDummyData.dart';
import '../../models/TransactionModel.dart';
import '../../view_model/Transaction_VM.dart';
import '../../widget/popup.dart';


class AddTransactionFormPage extends StatefulWidget {
  final TransactionModel transactionModel;
  AddTransactionFormPage({super.key, required this.transactionModel});

  @override
  State<AddTransactionFormPage> createState() => _AddTransactionFormPageState();
}

class _AddTransactionFormPageState extends State<AddTransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController amountController =
  TextEditingController(text: widget.transactionModel.amount.toString());
  late final TextEditingController notesController =
  TextEditingController(text: widget.transactionModel.note ?? '');

  late String? selectedType = widget.transactionModel.type;
  late String? selectedCategory = widget.transactionModel.category;
  late DateTime selectedDate = widget.transactionModel.date;

  @override
  Widget build(BuildContext context) {
    final addtran = Provider.of<TransactionViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Transaction"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              showConfirmationDialog(
                context,
                title: "Delete Transaction",
                content: "Are you sure you want to delete this transaction?",
                onConfirm: () async {
                  await addtran.deleteTransaction(widget.transactionModel);
                  if (addtran.getTranscationResponse.status ==
                      Status.completed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Transaction deleted")),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          addtran.getTranscationResponse.message ?? "Error",
                        ),
                      ),
                    );
                  }
                },
              );
            },
          )
        ],
      ),
      backgroundColor: colorScheme.background,
      body: Consumer<TransactionViewModel>(
        builder: (context, addtran, child) {
          if (addtran.getTranscationResponse.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Account display
                  Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.account_balance),
                      title: Center(
                          child: Text(widget.transactionModel.accountId)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Transaction Type
                  Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<String>(
                        value: selectedType,
                        items: ["Income", "Expense"]
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => selectedType = val),
                        decoration: const InputDecoration(
                          labelText: "Transaction Type",
                          border: InputBorder.none,
                        ),
                        validator: (val) => val == null ? "Select type" : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),


                  Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items: categories
                            .where((c) => c.categorytype == selectedType)
                            .map((c) => DropdownMenuItem(
                          value: c.categoryname,
                          child: Text(c.categoryname),
                        ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => selectedCategory = val),
                        decoration: const InputDecoration(
                          labelText: "Category",
                          border: InputBorder.none,
                        ),
                        validator: (val) =>
                        val == null ? "Select category" : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),


                  Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Amount",
                          border: InputBorder.none,
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Enter amount" : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),


                  Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: "Notes (optional)",
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),


                  Card(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      title:
                      Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null)
                          setState(() => selectedDate = picked);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),


                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final transaction = TransactionModel(
                            accountId: widget.transactionModel.accountId,
                            type: selectedType!,
                            amount: double.tryParse(amountController.text) ?? 0,
                            date: selectedDate,
                            category: selectedCategory!,
                            id: widget.transactionModel.id,
                          );

                          await addtran.addTransaction(transaction);

                          if (addtran.getTranscationResponse.status ==
                              Status.completed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Transaction Updated")),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Error updating transaction")),
                            );
                          }
                        }
                      },
                      child: addtran.getTranscationResponse.status ==
                          Status.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Save Transaction",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
