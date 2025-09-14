import 'package:flutter/material.dart';

class SummaryGoalsPage extends StatefulWidget {
  final String fitGoal;
  final int totalPoints;

  const SummaryGoalsPage({
    Key? key,
    required this.fitGoal,
    required this.totalPoints,
  }) : super(key: key);

  @override
  State<SummaryGoalsPage> createState() => _SummaryGoalsPageState();
}

class _SummaryGoalsPageState extends State<SummaryGoalsPage> {
  late Map<String, dynamic> dailyPattern;
  late List<Map<String, dynamic>> dailyAchievements;
  late List<Map<String, dynamic>> monthlyAchievements;

  bool showBadgePopup = false;
  int currentPoints = 0;

  Set<String> completedAchievements = {};

  @override
  void initState() {
    super.initState();
    currentPoints = 0;
    _loadDailyPattern();
    _loadAchievements();
  }

  void _loadDailyPattern() {
    const patterns = {
      "Balanced Fitness": {
        "Meals": "🥗 Eat 3 balanced meals + 2 healthy snacks.",
        "Water": "🚰 Drink at least 2.5L of water.",
        "Workout": "🏋️‍♂️ 45–60 min mix strength & cardio.",
        "Steps": "🚶‍♀️ Hit 8,000 steps.",
        "Recovery": "🧘 End with light stretching or foam rolling."
      },
      // you can add more fitGoal patterns here...
    };
    dailyPattern = patterns[widget.fitGoal] ?? {};
  }

  void _loadAchievements() {
    dailyAchievements = [
      {
        "id": "daily_workout",
        "icon": Icons.fitness_center,
        "text": "Complete your daily workout.",
        "points": 10,
      },
      {
        "id": "daily_water",
        "icon": Icons.local_drink,
        "text": "Hit your daily water intake goal.",
        "points": 5,
      },
      {
        "id": "daily_steps",
        "icon": Icons.directions_walk,
        "text": "Reach your step count target.",
        "points": 5,
      },
    ];

    monthlyAchievements = [
      {
        "id": "month_consistency",
        "icon": Icons.emoji_events,
        "text": "Consistency Champ – Log workouts for 25 days.",
        "points": 50,
      },
      {
        "id": "month_strength",
        "icon": Icons.fitness_center,
        "text": "Strength Milestone – Increase 2 personal bests.",
        "points": 50,
      },
    ];
  }

  void _onAchievementTap(Map<String, dynamic> ach) {
    if (completedAchievements.contains(ach["id"])) return;

    setState(() {
      completedAchievements.add(ach["id"]);

      int previousPoints = currentPoints;
      currentPoints += ach["points"] as int;

      // Show badge popup when crossing 50 or 100
      if ((previousPoints < 50 && currentPoints >= 50) ||
          (previousPoints < 100 && currentPoints >= 100)) {
        showBadgePopup = true;
      }
    });
  }

  Widget _buildAchievementButton(Map<String, dynamic> ach) {
    bool isCompleted = completedAchievements.contains(ach["id"]);

    return GestureDetector(
      onTap: () => _onAchievementTap(ach),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.redAccent.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCompleted ? Colors.redAccent : Colors.grey.shade400,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? Colors.redAccent.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(ach["icon"] as IconData,
                color: Colors.redAccent.shade400, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ach["text"] as String,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text("+${ach["points"]} pts",
                style: TextStyle(
                    color: Colors.redAccent.shade700,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = TextStyle(
      color: Colors.redAccent.shade700,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade200,
        title: const Text("Daily Summary & Achievements"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent.shade200,
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: const Icon(Icons.home),
        tooltip: "Back to Home",
      ),
      backgroundColor: const Color(0xFFE4D7D7),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Daily Goals Box (centered content, wider)
                Text("Daily Goals", style: headingStyle),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.92,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: dailyPattern.entries
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      "${e.key}: ${e.value}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Achievements
                Text("Achievements Corner", style: headingStyle),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Daily Achievements",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                ...dailyAchievements.map(_buildAchievementButton),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Monthly Achievements",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                ...monthlyAchievements.map(_buildAchievementButton),

                const SizedBox(height: 40),
                Text("Total Points: $currentPoints",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          /// Badge Popup
          if (showBadgePopup) _buildBadgePopup(context),
        ],
      ),
    );
  }

  Widget _buildBadgePopup(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => showBadgePopup = false),
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.white,
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 64, color: Colors.orange),
                const SizedBox(height: 12),
                const Text(
                  "Congratulations on your new badge!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Close"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () => setState(() => showBadgePopup = false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

