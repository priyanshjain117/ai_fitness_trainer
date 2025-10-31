import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';


enum DietGoal { loseWeight, maintain, buildMuscle }

class DietPlannerScreen extends StatefulWidget {
  const DietPlannerScreen({super.key});

  @override
  State<DietPlannerScreen> createState() => _DietPlannerScreenState();
}

class _DietPlannerScreenState extends State<DietPlannerScreen> {

  DietGoal _selectedGoal = DietGoal.maintain;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Personalized Diet Plan',
          style: TextStyle(
            color: const Color(0xFF00FF88), // Main accent color
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Your Primary Goal",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.h),
            _buildGoalSelector(),
            SizedBox(height: 30.h),
            
            _buildDietDetails(),
          ],
        ),
      ),
    );
  }

Widget _buildGoalSelector() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _buildGoalChip(DietGoal.loseWeight, "Lose Weight", Icons.trending_down),
        SizedBox(width: 8.w),
        _buildGoalChip(DietGoal.maintain, "Maintain", Icons.sync),
        SizedBox(width: 8.w),
        _buildGoalChip(DietGoal.buildMuscle, "Build Muscle", Icons.trending_up),
        SizedBox(width: 16.w),
      ],
    ),
  );
}

  Widget _buildGoalChip(DietGoal goal, String label, IconData icon) {
    final bool isSelected = _selectedGoal == goal;
    return ChoiceChip(
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      avatar: Icon(
        icon,
        color: isSelected ? Colors.black : const Color(0xFF00FF88),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF00FF88), // Accent color
      backgroundColor: const Color(0xFF1E1E1E), // Dark card color
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedGoal = goal;
          });
        }
      },
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    );
  }

  /// Dynamically builds the diet structure based on the selected goal
  Widget _buildDietDetails() {
    // These values would come from a real calculation
    String calorieTarget;
    double proteinPercent, carbsPercent, fatPercent;
    List<String> breakfast, lunch, dinner, snacks;

    switch (_selectedGoal) {
      case DietGoal.loseWeight:
        calorieTarget = "~2,000 kcal";
        proteinPercent = 0.40; // 40%
        carbsPercent = 0.35;   // 35%
        fatPercent = 0.25;     // 25%
        breakfast = ["Oatmeal with berries", "2 hard-boiled eggs"];
        lunch = ["Grilled chicken salad", "Quinoa bowl with vegetables"];
        dinner = ["Baked salmon with asparagus", "Lean turkey chili"];
        snacks = ["Greek yogurt", "Handful of almonds"];
        break;
      case DietGoal.buildMuscle:
        calorieTarget = "~3,000 kcal";
        proteinPercent = 0.35; // 35%
        carbsPercent = 0.45;   // 45%
        fatPercent = 0.20;     // 20%
        breakfast = ["4-egg omelette with spinach", "Protein shake"];
        lunch = ["Beef stir-fry with brown rice", "Chicken breast with sweet potato"];
        dinner = ["Steak with mixed veggies", "Large pasta bowl with lean ground beef"];
        snacks = ["Cottage cheese", "Rice cakes with peanut butter"];
        break;
      case DietGoal.maintain:
      default:
        calorieTarget = "~2,500 kcal";
        proteinPercent = 0.30; // 30%
        carbsPercent = 0.40;   // 40%
        fatPercent = 0.30;     // 30%
        breakfast = ["Whole grain toast with avocado", "Greek yogurt"];
        lunch = ["Turkey wrap", "Mixed bean salad"];
        dinner = ["Chicken and vegetable skewers", "Tofu stir-fry"];
        snacks = ["Apple with peanut butter", "Protein bar"];
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daily Target: $calorieTarget",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "Macro-Nutrient Structure",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        _buildMacroDisplay(proteinPercent, carbsPercent, fatPercent),
        SizedBox(height: 30.h),
        Text(
          "Sample Meal Structure",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        _buildMealCard("Breakfast", breakfast, Icons.free_breakfast),
        _buildMealCard("Lunch", lunch, Icons.lunch_dining),
        _buildMealCard("Dinner", dinner, Icons.dinner_dining),
        _buildMealCard("Snacks", snacks, Icons.fastfood),
      ],
    );
  }

  /// Builds the row of circular indicators for macros
  Widget _buildMacroDisplay(double protein, double carbs, double fat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMacroIndicator(protein, "Protein", const Color(0xFF00FF88)),
        _buildMacroIndicator(carbs, "Carbs", Colors.blueAccent),
        _buildMacroIndicator(fat, "Fats", Colors.orangeAccent),
      ],
    );
  }

  Widget _buildMacroIndicator(double percent, String label, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 45.r,
          lineWidth: 8.w,
          percent: percent,
          center: Text(
            "${(percent * 100).toInt()}%",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          progressColor: color,
          backgroundColor: Colors.grey.shade800,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }


  Widget _buildMealCard(String title, List<String> items, IconData icon) {
    return Card(
      color: const Color(0xFF1E1E1E), // Dark card color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      margin: EdgeInsets.only(bottom: 15.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF00FF88), size: 30.sp),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            items.join("\n• "), // Formats list with bullet points
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
