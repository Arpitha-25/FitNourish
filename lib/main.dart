import 'package:flutter/material.dart';

// Screens
import 'home.dart';
import 'bmi.dart';
import 'profile.dart';
import 'routine.dart';
import 'help.dart';
import 'fitness.dart'; // merged Physique, Diet, Workout

void main() {
  runApp(FitNourish());
}

class FitNourish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitNourish',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FitNourishHomePage(),
        '/bmi': (context) => BmiCalculatorScreen(),
        '/profile': (context) => UserProfilePage(),
        '/routine': (context) => SummaryGoalsPage(
              fitGoal: 'Balanced Fitness',
              totalPoints: 50,
            ),
        '/help': (context) => HelpFaqScreen(),
        '/physique': (context) => SelectPhysiqueScreen(userBmi: 22),
        '/diet': (context) => DietRecommendationPage(fitGoal: 'Balanced Fitness'),
        '/workout': (context) => WorkoutPlansPage(fitGoal: 'Balanced Fitness'),
      },
    );
  }
}

