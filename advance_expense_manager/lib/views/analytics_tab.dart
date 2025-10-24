import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../controller/data_service.dart';

// ==================== ANALYTICS TAB ====================
class AnalyticsTab extends StatelessWidget {
  final DataService dataService;

  const AnalyticsTab({super.key, required this.dataService});

  @override
  Widget build(BuildContext context) {
    final transactions = dataService.getTransactions();
    final categoryData = <String, double>{};
    double totalExpense = 0;

    for (var t in transactions) {
      if (t.type == 'expense') {
        categoryData[t.category] = (categoryData[t.category] ?? 0) + t.amount;
        totalExpense += t.amount;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pie_chart, color: Colors.blue),
                      SizedBox(width: 12),
                      Text(
                        'Expense by Category',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (categoryData.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No expense data available'),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: categoryData.entries.map((e) {
                            final colors = [
                              Colors.blue,
                              Colors.green,
                              Colors.orange,
                              Colors.red,
                              Colors.purple,
                              Colors.teal,
                              Colors.pink,
                              Colors.indigo,
                            ];
                            final index = categoryData.keys.toList().indexOf(e.key);
                            final percentage = (e.value / totalExpense * 100);
                            return PieChartSectionData(
                              value: e.value,
                              title: '${percentage.toStringAsFixed(1)}%',
                              color: colors[index % colors.length],
                              radius: 100,
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.list, color: Colors.blue),
                      SizedBox(width: 12),
                      Text(
                        'Category Breakdown',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (categoryData.isEmpty)
                    const Center(child: Text('No data'))
                  else
                    ...categoryData.entries.map((e) {
                      final percentage = (e.value / totalExpense * 100);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.key,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '₹${e.value.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.grey[300],
                              minHeight: 8,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${percentage.toStringAsFixed(1)}% of total expenses',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}