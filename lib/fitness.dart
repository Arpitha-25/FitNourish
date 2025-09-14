import 'package:flutter/material.dart';

// ================== SELECT PHYSIQUE PAGE ==================
class SelectPhysiqueScreen extends StatefulWidget {
  final double userBmi;
  const SelectPhysiqueScreen({Key? key, required this.userBmi}) : super(key: key);


  @override
  State<SelectPhysiqueScreen> createState() => _SelectPhysiqueScreenState();
}


class _SelectPhysiqueScreenState extends State<SelectPhysiqueScreen> {
  String? selectedGoal;
  bool fadeOtherButton = false;
  int? selectedFAB;


  final List<Map<String, dynamic>> goalOptions = [
    {
      'key': 'shred',
      'name': 'Shredding & Definition',
      'desc':
          'Burn fat and reveal muscle.\n• Shed excess fat\n• Preserve lean muscle\n• Sharp definition',
      'bmiRange': '20–24',
      'image': 'assets/image1.png',
      'rec': (double bmi) => bmi >= 20 && bmi <= 24
    },
    {
      'key': 'bulk',
      'name': 'Bulking & Strength',
      'desc':
          'Pack on size and power.\n• Progressive overload\n• Calorie surplus\n• Build power',
      'bmiRange': '18–22',
      'image': 'assets/image2.png',
      'rec': (double bmi) => bmi >= 18 && bmi <= 22
    },
    {
      'key': 'lean',
      'name': 'Lean Muscle Gain',
      'desc':
          'Gain muscle steadily.\n• Balanced training\n• Optimize nutrition\n• Stay defined',
      'bmiRange': '21–25',
      'image': 'assets/image3.png',
      'rec': (double bmi) => bmi >= 21 && bmi <= 25
    },
    {
      'key': 'tone',
      'name': 'Toning & Conditioning',
      'desc':
          'Sculpt muscle tone.\n• Dynamic workouts\n• Boost stamina\n• Athletic look',
      'bmiRange': '20–25',
      'image': 'assets/image4.png',
      'rec': (double bmi) => bmi >= 20 && bmi <= 25
    },
    {
      'key': 'balance',
      'name': 'Balanced Fitness',
      'desc':
          'Maintain overall health.\n• Strength + cardio\n• Mobility + recovery',
      'bmiRange': '20–25 (men), 19–24 (women)',
      'image': 'assets/image5.png',
      'rec': (double bmi) => bmi >= 20 && bmi <= 25
    },
  ];


  Map<String, dynamic> _getRecommendedGoal() {
    return goalOptions.firstWhere((goal) => goal['rec'](widget.userBmi),
        orElse: () => goalOptions.last);
  }


  void _onButtonTap(int index) async {
    setState(() {
      selectedFAB = index;
      fadeOtherButton = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));


    if (selectedGoal != null) {
      final goalDetail = goalOptions.firstWhere((g) => g['key'] == selectedGoal);
      if (index == 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DietRecommendationPage(fitGoal: goalDetail['name'])));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => WorkoutPlansPage(fitGoal: goalDetail['name'])));
      }
    }
    setState(() {
      fadeOtherButton = false;
      selectedFAB = null;
    });
  }


  Widget buildOption(Map<String, dynamic> goal, {bool isRecommended = false}) {
    final w = MediaQuery.of(context).size.width * 0.92;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: w,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: selectedGoal == goal['key'] ? Colors.white : Colors.white70,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selectedGoal == goal['key']
              ? Colors.redAccent.shade200
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: isRecommended
            ? [BoxShadow(color: Colors.redAccent.shade200.withOpacity(0.18), blurRadius: 15)]
            : [],
      ),
      child: InkWell(
        onTap: () => setState(() => selectedGoal = goal['key']),
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.redAccent.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(goal['image'], fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(goal['desc'], style: const TextStyle(fontSize: 15, height: 1.35)),
                  ],
                ),
              ),
              if (selectedGoal == goal['key'])
                const Icon(Icons.check_circle, size: 36, color: Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final recommended = _getRecommendedGoal();
    final others = goalOptions.where((g) => g != recommended).toList();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2D2D2),
        title: const Text("Select your dream physique", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            const Text("Recommended For You", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.redAccent)),
            buildOption(recommended, isRecommended: true),
            Text("Recommended BMI Range: ${recommended['bmiRange']}"),
            const SizedBox(height: 20),
            ...others.map(buildOption).toList(),
            const SizedBox(height: 40),
            _buttonsRow(),
          ],
        ),
      ),
    );
  }


  Widget _buttonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'fab_diet',
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade200),
            icon: const Icon(Icons.restaurant, color: Colors.black),
            label: const Text("Diet Plans", style: TextStyle(color: Colors.black)),
            onPressed: () => _onButtonTap(0),
          ),
        ),
        const SizedBox(width: 20),
        Hero(
          tag: 'fab_workout',
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade200),
            icon: const Icon(Icons.fitness_center, color: Colors.black),
            label: const Text("Workout Plans", style: TextStyle(color: Colors.black)),
            onPressed: () => _onButtonTap(1),
          ),
        ),
      ],
    );
  }
}
class DietRecommendationPage extends StatefulWidget {
  final String fitGoal;
  const DietRecommendationPage({Key? key, required this.fitGoal}) : super(key: key);


  @override
  State<DietRecommendationPage> createState() => _DietRecommendationPageState();
}


class _DietRecommendationPageState extends State<DietRecommendationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool fadeOtherButton = false;
  int? selectedButton;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }


  void _onDietNavTap(int index) async {
    setState(() {
      selectedButton = index;
      fadeOtherButton = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SelectPhysiqueScreen(userBmi: 22)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => WorkoutPlansPage(fitGoal: widget.fitGoal)),
      );
    }
    setState(() {
      fadeOtherButton = false;
      selectedButton = null;
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> vegData = {};
    Map<String, dynamic> nonVegData = {};


    if (widget.fitGoal == "Shredding & Definition") {
      vegData = {
        "DailyTargets": {
          "Calories": "~1800–2000 kcal",
          "Protein": "35% (~150g)",
          "Carbs": "45% (~200g)",
          "Fats": "20% (~45g)",
          "Water": "3–4 L",
          "ProTip": "Focus on low-GI carbs, high protein, and fiber-rich vegetables."
        },
        "MealPlan": [
          {"title": "Breakfast","meal": "2 Multigrain Rotis + 100g Paneer Bhurji (low oil) + Green Tea","macros": "350 kcal | Protein 25g | Carbs 40g | Fats 10g"},
          {"title": "Mid-Morning Snack","meal": "1 Scoop Plant Protein + Almonds (10-12 pieces)","macros": "200 kcal | Protein 22g | Carbs 6g | Fats 8g"},
          {"title": "Lunch","meal": "Grilled Tofu (150g) or Soya Chunks (80g) + Brown Rice + Steamed Veggies","macros": "450 kcal | Protein 35g | Carbs 50g | Fats 10g"},
          {"title": "Evening Snack","meal": "Sprout Salad + Boiled Sweet Potato","macros": "250 kcal | Protein 15g | Carbs 40g | Fats 3g"},
          {"title": "Dinner","meal": "Quinoa + Lentil Soup + Stir-Fried Spinach & Capsicum","macros": "400 kcal | Protein 35g | Carbs 45g | Fats 7g"}
        ],
        "QuickTips": ["Use soya, paneer, tofu for protein.","Avoid refined carbs and sugars.","Limit oil and dairy fat.","Eat more green vegetables."]
      };
      nonVegData = {
        "DailyTargets": {
          "Calories": "~1800–2000 kcal",
          "Protein": "40% (~160g)",
          "Carbs": "30% (~150g)",
          "Fats": "30% (~65g)",
          "Water": "3–3.5 L",
          "ProTip": "Eat every 3-4 hours to keep metabolism active."
        },
        "MealPlan": [
          {"title": "Breakfast","meal":"4 Egg Whites + 1 Whole Egg Omelette + ½ cup Oats with Berries","macros":"350 kcal | Protein 28g | Carbs 32g | Fats 10g"},
          {"title": "Mid-Morning Snack","meal":"15 Almonds + 1 Scoop Whey Protein in Water","macros":"200 kcal | Protein 20g | Carbs 5g | Fats 10g"},
          {"title": "Lunch","meal":"Grilled Chicken Breast + Brown Rice + Steamed Veggies","macros":"400 kcal | Protein 35g | Carbs 35g | Fats 8g"},
          {"title": "Evening Snack","meal":"Greek Yogurt (100g) + Chia Seeds","macros":"150 kcal | Protein 12g | Carbs 10g | Fats 5g"},
          {"title": "Dinner","meal":"Baked Salmon + Zucchini Noodles + Olive Oil Dressing","macros":"350 kcal | Protein 30g | Carbs 15g | Fats 12g"}
        ],
        "QuickTips": ["Avoid sugar.","Prioritize lean protein.","Drink black coffee or green tea.","Avoid carbs before sleep."]
      };
    }
    else if (widget.fitGoal == "Bulking & Strength") {
      vegData = {
        "DailyTargets": {"Calories": "~2800–3200 kcal","Water Intake": "3.5–4 L/day","ProTip": "Eat every 2–3 hours to keep muscles in an anabolic state."},
        "MealPlan": [
          {"title": "Breakfast","meal":"3 Multigrain Parathas (stuffed with Paneer) + Low-Fat Curd (150g)\nSide: 1 Glass Soy Milk or Almond Milk","macros":"650 kcal | Protein 35g | Carbs 70g | Fats 16g"},
          {"title": "Mid-Morning Snack","meal":"Whey Protein (Plant-based) Smoothie with Banana + 2 tbsp Peanut Butter","macros":"500 kcal | Protein 35g | Carbs 55g | Fats 15g"},
          {"title": "Lunch","meal":"Paneer (200g) or Soya Chunks (100g) Curry\nSide: 1.5 cups Brown Rice + Steamed Vegetables + Olive Oil Drizzle","macros":"700 kcal | Protein 50g | Carbs 85g | Fats 18g"},
          {"title": "Evening Snack","meal":"Baked Sweet Potato (200g) + Greek Yogurt (100g) or Plant Yogurt Alternative","macros":"350 kcal | Protein 15g | Carbs 65g | Fats 4g"},
          {"title": "Dinner","meal":"Quinoa (1 cup) + Lentil Soup (Dal) + Sautéed Spinach/Broccoli","macros":"550 kcal | Protein 40g | Carbs 60g | Fats 10g"}
        ],
        "QuickTips": ["Combine legumes & grains for complete proteins.","Add healthy fats (nuts, seeds, avocado) to meet calorie goals.","Use soya, paneer, quinoa, seitan for high-protein meals.","Stay consistent with meals & workouts."]
      };
      nonVegData = {
        "DailyTargets": {"Calories": "~2800–3200 kcal","Water Intake": "3.5–4 L/day","ProTip": "Eat every 2–3 hours to keep muscles in an anabolic state."},
        "MealPlan": [
          {"title": "Breakfast","meal":"4 Whole Eggs + 2 Slices Whole Wheat Bread + Avocado Spread\nSide: 1 Glass Low-Fat Milk","macros":"600 kcal | Protein 35g | Carbs 55g | Fats 18g"},
          {"title": "Mid-Morning Snack","meal":"1 Scoop Whey Protein + 1 Banana + 2 tbsp Peanut Butter (in smoothie form)","macros":"500 kcal | Protein 35g | Carbs 50g | Fats 15g"},
          {"title": "Lunch","meal":"Grilled Chicken Breast (200g) or Lean Beef (150g)\nSide: 1.5 cups Brown Rice + Steamed Veggies + Olive Oil Drizzle","macros":"700 kcal | Protein 50g | Carbs 90g | Fats 15g"},
          {"title": "Evening Snack","meal":"Baked Sweet Potato (200g) + Greek Yogurt (100g)","macros":"350 kcal | Protein 15g | Carbs 65g | Fats 4g"},
          {"title": "Dinner","meal":"Grilled Salmon (150g)\nSide: Quinoa (1 cup) + Sautéed Spinach","macros":"550 kcal | Protein 40g | Carbs 55g | Fats 12g"}
        ],
        "QuickTips": ["Focus on progressive overload in training.","Avoid junk food — clean bulking gives better results.","Get 7–8 hours of sleep for muscle recovery.","Keep carb intake high for workout energy."]
      };
    }
    else if (widget.fitGoal == "Lean Muscle Gain") {
      vegData = {
        "DailyTargets": {"Calories": "~2400–2600 kcal","Water Intake": "3–4 L/day","ProTip": "Stick to lean protein sources and clean carbs for steady muscle gain without excess fat."},
        "MealPlan": [
          {"title": "Breakfast","meal":"1 cup Cooked Oats with Low-Fat Milk + 2 tbsp Peanut Butter + 1 tbsp Chia Seeds + 1 Medium Banana","macros":"450 kcal | Protein 20g | Carbs 60g | Fats 15g"},
          {"title": "Mid-Morning Snack","meal":"200g Low-Fat Greek Yogurt + 20g Almonds + 1 Small Apple","macros":"300 kcal | Protein 20g | Carbs 30g | Fats 10g"},
          {"title": "Lunch","meal":"150g Paneer (Grilled/Lightly Sautéed) + 1 cup Quinoa + Steamed Broccoli, Beans & Carrots + 1 tsp Olive Oil drizzle","macros":"550 kcal | Protein 35g | Carbs 60g | Fats 12g"},
          {"title": "Evening Snack","meal":"1 Scoop Plant-Based Protein Powder + 1 Medium Boiled Sweet Potato (150g)","macros":"300 kcal | Protein 25g | Carbs 40g | Fats 2g"},
          {"title": "Dinner","meal":"150g Soy Chunks Curry (Boiled & Lightly Spiced) + 1 cup Brown Rice + Stir-Fried Spinach & Bell Peppers","macros":"500 kcal | Protein 40g | Carbs 55g | Fats 10g"}
        ],
        "QuickTips": ["Use high-protein vegetarian sources: paneer, soy chunks, Greek yogurt, quinoa, lentils.","Pair legumes with grains for complete amino acids.","Limit fried foods; opt for grilled, steamed, or lightly sautéed meals.","Maintain a balanced carb intake for energy during workouts."]
      };
      nonVegData = {
        "DailyTargets": {"Calories": "~2400–2600 kcal","Water Intake": "3–4 L/day","ProTip": "Stick to lean protein sources and clean carbs for steady muscle gain without excess fat."},
        "MealPlan": [
          {"title": "Breakfast","meal":"4 Egg Whites + 2 Whole Eggs (scrambled, minimal oil) + 2 Slices Whole Wheat Bread + 1 small Avocado","macros":"450 kcal | Protein 35g | Carbs 35g | Fats 15g"},
          {"title": "Mid-Morning Snack","meal":"1 Scoop Whey Protein + Handful of Walnuts (6–7 halves) + 1 Medium Apple","macros":"300 kcal | Protein 25g | Carbs 25g | Fats 10g"},
          {"title": "Lunch","meal":"150g Grilled Chicken Breast + 1 cup Brown Rice + Steamed Broccoli & Zucchini + 1 tsp Olive Oil drizzle","macros":"550 kcal | Protein 45g | Carbs 60g | Fats 10g"},
          {"title": "Evening Snack","meal":"Tuna Salad (100g Tuna in water, Lettuce, Cucumber, Tomato, Lemon) + 1 Medium Boiled Sweet Potato (150g)","macros":"300 kcal | Protein 30g | Carbs 40g | Fats 3g"},
          {"title": "Dinner","meal":"150g Grilled Fish (Tilapia/Salmon) + ½ cup Quinoa + Stir-Fried Spinach & Bell Peppers","macros":"500 kcal | Protein 45g | Carbs 35g | Fats 12g"}
        ],
        "QuickTips": ["Stick to lean proteins: chicken breast, egg whites, fish.","Use complex carbs like quinoa, sweet potato, oats, and brown rice.","Limit oils and fried food to avoid fat gain.","Ensure protein intake is evenly spread throughout the day."]
      };
    }
    else if (widget.fitGoal == "Toning & Conditioning") {
      vegData = {
        "DailyTargets": {"Calories": "~2000–2200 kcal","Water Intake": "3–3.5 L/day","ProTip": "Keep protein high, carbs moderate, and fats healthy to support muscle tone without excess bulk."},
        "MealPlan": [
          {"title": "Breakfast","meal":"1 Cup Low-Fat Greek Yogurt + 2 tbsp Chia Seeds + 1 tbsp Almonds + ½ Cup Berries + 1 slice Whole-Grain Toast","macros":"350 kcal | Protein 20g | Carbs 35g | Fats 10g"},
          {"title": "Mid-Morning Snack","meal":"200ml Soy/Almond Milk + 1 Scoop Plant Protein + 1 Banana","macros":"250 kcal | Protein 20g | Carbs 30g | Fats 4g"},
          {"title": "Lunch","meal":"1 cup Cooked Quinoa + 1 cup Sautéed Paneer (100g, low-fat) + Steamed Broccoli & Zucchini + 1 tsp Olive Oil","macros":"500 kcal | Protein 30g | Carbs 50g | Fats 12g"},
          {"title": "Evening Snack","meal":"1 Medium Sweet Potato (150g) + 15g Mixed Nuts","macros":"280 kcal | Protein 6g | Carbs 40g | Fats 10g"},
          {"title": "Dinner","meal":"1 cup Brown Rice + 100g Tofu/Tempeh + Stir-Fried Spinach, Capsicum & Mushrooms","macros":"450 kcal | Protein 25g | Carbs 50g | Fats 9g"}
        ],
        "QuickTips": ["Include high-protein vegetarian sources like paneer, tofu, tempeh, and quinoa.","Keep carbs moderate and focus on whole grains & root vegetables.","Add fiber-rich vegetables for digestion & micronutrient balance.","Avoid deep-fried snacks and processed cheese."]
      };
      nonVegData = {
        "DailyTargets": {"Calories": "~2000–2200 kcal","Water Intake": "3–3.5 L/day","ProTip": "Keep protein high, carbs moderate, and fats healthy to support muscle tone without excess bulk."},
        "MealPlan": [
          {"title": "Breakfast","meal":"3 Egg Whites + 1 Whole Egg Omelette (with Spinach, Tomato, Onion) + 1 slice Whole-Grain Toast + 1 cup Green Tea","macros":"300 kcal | Protein 25g | Carbs 20g | Fats 10g"},
          {"title": "Mid-Morning Snack","meal":"100g Grilled Chicken Breast + 1 Small Apple","macros":"200 kcal | Protein 20g | Carbs 15g | Fats 3g"},
          {"title": "Lunch","meal":"150g Grilled Fish (Tilapia/Salmon) + 1 cup Brown Rice + Steamed Broccoli & Zucchini + 1 tsp Olive Oil","macros":"500 kcal | Protein 40g | Carbs 50g | Fats 12g"},
          {"title": "Evening Snack","meal":"1 Scoop Whey Protein + 1 Medium Boiled Sweet Potato (150g)","macros":"300 kcal | Protein 25g | Carbs 40g | Fats 2g"},
          {"title": "Dinner","meal":"120g Grilled Chicken or Turkey + 1 cup Quinoa + Stir-Fried Bell Peppers & Spinach","macros":"450 kcal | Protein 40g | Carbs 45g | Fats 8g"}
        ],
        "QuickTips": ["Prioritize lean protein sources like chicken breast, fish, and egg whites.","Keep carbs timed around workouts for sustained energy.","Include plenty of vegetables for micronutrients and fiber.","Avoid high-sugar snacks and deep-fried foods."]
      };
    }
    else if (widget.fitGoal == "Balanced Fitness") {
      vegData = {
        "DailyTargets": {"Calories": "~2200–2400 kcal","Water Intake": "3 L/day","ProTip": "Keep meals balanced with lean proteins, healthy carbs, and good fats to support an active lifestyle."},
        "MealPlan": [
          {"title": "Breakfast","meal":"1 Cup Oats cooked in Skim Milk + 1 tbsp Peanut Butter + ½ Banana + Sprinkle of Chia Seeds","macros":"400 kcal | Protein 15g | Carbs 55g | Fats 12g"},
          {"title": "Mid-Morning Snack","meal":"150g Low-Fat Greek Yogurt or Soy Yogurt + 1 tbsp Honey + 1 tbsp Almonds + ½ Cup Berries","macros":"250 kcal | Protein 12g | Carbs 28g | Fats 9g"},
          {"title": "Lunch","meal":"1 cup Brown Rice + 1 cup Rajma (Kidney Beans Curry) + Steamed Broccoli, Beans & Carrots","macros":"550 kcal | Protein 20g | Carbs 80g | Fats 12g"},
          {"title": "Evening Snack","meal":"1 Medium Sweet Potato (150g) + 20g Mixed Nuts","macros":"300 kcal | Protein 6g | Carbs 42g | Fats 13g"},
          {"title": "Dinner","meal":"1 cup Quinoa + 1 cup Palak Paneer (low-fat paneer) + Sautéed Zucchini & Capsicum","macros":"500 kcal | Protein 28g | Carbs 45g | Fats 15g"}
        ],
        "QuickTips": ["Mix legumes and grains for complete proteins.","Add nuts, seeds, and olive oil for healthy fats.","Keep meals colourful with a variety of vegetables.","Avoid excessive fried or processed vegetarian foods."]
      };
      nonVegData = {
        "DailyTargets": {"Calories": "~2200–2400 kcal","Water Intake": "3 L/day","ProTip": "Keep meals balanced with lean proteins, healthy carbs, and good fats to support an active lifestyle."},
        "MealPlan": [
          {"title": "Breakfast","meal":"3 Egg Omelette (2 whole + 1 white) with Spinach & Tomatoes + 1 slice Whole-Grain Toast + ½ Avocado","macros":"400 kcal | Protein 25g | Carbs 30g | Fats 18g"},
          {"title": "Mid-Morning Snack","meal":"150g Low-Fat Greek Yogurt + 1 tbsp Honey + 1 tbsp Almonds + ½ Cup Blueberries","macros":"250 kcal | Protein 15g | Carbs 25g | Fats 8g"},
          {"title": "Lunch","meal":"120g Grilled Chicken Breast + 1 cup Brown Rice + Steamed Broccoli & Carrots","macros":"550 kcal | Protein 35g | Carbs 60g | Fats 15g"},
          {"title": "Evening Snack","meal":"1 Medium Sweet Potato (150g) + 20g Mixed Nuts","macros":"300 kcal | Protein 8g | Carbs 40g | Fats 12g"},
          {"title": "Dinner","meal":"120g Grilled Salmon or Basa + 1 cup Quinoa + Sautéed Zucchini, Capsicum & Mushrooms","macros":"500 kcal | Protein 32g | Carbs 45g | Fats 14g"}
        ],
        "QuickTips": ["Include a mix of lean poultry, fish, and eggs for high-quality protein.","Balance meals with complex carbs like quinoa, brown rice, and whole-grain bread.","Use healthy fats from avocado, nuts, and olive oil.","Keep sugar & processed snacks to a minimum."]
      };
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade200,
        title: Text("Diet for ${widget.fitGoal}", style: const TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[700],
          tabs: const [
            Tab(icon: Icon(Icons.eco, color: Colors.black), text: "Veg"),
            Tab(icon: Icon(Icons.set_meal, color: Colors.black), text: "Non-Veg"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _dietListView(vegData),
                _dietListView(nonVegData),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'back_select',
                  child: AnimatedOpacity(
                    opacity: fadeOtherButton && selectedButton != 0 ? 0.05 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade200),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      label: const Text("Select Physique", style: TextStyle(color: Colors.black)),
                      onPressed: () => _onDietNavTap(0),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Hero(
                  tag: 'to_workout',
                  child: AnimatedOpacity(
                    opacity: fadeOtherButton && selectedButton != 1 ? 0.05 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade200),
                      icon: const Icon(Icons.fitness_center, color: Colors.black),
                      label: const Text("Workout Plan", style: TextStyle(color: Colors.black)),
                      onPressed: () => _onDietNavTap(1),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _dietListView(Map<String, dynamic> data) {
    final daily = data["DailyTargets"] ?? {};
    final meals = data["MealPlan"] ?? [];
    final tips = data["QuickTips"] ?? [];
    final cardTextStyle = const TextStyle(color: Colors.black, fontSize: 16);
    final cardTitleStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent);


    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _dietCard([
          Text("Daily Targets", style: cardTitleStyle),
          const SizedBox(height: 8),
          ...daily.entries.where((e) => e.key != "ProTip").map((e) => Text("${e.key}: ${e.value}", style: cardTextStyle)),
          if (daily["ProTip"] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("Pro Tip: ${daily['ProTip']}", style: cardTextStyle.copyWith(fontStyle: FontStyle.italic)),
            ),
        ]),
        ...meals.map((m) => _dietCard([
              Text(m["title"], style: cardTitleStyle.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(m["meal"], style: cardTextStyle),
              const SizedBox(height: 4),
              Text(m["macros"], style: cardTextStyle.copyWith(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[800])),
            ])),
        if (tips.isNotEmpty)
          _dietCard([
            Text("Quick Tips", style: cardTitleStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 8),
            ...tips.map((t) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(fontSize: 17)),
                    Expanded(child: Text(t, style: cardTextStyle)),
                  ],
                )),
          ]),
      ],
    );
  }


  Widget _dietCard(List<Widget> children) => Card(
        margin: const EdgeInsets.symmetric(vertical: 7),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
      );
}
// ================== WORKOUT PAGE ==================
class WorkoutPlansPage extends StatefulWidget {
  final String fitGoal;
  const WorkoutPlansPage({Key? key, required this.fitGoal}) : super(key: key);


  @override
  State<WorkoutPlansPage> createState() => _WorkoutPlansPageState();
}


class _WorkoutPlansPageState extends State<WorkoutPlansPage> {
  bool fadeOtherButton = false;
  int? selectedButton;


  void _onNavTap(int index) async {
    setState(() {
      selectedButton = index;
      fadeOtherButton = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SelectPhysiqueScreen(userBmi: 22)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DietRecommendationPage(fitGoal: widget.fitGoal)),
      );
    }
    setState(() {
      fadeOtherButton = false;
      selectedButton = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    TextStyle cardText = const TextStyle(fontSize: 15, color: Colors.black, height: 1.4);
    TextStyle cardTitle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent);
    List<Widget> cards = [];


    if (widget.fitGoal == "Shredding & Definition") {
      cards.add(_workoutCard([
        Text("Goal: Burn fat, maintain lean muscle, and improve muscle definition.", style: cardText),
        Text("Plan Type: 5-Day Split", style: cardText),
        Text("Duration: 45–60 min/session", style: cardText),
        const SizedBox(height: 8),
        Text("Weekly Structure:", style: cardTitle),
        Text("Day 1 – Full Body HIIT", style: cardText),
        Text("Day 2 – Upper Body Strength + Core", style: cardText),
        Text("Day 3 – Lower Body Burn", style: cardText),
        Text("Day 4 – Cardio & Core", style: cardText),
        Text("Day 5 – Total Body Circuit", style: cardText),
        Text("Day 6 – Active Recovery (yoga, stretching)", style: cardText),
        Text("Day 7 – Rest", style: cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 1 – Full Body HIIT", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps / Time", "Rest", "Equipment"],
          ["Jump Squats", "3×15", "30s", "None"],
          ["Push-Ups", "3×12", "45s", "None"],
          ["Dumbbell Thrusters", "3×12", "45s", "Dumbbells"],
          ["Mountain Climbers", "3×30s", "20s", "None"],
          ["Plank to Shoulder Tap", "3×12 each side", "30s", "None"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 2 – Upper Body Strength + Core", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Push-Ups", "4×12", "45s", "None"],
          ["Dumbbell Row", "4×12", "45s", "Dumbbells"],
          ["Shoulder Press", "3×12", "45s", "Dumbbells"],
          ["Russian Twists", "3×20", "30s", "Dumbbell/None"],
          ["Hanging Leg Raises", "3×12", "30s", "Pull-Up Bar"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 3 – Lower Body Burn", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Walking Lunges", "3×12 each leg", "30s", "Dumbbells (optional)"],
          ["Squat Jumps", "3×15", "30s", "None"],
          ["Glute Bridge", "3×15", "30s", "None"],
          ["Calf Raises", "3×20", "20s", "Dumbbells (optional)"],
          ["Side Plank Leg Lifts", "3×10 each side", "20s", "None"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 4 – Cardio & Core", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Time", "Rest", "Equipment"],
          ["Burpees", "30s", "20s", "None"],
          ["High Knees", "30s", "20s", "None"],
          ["Sit-Ups", "30s", "15s", "None"],
          ["Plank", "40s", "20s", "None"],
          ["Mountain Climbers", "30s", "20s", "None"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 5 – Total Body Circuit", style: cardTitle),
        Text("Perform all exercises back-to-back, rest 90s, repeat for 3 rounds.", style: cardText),
        const SizedBox(height: 7),
        _exerciseTable([
          ["Exercise", "Reps / Time"],
          ["Push-Ups", "12 reps"],
          ["Squats", "15 reps"],
          ["Dumbbell Shoulder Press", "12 reps"],
          ["Jumping Jacks", "30s"],
          ["Bicycle Crunches", "20 reps"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 6 – Active Recovery", style: cardTitle),
        Text("Yoga, stretching, foam rolling, or gentle walk/cycle.", style: cardText)
      ]));
      cards.add(_workoutCard([
        Text("Day 7 – Rest", style: cardTitle),
        Text("Complete rest or gentle mobility only.", style: cardText)
      ]));
    }
    else if (widget.fitGoal == "Bulking & Strength") {
      cards.add(_workoutCard([
        Text("Goal: Build muscle mass, increase strength, and improve power output.", style: cardText),
        Text("Plan Type: 5-Day Split", style: cardText),
        Text("Duration: 60–75 min/session", style: cardText),
        const SizedBox(height: 8),
        Text("Weekly Structure:", style: cardTitle),
        Text("Day 1 – Push (Chest, Shoulders, Triceps)", style: cardText),
        Text("Day 2 – Pull (Back, Biceps)", style: cardText),
        Text("Day 3 – Legs (Quads, Hamstrings, Glutes, Calves)", style: cardText),
        Text("Day 4 – Upper Body Power", style: cardText),
        Text("Day 5 – Lower Body Power", style: cardText),
        Text("Day 6 – Rest or Light Mobility", style: cardText),
        Text("Day 7 – Rest", style: cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 1 – Push (Chest, Shoulders, Triceps)", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Bench Press", "4×8", "90s", "Barbell"],
          ["Overhead Shoulder Press", "4×8", "90s", "Barbell/Dumbbells"],
          ["Incline Dumbbell Press", "3×10", "75s", "Dumbbells"],
          ["Dumbbell Lateral Raise", "3×12", "60s", "Dumbbells"],
          ["Tricep Rope Pushdown", "3×12", "60s", "Cable/Resistance Band"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 2 – Pull (Back, Biceps)", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Barbell Deadlift", "4×6", "120s", "Barbell"],
          ["Pull-Ups / Lat Pulldown", "4×8", "90s", "Pull-Up Bar/Cable"],
          ["Barbell Row", "3×10", "90s", "Barbell"],
          ["Dumbbell Bicep Curl", "3×12", "60s", "Dumbbells"],
          ["Face Pulls", "3×12", "60s", "Cable/Resistance Band"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 3 – Legs (Strength & Mass)", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Barbell Squat", "4×6", "120s", "Barbell"],
          ["Romanian Deadlift", "4×8", "90s", "Barbell/Dumbbells"],
          ["Walking Lunges", "3×12 each leg", "75s", "Dumbbells"],
          ["Calf Raises", "4×15", "60s", "Dumbbells/Bodyweight"],
          ["Leg Curl (Machine or Band)", "3×12", "60s", "Machine/Band"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 4 – Upper Body Power", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Push Press", "4×5", "120s", "Barbell"],
          ["Weighted Pull-Up", "4×5", "120s", "Pull-Up Bar + Weight"],
          ["Incline Barbell Bench Press", "3×6", "90s", "Barbell"],
          ["Pendlay Row", "3×6", "90s", "Barbell"],
          ["Weighted Dips", "3×8", "90s", "Dip Bar + Weight"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 5 – Lower Body Power", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Power Clean", "4×4", "150s", "Barbell"],
          ["Front Squat", "4×5", "120s", "Barbell"],
          ["Bulgarian Split Squat", "3×8 each leg", "90s", "Dumbbells"],
          ["Hip Thrust", "4×6", "90s", "Barbell"],
          ["Sled Push / Farmer’s Carry", "3×20m", "90s", "Sled/Dumbbells"],
        ], cardText),
      ]));
    }
    else if (widget.fitGoal == "Lean Muscle Gain") {
      cards.add(_workoutCard([
        Text("Goal: Build lean muscle mass while keeping body fat low.", style: cardText),
        Text("Plan Type: 4–5 Day Upper/Lower Split", style: cardText),
        Text("Duration: 50–65 min/session", style: cardText),
        const SizedBox(height: 8),
        Text("Weekly Structure:", style: cardTitle),
        Text("Day 1 – Upper Body (Push Focus)", style: cardText),
        Text("Day 2 – Lower Body (Strength & Conditioning)", style: cardText),
        Text("Day 3 – Active Recovery / Cardio", style: cardText),
        Text("Day 4 – Upper Body (Pull Focus)", style: cardText),
        Text("Day 5 – Lower Body + Core", style: cardText),
        Text("Day 6 – Optional HIIT or Mobility", style: cardText),
        Text("Day 7 – Rest", style: cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 1 – Upper Body (Push Focus)", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Incline Dumbbell Press", "4×10", "75s", "Dumbbells"],
          ["Overhead Press", "4×8", "90s", "Barbell/Dumbbells"],
          ["Dumbbell Flyes", "3×12", "60s", "Dumbbells"],
          ["Lateral Raises", "3×12", "60s", "Dumbbells"],
          ["Triceps Dips", "3×10", "60s", "Parallel Bars/Bench"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 2 – Lower Body (Strength & Conditioning)", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Barbell Squat", "4×8", "90s", "Barbell"],
          ["Bulgarian Split Squat", "3×10 each leg", "75s", "Dumbbells"],
          ["Romanian Deadlift", "3×10", "75s", "Barbell/Dumbbells"],
          ["Calf Raises", "4×15", "60s", "Dumbbells/Bodyweight"],
          ["Jump Squats", "3×12", "45s", "Bodyweight"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 4 – Upper Body (Pull Focus)", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Pull-Ups / Lat Pulldown", "4×8–10", "90s", "Pull-Up Bar/Cable"],
          ["Dumbbell Row", "4×10", "90s", "Dumbbells"],
          ["Face Pulls", "3×12", "60s", "Cable/Resistance Band"],
          ["Hammer Curls", "3×12", "60s", "Dumbbells"],
          ["Reverse Flyes", "3×12", "60s", "Dumbbells"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 5 – Lower Body + Core", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Deadlift", "4×6", "120s", "Barbell"],
          ["Walking Lunges", "3×12 each leg", "75s", "Dumbbells"],
          ["Hip Thrusts", "3×10", "75s", "Barbell"],
          ["Hanging Leg Raises", "3×12", "60s", "Pull-Up Bar"],
          ["Plank with Shoulder Tap", "3×30s", "45s", "Bodyweight"],
        ], cardText),
      ]));
    }
    else if (widget.fitGoal == "Toning & Conditioning") {
      cards.add(_workoutCard([
        Text("Goal: Improve muscle definition, stamina, and overall functional fitness.", style: cardText),
        Text("Plan Type: 5-Day Full Body & Circuit Training Mix.", style: cardText),
        Text("Duration: 40–55 min/session", style: cardText),
        const SizedBox(height: 8),
        Text("Weekly Structure:", style: cardTitle),
        Text("Day 1 – Full Body Circuit (Strength + Cardio)", style: cardText),
        Text("Day 2 – Lower Body Toning + Core", style: cardText),
        Text("Day 3 – Active Recovery / Yoga / Light Cardio", style: cardText),
        Text("Day 4 – Upper Body Toning + Conditioning", style: cardText),
        Text("Day 5 – HIIT & Core Burn", style: cardText),
        Text("Day 6 – Optional Mobility / Light Cardio", style: cardText),
        Text("Day 7 – Rest", style: cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 1 – Full Body Circuit", style: cardTitle),
        Text("(Perform each exercise for 40 sec, rest 20 sec, complete 3–4 rounds)", style: cardText),
        const SizedBox(height: 6),
        _exerciseTable([
          ["Exercise", "Equipment"],
          ["Squat to Press", "Dumbbells"],
          ["Push-Ups", "Bodyweight"],
          ["Bent-Over Row", "Dumbbells"],
          ["Jump Lunges", "Bodyweight"],
          ["Mountain Climbers", "Bodyweight"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 2 – Lower Body Toning + Core", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Goblet Squat", "3×12", "60s", "Dumbbell"],
          ["Step-Ups", "3×12 each leg", "60s", "Dumbbells"],
          ["Glute Bridges", "3×15", "45s", "Bodyweight/Dumbbell"],
          ["Side Plank Hip Dips", "3×12 each side", "45s", "Bodyweight"],
          ["Flutter Kicks", "3×30s", "30s", "Bodyweight"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 4 – Upper Body Toning + Conditioning", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Incline Push-Ups", "3×12", "45s", "Bodyweight"],
          ["Dumbbell Lateral Raise", "3×12", "45s", "Dumbbells"],
          ["Bicep Curl to Shoulder Press", "3×10", "60s", "Dumbbells"],
          ["Resistance Band Pull-Apart", "3×15", "45s", "Band"],
          ["Plank Row", "3×10 each arm", "45s", "Dumbbells"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 5 – HIIT & Core Burn", style: cardTitle),
        Text("(20 sec work / 10 sec rest – 8 rounds each exercise)", style: cardText),
        const SizedBox(height: 6),
        _exerciseTable([
          ["Exercise"],
          ["Burpees"],
          ["Jump Squats"],
          ["High Knees"],
          ["Russian Twists"],
          ["Bicycle Crunches"],
        ], cardText),
      ]));
    }
    else if (widget.fitGoal == "Balanced Fitness") {
      cards.add(_workoutCard([
        Text("Goal: Improve overall health, strength, stamina, and mobility.", style: cardText),
        Text("Plan Type: 5-Day Mixed Training Schedule.", style: cardText),
        Text("Duration: 45–60 min/session", style: cardText),
        const SizedBox(height: 8),
        Text("Weekly Structure:", style: cardTitle),
        Text("Day 1 – Full Body Strength", style: cardText),
        Text("Day 2 – Low-Impact Cardio + Mobility", style: cardText),
        Text("Day 3 – Upper Body Strength + Core", style: cardText),
        Text("Day 4 – Cardio Intervals (HIIT or Steady-State)", style: cardText),
        Text("Day 5 – Lower Body Strength + Core", style: cardText),
        Text("Day 6 – Active Recovery / Yoga / Stretching", style: cardText),
        Text("Day 7 – Rest", style: cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 1 – Full Body Strength", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Squats", "3×10", "60s", "Dumbbells/Barbell"],
          ["Push-Ups", "3×12", "45s", "Bodyweight"],
          ["Dumbbell Rows", "3×10 each side", "60s", "Dumbbells"],
          ["Plank Hold", "3×30s", "30s", "Bodyweight"],
          ["Jump Rope", "3×1 min", "30s", "Rope"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 2 – Low-Impact Cardio + Mobility", style: cardTitle),
        _exerciseTable([
          ["Activity", "Duration"],
          ["Brisk Walk or Stationary Bike", "20 min"],
          ["Dynamic Stretch Flow", "10 min"],
          ["Resistance Band Mobility Drills", "10 min"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 3 – Upper Body Strength + Core", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Shoulder Press", "3×12", "45s", "Dumbbells"],
          ["Bicep Curl to Press", "3×10", "45s", "Dumbbells"],
          ["Tricep Dips", "3×12", "45s", "Bodyweight"],
          ["Side Plank", "3×20s each side", "30s", "Bodyweight"],
          ["Mountain Climbers", "3×30s", "30s", "Bodyweight"],
        ], cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 4 – Cardio Intervals", style: cardTitle),
        Text("(Alternate 1 min high intensity / 1 min low intensity for 20 min)", style: cardText),
        const SizedBox(height: 5),
        Text("Examples: Sprint-Walk, Bike Sprints, Rowing Machine.", style: cardText),
      ]));


      cards.add(_workoutCard([
        Text("Day 5 – Lower Body Strength + Core", style: cardTitle),
        _exerciseTable([
          ["Exercise", "Sets × Reps", "Rest", "Equipment"],
          ["Lunges", "3×12 each leg", "60s", "Dumbbells"],
          ["Glute Bridges", "3×15", "45s", "Bodyweight/Dumbbell"],
          ["Step-Ups", "3×12 each leg", "45s", "Dumbbells"],
          ["Leg Raises", "3×12", "30s", "Bodyweight"],
          ["Russian Twists", "3×20", "30s", "Bodyweight"],
        ], cardText),
      ]));
    }


        return Scaffold(
      backgroundColor: const Color(0xFFE4D7D7),
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade200,
        title: Text("${widget.fitGoal} - Workout Plan", style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: cards,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'back_select',
                  child: AnimatedOpacity(
                    opacity: fadeOtherButton && selectedButton != 0 ? 0.05 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade200,
                        foregroundColor: Colors.black,
                      ),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      label: const Text(
                        "Select Physique",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => _onNavTap(0),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Hero(
                  tag: 'to_diet',
                  child: AnimatedOpacity(
                    opacity: fadeOtherButton && selectedButton != 1 ? 0.05 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade200,
                        foregroundColor: Colors.black,
                      ),
                      icon: const Icon(Icons.restaurant, color: Colors.black),
                      label: const Text(
                        "Diet Plan",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => _onNavTap(1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _workoutCard(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }


  Widget _exerciseTable(List<List<String>> rows, TextStyle textStyle) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.3),
      },
      border: TableBorder.all(color: Colors.redAccent.shade100, width: 0.5),
      children: List.generate(
        rows.length,
        (idx) => TableRow(
          decoration: idx == 0 ? const BoxDecoration(color: Color(0xFFF6ECEC)) : null,
          children: rows[idx]
              .map(
                (cell) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                  child: Text(
                    cell,
                    textAlign: TextAlign.left,
                    style: idx == 0
                        ? textStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.black)
                        : textStyle,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
