import 'package:flutter/material.dart';

import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../data/response/Status.dart';
import '../view_model/analaysis_Vm.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<AnalysisViewModel>(context, listen: false);
    vm.getCategoryAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    print("whole rebuild");

    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 20.0;
    final buttonWidth = (screenWidth - horizontalPadding * 2) / 2;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text("Detailed Analysis",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer<AnalysisViewModel>(
            builder: (context, vm, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ToggleButtons(
                      constraints: BoxConstraints(
                        minWidth: buttonWidth,
                        minHeight: 44,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      selectedColor: Colors.white,
                      fillColor: const Color(0xFF007BFF),
                      color: Colors.white70,
                      isSelected: [
                        vm.getselectedtype == "Expense",
                        vm.getselectedtype == "Income",
                      ],
                      onPressed: (index) async {
                        vm.setSelected(index == 0 ? "Expense" : "Income");
                        await vm.getCategoryAnalysis();
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text("Expense"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text("Income"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    vm.getselectedtype,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),

                  const SizedBox(height: 10),
                ],
              );
            },
          ),

          const SizedBox(height: 10),
          Consumer<AnalysisViewModel>(
            builder: (context, vm, child) {
              if (vm.getchartresponse.status == Status.error) {
                return Center(
                    child: Text("Error: ${vm.getchartresponse.message}",
                        style: const TextStyle(color: Colors.redAccent)));
              } else if (vm.getchartresponse.status == Status.completed) {
                final chartData = vm.getchartresponse.data;

                if (chartData == null || chartData.isEmpty) {
                  return const Center(
                      child: Text("No data available for chart.",
                          style: TextStyle(color: Colors.white70)));
                }

                return SizedBox(
                  height: 250,
                  child: PieChart(
                    dataMap: chartData,
                    chartType: ChartType.disc,
                    chartRadius: MediaQuery.of(context).size.width / 2.5,
                    legendOptions: const LegendOptions(
                      showLegends: true,
                      legendTextStyle: TextStyle(color: Colors.white),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                      chartValueStyle:
                      TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
            },
          ),
          const SizedBox(height: 20),

          // Transaction List
          Consumer<AnalysisViewModel>(builder: (context, tranVM, child) {
            final transactions = tranVM.getAnalysisResponse;

            if (transactions.status == Status.notStarted) {
              return const Center(
                  child: Text("Please add Goal.",
                      style: TextStyle(color: Colors.white70)));
            }
            if (transactions.status == Status.error) {
              return Center(
                  child: Text("Error ${transactions.message.toString()}",
                      style: const TextStyle(color: Colors.redAccent)));
            }

            if (transactions.data == null || transactions.data!.isEmpty) {
              return const Center(
                  child: Text("No transactions yet.",
                      style: TextStyle(color: Colors.white70)));
            }

            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.data!.length,
                itemBuilder: (context, index) {
                  final tx = transactions.data![index];
                  return Card(
                    color: const Color(0xFF1C1C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.attach_money,
                          color: Colors.blueAccent),
                      title: Text(tx.category,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(tx.date.toString(),
                          style: const TextStyle(color: Colors.white70)),
                      trailing:tx.type == "Expense"
                          ? Text(
                        "- ${tx.amount} PKR",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 14,
                        ),
                      )
                          : Text(
                        "+ ${tx.amount} PKR",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                });
          }),
        ],
      ),
    );
  }
}
