import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../confi/NavigationServices.dart';
import '../../confi/routes/routesname.dart';
import '../../data/response/Status.dart';
import '../../view_model/Transaction_VM.dart';


class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionViewModel>(context, listen: false)
          .getTransaction();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        centerTitle: true,
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 1,
      ),
      backgroundColor: colorScheme.background,
      body: Consumer<TransactionViewModel>(
        builder: (context, transactionVM, child) {
          final response = transactionVM.getTranscationResponse;

          switch (response.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());

            case Status.error:
              return Center(
                  child:
                  Text(response.message ?? "Error loading transactions"));

            case Status.notStarted:
              return const Center(child: Text("No transactions loaded yet"));

            case Status.completed:
              if (response.data!.isEmpty) {
                return const Center(child: Text('No transactions found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: response.data!.length,
                itemBuilder: (context, index) {
                  final transaction = response.data![index];
                  final isExpense = transaction.type.toLowerCase() == "expense";
                  final amountColor = isExpense ? Colors.red : Colors.green;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    color: colorScheme.surface,
                    child: ListTile(
                      leading: Icon(
                        transaction.type == "Expense"
                            ? Icons.trending_down
                            : Icons.trending_up,
                        color: transaction.type == "Expense"
                            ? Colors.red
                            : Colors.green,
                      ),
                      title: Text(
                        transaction.category,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        transaction.type,
                        style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                      trailing: Text(
                        "${isExpense ? '-' : '+'} \$${transaction.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: amountColor,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        NavigatorServices.Navigatetowithparamters(
                          RoutesName.formtransaction,
                          transaction,
                        );
                      },
                    ),
                  );
                },
              );

            default:
              return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "transactions_fab",
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        onPressed: () {
          NavigatorServices.NavigationTo(RoutesName.addtransaction);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
