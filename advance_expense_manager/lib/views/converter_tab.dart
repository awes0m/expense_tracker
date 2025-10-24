import 'dart:math' as math;

import 'package:flutter/material.dart';

class ConverterTab extends StatefulWidget {
  const ConverterTab({super.key});

  @override
  State<ConverterTab> createState() => _ConverterTabState();
}

class _ConverterTabState extends State<ConverterTab> {
  double currencyAmount = 100;
  String fromCurrency = 'INR';
  String toCurrency = 'USD';
  double loanAmount = 500000;
  double interestRate = 8.5;
  int loanTerm = 5;
  double investAmount = 100000;
  double monthlyContribution = 5000;
  double returnRate = 12;
  int investYears = 10;

  final Map<String, double> exchangeRates = {
    'INR': 1,
    'USD': 0.012,
    'EUR': 0.011,
    'GBP': 0.0095,
    'JPY': 1.78,
    'AUD': 0.018,
    'CAD': 0.016,
  };

  double convertCurrency() {
    final inINR = currencyAmount / exchangeRates[fromCurrency]!;
    return inINR * exchangeRates[toCurrency]!;
  }

  double calculateEMI() {
    final rate = interestRate / 100 / 12;
    final term = loanTerm * 12;
    if (rate == 0) return loanAmount / term;
    return (loanAmount * rate * math.pow(1 + rate, term)) /
        (math.pow(1 + rate, term) - 1);
  }

  double calculateInvestment() {
    final rate = returnRate / 100 / 12;
    final months = investYears * 12;
    return investAmount * math.pow(1 + rate, months) +
        monthlyContribution * ((math.pow(1 + rate, months) - 1) / rate);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildConverterCard(
          title: '💱 Currency Converter',
          icon: Icons.currency_exchange,
          color: Colors.blue,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(
                  () => currencyAmount = double.tryParse(value) ?? 100,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: fromCurrency,
                      decoration: const InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                      ),
                      items: exchangeRates.keys
                          .map(
                            (currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => fromCurrency = v!),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: toCurrency,
                      decoration: const InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                      items: exchangeRates.keys
                          .map(
                            (currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => toCurrency = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildResultBox(
                'Converted Amount',
                '$toCurrency ${convertCurrency().toStringAsFixed(2)}',
                Colors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildConverterCard(
          title: '🧮 Loan Calculator',
          icon: Icons.calculate,
          color: Colors.orange,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Loan Amount (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: loanAmount.toString()),
                onChanged: (value) => setState(
                  () => loanAmount = double.tryParse(value) ?? 500000,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Interest Rate (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: interestRate.toString(),
                ),
                onChanged: (value) => setState(
                  () => interestRate = double.tryParse(value) ?? 8.5,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Loan Term (Years)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: loanTerm.toString()),
                onChanged: (value) =>
                    setState(() => loanTerm = int.tryParse(value) ?? 5),
              ),
              const SizedBox(height: 16),
              _buildResultBox(
                'Monthly EMI',
                '₹${calculateEMI().toStringAsFixed(2)}',
                Colors.blue,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Payment:'),
                        Text(
                          '₹${(calculateEMI() * loanTerm * 12).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Interest:'),
                        Text(
                          '₹${((calculateEMI() * loanTerm * 12) - loanAmount).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildConverterCard(
          title: '💰 Investment Calculator',
          icon: Icons.trending_up,
          color: Colors.green,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Initial Investment (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: investAmount.toString(),
                ),
                onChanged: (value) => setState(
                  () => investAmount = double.tryParse(value) ?? 100000,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Monthly Contribution (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: monthlyContribution.toString(),
                ),
                onChanged: (value) => setState(
                  () => monthlyContribution = double.tryParse(value) ?? 5000,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Expected Return (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: returnRate.toString()),
                onChanged: (value) =>
                    setState(() => returnRate = double.tryParse(value) ?? 12),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Time Period (Years)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: investYears.toString()),
                onChanged: (value) =>
                    setState(() => investYears = int.tryParse(value) ?? 10),
              ),
              const SizedBox(height: 16),
              _buildResultBox(
                'Future Value',
                '₹${calculateInvestment().toStringAsFixed(2)}',
                Colors.purple,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Invested:'),
                        Text(
                          '₹${(investAmount + (monthlyContribution * investYears * 12)).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Returns:'),
                        Text(
                          '₹${(calculateInvestment() - investAmount - (monthlyContribution * investYears * 12)).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConverterCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildResultBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
