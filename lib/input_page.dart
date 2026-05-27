import 'package:flutter/material.dart';
import 'result_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  double _height = 170;
  double _weight = 60;
  int _age = 25;
  String _gender = 'Laki-laki';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Calculator"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildGenderCard('Laki-laki', Icons.male),
                const SizedBox(width: 15),
                _buildGenderCard('Perempuan', Icons.female),
              ],
            ),
            const SizedBox(height: 25),
            _buildSliderCard("Tinggi (cm)", _height, 100, 220, (v) => setState(() => _height = v)),
            _buildSliderCard("Berat (kg)", _weight, 30, 150, (v) => setState(() => _weight = v)),
            _buildAgeCard(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                double bmi = _weight / ((_height / 100) * (_height / 100));
                Navigator.push(context, MaterialPageRoute(builder: (_) => ResultPage(bmi: bmi, age: _age, gender: _gender)));
              },
              child: const Text("HITUNG SEKARANG", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard(String gender, IconData icon) {
    bool isSelected = _gender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          child: Column(children: [
            Icon(icon, size: 40, color: isSelected ? Colors.white : Theme.of(context).primaryColor),
            Text(gender, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
          ]),
        ),
      ),
    );
  }

  Widget _buildSliderCard(String label, double val, double min, double max, Function(double) onChanged) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text("${val.toInt()}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF))),
            Slider(value: val, min: min, max: max, onChanged: onChanged, activeColor: const Color(0xFF6C63FF)),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Usia", style: TextStyle(fontSize: 16)),
            Row(children: [
              IconButton(onPressed: () => setState(() => _age--), icon: const Icon(Icons.remove_circle_outline)),
              Text("$_age", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => setState(() => _age++), icon: const Icon(Icons.add_circle_outline)),
            ])
          ],
        ),
      ),
    );
  }
}