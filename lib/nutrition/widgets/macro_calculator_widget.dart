import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class MacroCalculatorWidget extends StatefulWidget {
  const MacroCalculatorWidget({super.key});

  @override
  State<MacroCalculatorWidget> createState() => _MacroCalculatorWidgetState();
}

class _MacroCalculatorWidgetState extends State<MacroCalculatorWidget> {
  double _weight = 70;
  double _height = 165;
  int _age = 25;
  String _activityLevel = 'moderately_active';
  String _calorieGoal = 'maintenance';

  final Map<String, double> _activityMultipliers = {
    'sedentary': 1.2,
    'lightly_active': 1.375,
    'moderately_active': 1.55,
    'very_active': 1.725,
    'extremely_active': 1.9
  };

  @override
  Widget build(BuildContext context) {
    // BMR calculation (Mifflin-St Jeor Equation for women)
    double bmr = (10 * _weight) + (6.25 * _height) - (5 * _age) - 161;
    int tdee = (bmr * _activityMultipliers[_activityLevel]!).round();

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
              Expanded(child: _buildInput('Weight (kg)', _weight.toString(), (v) => setState(() => _weight = double.tryParse(v) ?? 0))),
              const SizedBox(width: 12),
              Expanded(child: _buildInput('Height (cm)', _height.toString(), (v) => setState(() => _height = double.tryParse(v) ?? 0))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildInput('Age', _age.toString(), (v) => setState(() => _age = int.tryParse(v) ?? 0))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ACTIVITY LEVEL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B7355))),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      _activityLevel,
                      ['sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extremely_active'],
                      (v) => setState(() => _activityLevel = v!),
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
                    _buildMacroItem('Carbs', '${_calculateCarbs(tdee)}g', '40%', const Color(0xFF7DD3C0)),
                    _buildMacroItem('Fat', '${_calculateFat(tdee)}g', '30%', const Color(0xFFE8A87C)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildInput(String label, String value, Function(String) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B7355))),
        const SizedBox(height: 6),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: value,
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
