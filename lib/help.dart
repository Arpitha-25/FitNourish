import 'package:flutter/material.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({Key? key}) : super(key: key);

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  int? _activeIndex;

  final List<Map<String, String>> _faqData = [
    {
      'question': 'What is BMI and why is it important?',
      'answer':
          'BMI (Body Mass Index) is a calculation using height and weight to estimate body fat. '
              'It indicates whether you are underweight, normal weight, overweight, or obese and helps identify potential health risks.'
    },
    {
      'question': 'How accurate is the BMI calculator in this app?',
      'answer':
          'It is a general estimate based on standard formulas. It is a helpful screening tool but does not measure body fat directly. Combine with other assessments or professional advice.'
    },
    {
      'question': 'Can I use the app if I’m under 18 or pregnant?',
      'answer':
          'The app is designed for adults. BMI may not be accurate for those under 18 or pregnant women due to different body development. Consult a healthcare professional for guidance.'
    },
    {
      'question': 'What should I do if my BMI is in the obese or underweight range?',
      'answer':
          'Consult healthcare providers for a complete evaluation. The app is a guide and cannot replace professional advice.'
    },
    {
      'question': 'How often should I calculate my BMI?',
      'answer':
          'Calculate periodically (monthly or quarterly) to track progress without being misled by daily fluctuations.'
    },
    {
      'question': 'Can I change my target physique later?',
      'answer':
          'Yes, update your target physique anytime in the app’s settings or physique screen to match your current goals.'
    },
    {
      'question': 'Is my personal data safe in this app?',
      'answer':
          'Your data is stored locally and not shared without consent. Keep your device secure and review app permissions.'
    },
    {
      'question': 'Why is there a difference between my BMI and my actual body composition?',
      'answer':
          'BMI does not account for muscle mass or fat distribution. Muscular individuals might have high BMI but low body fat.'
    },
    {
      'question': 'Can I sync my data with other fitness apps or devices?',
      'answer':
          'Currently, no syncing is available. This may be added in future updates for better integration.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade200,
        elevation: 2,
        title: const Text(
          'Help & FAQ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: ExpansionPanelList(
              elevation: 0,
              animationDuration: const Duration(milliseconds: 300),
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _activeIndex = _activeIndex == index ? null : index;
                });
              },
              children: List.generate(_faqData.length, (index) {
                final isOpen = _activeIndex == index;
                return ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: Colors.white,
                  isExpanded: isOpen,
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 18),
                      child: Text(
                        _faqData[index]['question']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: isOpen
                              ? Colors.redAccent.shade200
                              : Colors.black87,
                        ),
                      ),
                    );
                  },
                  body: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(18, 0, 18, 16),
                    child: Text(
                      _faqData[index]['answer']!,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 30),

          /// Contact Info Section
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent.shade100.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'For any further queries, contact: helpcenterXX@gmoil.com',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

