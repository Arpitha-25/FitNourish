import 'package:flutter/material.dart';

class BmiCalculatorScreen extends StatefulWidget {
  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen>
    with TickerProviderStateMixin {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _selectedGender;

  double? _bmi;
  String? _bmiInterpretation;
  bool _showResult = false;

  late AnimationController _animationController;
  late Animation<double> _resultOpacity;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _resultOpacity =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null ||
        height <= 0 ||
        weight == null ||
        weight <= 0 ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid details for all fields.')),
      );
      return;
    }

    final bmiValue = weight / ((height / 100) * (height / 100));
    setState(() {
      _bmi = bmiValue;
      _bmiInterpretation = _getInterpretation(bmiValue);
      _showResult = true;
    });

    _animationController.forward(from: 0);
  }

  String _getInterpretation(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getInterpretationColor(String? interp) {
    if (interp == 'Underweight') return Colors.blue;
    if (interp == 'Normal weight') return Colors.green;
    if (interp == 'Overweight') return Colors.orange;
    if (interp == 'Obese') return Colors.red;
    return Colors.black;
  }

  Widget _bmiChart() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "BMI Interpretation Chart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            "Based on World Health Organization (WHO) standards.",
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
            },
            children: [
              _tableRow("Underweight", "< 18.5", Colors.blue[50]),
              _tableRow("Normal weight", "18.5 – 24.9", Colors.green[50]),
              _tableRow("Overweight", "25 – 29.9", Colors.orange[50]),
              _tableRow("Obese", "≥ 30", Colors.red[50]),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _tableRow(String category, String range, Color? bgColor) {
    return TableRow(
      children: [
        Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
          child: Text(
            category,
            style: TextStyle(
              color: _getInterpretationColor(category),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
          child: Text(range,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  Widget _resultsCard() {
    if (!_showResult) return Container();

    String interp = _bmiInterpretation ?? '';
    Color interpColor = _getInterpretationColor(interp);

    return FadeTransition(
      opacity: _resultOpacity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('Your BMI is',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monitor_weight, size: 38, color: interpColor),
                    const SizedBox(width: 9),
                    Text(
                      _bmi!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: interpColor,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  interp,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: interpColor,
                  ),
                ),
              ],
            ),
          ),
          _bmiChart(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 19, bottom: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'BMI CALCULATOR',
                      style: const TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 400,
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 16,
                          offset: Offset(0, 7)),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Enter your details below to calculate your Body Mass Index.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 24),
                      const Text("Height (cm)", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "e.g., 175",
                          prefixIcon: const Icon(Icons.height_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text("Weight (kg)", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "e.g., 70",
                          prefixIcon: const Icon(Icons.fitness_center),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text("Gender", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7)),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.person),
                        ),
                        hint: const Text("Select your gender"),
                        value: _selectedGender,
                        onChanged: (val) => setState(() => _selectedGender = val),
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(value: 'Female', child: Text('Female')),
                          DropdownMenuItem(value: 'Other', child: Text('Other')),
                        ],
                      ),
                      const SizedBox(height: 19),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.shade200,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _calculateBMI();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.local_fire_department_rounded,
                                  color: Colors.white),
                              SizedBox(width: 9),
                              Text(
                                "Calculate BMI",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _resultsCard(),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(145, 47),
                        ),
                        icon: const Icon(Icons.home_rounded),
                        label: const Text("Go to Home"),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/'),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5964F1),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(165, 47),
                        ),
                        icon: const Icon(Icons.flag_rounded),
                        label: const Text("Set Your Goals"),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/physique'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
