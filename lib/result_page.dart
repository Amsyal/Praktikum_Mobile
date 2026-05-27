import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double bmi;
  final int age;
  final String gender;

  const ResultPage({super.key, required this.bmi, required this.age, required this.gender});

  String get category {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  Color get categoryColor {
    if (bmi < 18.5) return Colors.blueAccent;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Analisis")),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(category.toUpperCase(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: categoryColor)),
              const SizedBox(height: 20),
              Text(bmi.toStringAsFixed(1), style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900)),
              const Divider(),
              const SizedBox(height: 10),
              _buildInfoRow("Gender", gender),
              _buildInfoRow("Usia", "$age tahun"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(color: Colors.grey)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }
}