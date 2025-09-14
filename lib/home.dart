import 'dart:math';
import 'package:flutter/material.dart';

class FitNourishHomePage extends StatefulWidget {
  @override
  State<FitNourishHomePage> createState() => _FitNourishHomePageState();
}

class _FitNourishHomePageState extends State<FitNourishHomePage>
    with SingleTickerProviderStateMixin {
  final List<String> quotes = [
    "Take care of your body. It’s the only place you have to live.",
    "Fitness is not about being better than someone else. It’s about being better than you used to be.",
    "Good nutrition creates health in all areas of our existence.",
    "When diet is wrong, medicine is of no use. When diet is correct, medicine is of no need.",
  ];

  final List<IconData> icons = [
    Icons.calculate,
    Icons.restaurant,
    Icons.fitness_center,
  ];
  final List<String> titles = [
    "Calculate your BMI",
    "Your Diet",
    "Your Workout Routine",
  ];

  late String selectedQuote;
  bool fadeOther = false;
  int? selectedBox;
  double tappedScale = 1.0;
  late AnimationController heartController;

  @override
  void initState() {
    super.initState();
    selectedQuote = quotes[Random().nextInt(quotes.length)];
    heartController = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    heartController.dispose();
    super.dispose();
  }

  void onBoxTap(int idx) async {
    setState(() {
      selectedBox = idx;
      fadeOther = true;
      tappedScale = 1.06;
    });

    await Future.delayed(const Duration(milliseconds: 180));
    setState(() => tappedScale = 1.0);
    await Future.delayed(const Duration(milliseconds: 180));

    if (idx == 0) {
      Navigator.pushNamed(context, '/bmi');
    } else if (idx == 1) {
      Navigator.pushNamed(context, '/diet');
    } else {
      Navigator.pushNamed(context, '/workout');
    }

    setState(() {
      fadeOther = false;
      selectedBox = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade200,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[400],
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent.shade200),
              child: const Text(
                "Menu",
                style: TextStyle(fontSize: 26, color: Colors.black87),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black87),
              title: const Text("User Profile"),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.black87),
              title: const Text("Your Routine and Goals"),
              onTap: () => Navigator.pushNamed(context, '/routine'),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.black87),
              title: const Text("Help/Guide"),
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/app_logo.png',
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'FitNourish',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent.shade200,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            const Text(
              "Fuel Your Fitness. Nourish Your Life",
              style: TextStyle(fontSize: 15, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: AnimatedBuilder(
                animation: heartController,
                builder: (context, child) {
                  double scale = 1 + 0.18 * heartController.value;
                  return Transform.scale(
                    scale: scale,
                    child: Icon(Icons.favorite,
                        color: Colors.redAccent.shade200, size: 36),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                selectedQuote,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 35),
            Column(
              children: List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: AnimatedOpacity(
                    opacity: (fadeOther && selectedBox != i) ? 0.15 : 1,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: () => onBoxTap(i),
                      child: AnimatedScale(
                        scale: selectedBox == i ? tappedScale : 1.0,
                        duration: const Duration(milliseconds: 170),
                        curve: Curves.easeOut,
                        child: Material(
                          elevation: 7,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.redAccent.shade200,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.shade200
                                      .withOpacity(0.16),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icons[i],
                                    size: 38,
                                    color: Colors.redAccent.shade200),
                                const SizedBox(width: 12),
                                Text(
                                  titles[i],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

