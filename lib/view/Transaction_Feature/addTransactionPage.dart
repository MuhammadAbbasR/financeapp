import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/response/Status.dart';
import '../../dummy_data/CategoryDummyData.dart';
import '../../models/AccountModel.dart';
import '../../models/TransactionModel.dart';
import '../../service/AccountService.dart';
import '../../view_model/Transaction_VM.dart';


class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? selectedAccountId;
  String? selectedType;
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  List<AccountModel> accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    accounts = await AccountService().getAccounts();
    if (accounts.isNotEmpty) {
      setState(() {
        selectedAccountId = accounts.first.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final addtran = Provider.of<TransactionViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
        centerTitle: true,
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 1,
      ),
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: accounts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [

              Card(
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: selectedAccountId,
                    items: accounts
                        .map(
                          (acc) => DropdownMenuItem<String>(
                        value: acc.id,
                        child: Text(acc.name),
                      ),
                    )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => selectedAccountId = val),
                    decoration: const InputDecoration(
                        labelText: "Select Account",
                        border: InputBorder.none),
                    validator: (val) =>
                    val == null ? "Select an account" : null,
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
                    value: selectedType,
                    items: ["Income", "Expense"]
                        .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => selectedType = val),
                    decoration: const InputDecoration(
                        labelText: "Transaction Type",
                        border: InputBorder.none),
                    validator: (val) =>
                    val == null ? "Select type" : null,
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
                        labelText: "Category", border: InputBorder.none),
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
                        labelText: "Amount", border: InputBorder.none),
                    validator: (val) => val == null || val.isEmpty
                        ? "Enter amount"
                        : null,
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
                        border: InputBorder.none),
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
                  title: Text(
                      "Date: ${selectedDate.toLocal()}".split(' ')[0]),
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
                        accountId: selectedAccountId!,
                        type: selectedType!,
                        amount:
                        double.tryParse(amountController.text) ?? 0,
                        date: selectedDate,
                        category: selectedCategory!,
                        id: '',
                      );

                      await addtran.addTransaction(transaction);

                      if (addtran.getTranscationResponse.status ==
                          Status.completed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Transaction Added")),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Error adding transaction")),
                        );
                      }
                    }
                  },
                  child: addtran.getTranscationResponse.status ==
                      Status.loading
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text("Save Transaction",
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
