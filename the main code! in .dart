import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tax Calculator and Planner',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _deductionsController = TextEditingController();

  String _result = '';
  String _breakdown = '';
  bool _showSavings = false;
  bool _showTips = false;
  bool _showPlanning = false;

  void _calculateTax() {
    setState(() {
      final income = double.tryParse(_incomeController.text) ?? 0.0;
      final deductions = double.tryParse(_deductionsController.text) ?? 0.0;
      final taxableIncome = income - deductions;

      double tax = 0;
      List<Map<String, dynamic>> slabs = [
        {'limit': 250000.0, 'rate': 0.05},
        {'limit': 500000.0, 'rate': 0.1},
        {'limit': 1000000.0, 'rate': 0.2},
      ];

      List<String> slabBreakdown = [];

      for (int i = 0; i < slabs.length; i++) {
        if (taxableIncome > slabs[i]['limit']) {
          tax += (taxableIncome - slabs[i]['limit']) * slabs[i]['rate'];
          slabBreakdown.add('Slab ${i + 1}: ₹${taxableIncome - slabs[i]['limit']} at ${slabs[i]['rate'] * 100}%');
        }
      }

      if (taxableIncome > (slabs.isNotEmpty ? slabs.last['limit'] as double : 0.0)) {
        tax += (taxableIncome - slabs.last['limit'] as double) * 0.30 + 112500;
        slabBreakdown.add('Above ₹1,000,000: ₹${taxableIncome - slabs.last['limit'] as double} at 30%');
      }

      double cess = tax * 0.04; // Health and Education Cess
      double totalTax = tax + cess;

      _result = 'Total Tax: ₹${totalTax.toStringAsFixed(2)} (including ₹${cess.toStringAsFixed(2)} cess)';
      _breakdown = slabBreakdown.join('\n');
    });
  }

  void _resetFields() {
    setState(() {
      _incomeController.clear();
      _deductionsController.clear();
      _result = 'Tax will be displayed here';
      _breakdown = '';
      _showSavings = false;
      _showTips = false;
      _showPlanning = false;
    });
  }

  void _toggleSavings() {
    setState(() {
      _showSavings = !_showSavings;
    });
  }

  void _toggleTips() {
    setState(() {
      _showTips = !_showTips;
    });
  }

  void _togglePlanning() {
    setState(() {
      _showPlanning = !_showPlanning;
    });
  }

  void _showContactInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact the Income Tax Dept.'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('e-Filing and Centralized Processing Center'),
              SizedBox(height: 10),
              Text('e-Filing of Income Tax Return or Forms and other value added services & Intimation, Rectification, Refund and other Income Tax Processing Related Queries.'),
              SizedBox(height: 10),
              Text('08:00 AM - 20:00 PM (Monday to Friday)'),
              SizedBox(height: 10),
              Text('1800 103 0025'),
              Text('1800 419 0025'),
              Text('+91-80-46122000'),
              Text('+91-80-61464700'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tax Calculator and Planner'),
        backgroundColor: Colors.green, // Ensure the AppBar is green
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter income in rupees',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _deductionsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter deductions in rupees',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculateTax,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set the background color
              ),
              child: Text('Calculate Tax'),
            ),
            SizedBox(height: 10),
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_breakdown, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _toggleSavings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Suggest Tax Savings'),
            ),
            if (_showSavings)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Invest up to ₹1.5 lakh in 80C options like PPF, NSC, ELSS, etc.\n"
                      "Consider taking a health insurance policy under Section 80D.\n"
                      "Donate to approved charities under Section 80G for additional deductions.\n"
                      "Claim interest on home loan under Section 24(b) up to ₹2 lakh.\n"
                      "Make use of Section 10(14) exemptions for house rent allowance (HRA).",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _toggleTips,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Tax Planning Tips'),
            ),
            if (_showTips)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Keep track of all your receipts and documents for deductions.\n"
                      "Invest early in the financial year to maximize tax-saving benefits.\n"
                      "Consult a tax advisor to optimize your tax planning and investment strategy.\n"
                      "Review your tax planning annually to adjust for any changes in income or tax laws.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _togglePlanning,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('How to Do Tax Planning'),
            ),
            if (_showPlanning)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "1. Understand Tax Slabs: Familiarize yourself with the current tax slabs to optimize your tax planning.\n"
                      "2. Maximize Deductions: Utilize tax-saving investments and deductions under sections like 80C, 80D, and 24(b).\n"
                      "3. Keep Records: Maintain accurate records of your income, investments, and expenses to ensure all deductions are claimed.\n"
                      "4. Plan Investments: Invest in eligible schemes early in the financial year to take full advantage of tax benefits.\n"
                      "5. Consult Professionals: Seek advice from tax professionals to ensure compliance and optimal tax savings.\n"
                      "6. Review Annually: Reassess your tax plan annually to adapt to any changes in income, tax laws, or financial goals.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showContactInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Have doubts? Contact the income tax dept!'),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Made by:\n'
                    'Rukmani Shahi\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
