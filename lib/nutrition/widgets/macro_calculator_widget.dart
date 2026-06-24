import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/nutrition_controller.dart';
import '../../core/app_colors.dart';

class MacroCalculatorWidget extends StatefulWidget {
  const MacroCalculatorWidget({super.key});

  @override
  State<MacroCalculatorWidget> createState() => _MacroCalculatorWidgetState();
}

class _MacroCalculatorWidgetState extends State<MacroCalculatorWidget> {
  final NutritionController controller = Get.find<NutritionController>();
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _ageController;
  String _calorieGoal = 'maintenance';

  final Map<String, double> _activityMultipliers = {
    'sedentary': 1.2,
    'lightly_active': 1.375,
    'moderately_active': 1.55,
    'very_active': 1.725,
    'extremely_active': 1.9
  };

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: controller.weight.value.toStringAsFixed(0));
    _heightController = TextEditingController(text: controller.height.value.toStringAsFixed(0));
    _ageController = TextEditingController(text: controller.age.value.toString());

    // Sync input values when backend profile loads
    ever(controller.weight, (val) {
      if (_weightController.text != val.toStringAsFixed(0)) {
        _weightController.text = val.toStringAsFixed(0);
      }
    });
    ever(controller.height, (val) {
      if (_heightController.text != val.toStringAsFixed(0)) {
        _heightController.text = val.toStringAsFixed(0);
      }
    });
    ever(controller.age, (val) {
      if (_ageController.text != val.toString()) {
        _ageController.text = val.toString();
      }
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final weightVal = controller.weight.value;
      final heightVal = controller.height.value;
      final ageVal = controller.age.value;
      final activityLevelVal = controller.activityLevel.value;

      // BMR calculation (Mifflin-St Jeor Equation for women)
      double bmr = (10 * weightVal) + (6.25 * heightVal) - (5 * ageVal) - 161;
      int tdee = (bmr * (_activityMultipliers[activityLevelVal] ?? 1.55)).round();

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calculate_rounded, color: Color(0xFF8B7355), size: 24),
                SizedBox(width: 12),
                Text(
                  'Macro Calculator',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2420),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Inputs Grid
            Row(
              children: [
                Expanded(
                  child: _buildInput(
                    'Weight (kg)', 
                    _weightController, 
                    (v) => controller.weight.value = double.tryParse(v) ?? 0.0
                  )
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInput(
                    'Height (cm)', 
                    _heightController, 
                    (v) => controller.height.value = double.tryParse(v) ?? 0.0
                  )
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInput(
                    'Age', 
                    _ageController, 
                    (v) => controller.age.value = int.tryParse(v) ?? 0
                  )
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ACTIVITY LEVEL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B7355))),
                      const SizedBox(height: 6),
                      _buildDropdown(
                        activityLevelVal,
                        ['sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extremely_active'],
                        (v) => controller.activityLevel.value = v!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            const Text('CALORIE GOAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B7355))),
            const SizedBox(height: 6),
            _buildDropdown(
              _calorieGoal,
              ['weight_loss', 'moderate_loss', 'maintenance', 'moderate_gain', 'weight_gain'],
              (v) => setState(() => _calorieGoal = v!),
            ),
            
            const SizedBox(height: 24),
            
            // Results Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF5F3F0), Color(0xFFE8DDD0)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4C5B0)),
              ),
              child: Column(
                children: [
                  const Text('Maintenance Calories (TDEE)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('$tdee kcal', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFD4C5B0)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Target Daily Calories', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Text(
                        '${_calculateTargetCalories(tdee)}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF8B7355)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFD4C5B0)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMacroItem('Protein', '${_calculateProtein(tdee)}g', '30%', const Color(0xFF8B7355)),
                      _buildMacroItem('Carbs', '${_calculateCarbs(tdee)}g', '40%', const Color(0xFFB08968)),
                      _buildMacroItem('Fat', '${_calculateFat(tdee)}g', '30%', const Color(0xFFE8A87C)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isSaving.value ? null : () => controller.saveUserProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B7355),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(controller.isSaving.value ? 'Saving...' : 'Save to Profile'),
              ),
            ),
          ],
        ),
      );
    });
  }

  int _calculateTargetCalories(int tdee) {
    switch (_calorieGoal) {
      case 'weight_loss': return (tdee * 0.80).round();
      case 'moderate_loss': return (tdee * 0.85).round();
      case 'weight_gain': return (tdee * 1.15).round();
      case 'moderate_gain': return (tdee * 1.10).round();
      default: return tdee;
    }
  }

  int _calculateProtein(int tdee) => (_calculateTargetCalories(tdee) * 0.30 / 4).round();
  int _calculateCarbs(int tdee) => (_calculateTargetCalories(tdee) * 0.40 / 4).round();
  int _calculateFat(int tdee) => (_calculateTargetCalories(tdee) * 0.30 / 9).round();

  Widget _buildInput(String label, TextEditingController txtController, Function(String) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B7355))),
        const SizedBox(height: 6),
        TextField(
          controller: txtController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEDE6DD),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
          onChanged: onChange,
        ),
      ],
    );
  }

  Widget _buildDropdown(String value, List<String> options, Function(String?) onChange) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE6DD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF8B7355)),
          items: options.map((String opt) {
            return DropdownMenuItem<String>(
              value: opt,
              child: Text(
                opt.replaceAll('_', ' ').toUpperCase(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2D2420)),
              ),
            );
          }).toList(),
          onChanged: onChange,
        ),
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, String percent, Color color) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Text(percent, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
