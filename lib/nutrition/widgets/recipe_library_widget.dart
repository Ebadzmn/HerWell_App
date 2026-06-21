import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/nutrition_controller.dart';
import '../../core/app_colors.dart';

class RecipeLibraryWidget extends StatelessWidget {
  const RecipeLibraryWidget({super.key});

  void _showRecipeDetail(BuildContext context, Map<String, dynamic> recipe) {
    final prepTime = recipe['prepTime'] ?? recipe['time'] ?? '15 min';
    final caloriesText = '${recipe['cals'] ?? recipe['calories'] ?? 300} kcal';
    final firstPhase = List<dynamic>.from(recipe['phases'] ?? []).isNotEmpty
        ? List<dynamic>.from(recipe['phases'])[0].toString()
        : (recipe['phase']?.toString() ?? '');
    final phaseText = firstPhase.isNotEmpty
        ? firstPhase[0].toUpperCase() + firstPhase.substring(1)
        : 'All';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(recipe['emoji'] ?? '🍽️', style: const TextStyle(fontSize: 48)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recipe['name'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text(recipe['tagline'] ?? '', style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailTag(Icons.timer_outlined, prepTime),
                  _buildDetailTag(Icons.local_fire_department_rounded, caloriesText),
                  _buildDetailTag(Icons.spa_rounded, phaseText),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              if (recipe['ingredients'] != null && recipe['ingredients'] is List)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (recipe['ingredients'] as List<dynamic>).map((ing) {
                    final name = ing['n'] ?? ing['name'] ?? '';
                    final amount = ing['a'] ?? ing['amount'] ?? '';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        '• $amount $name',
                        style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary),
                      ),
                    );
                  }).toList(),
                )
              else
                const Text('• Standard ingredients', style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary)),
              const SizedBox(height: 32),
              const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              if (recipe['steps'] != null && recipe['steps'] is List)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (recipe['steps'] as List<dynamic>).asMap().entries.map((entry) {
                    final idx = entry.key + 1;
                    final step = entry.value.toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '$idx. $step',
                        style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary),
                      ),
                    );
                  }).toList(),
                )
              else
                const Text('1. Prepare and enjoy.', style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Add to Log'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTag(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NutritionController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(color: Color(0xFF8B7355)),
          ),
        );
      }

      if (controller.recipes.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'No recipes found.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const Text(
            'Quick Recipes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.recipes.length,
            itemBuilder: (context, index) {
              final recipe = controller.recipes[index];
              final prepTime = recipe['prepTime'] ?? recipe['time'] ?? '15 min';
              final caloriesText = '${recipe['cals'] ?? recipe['calories'] ?? 300} kcal';
              final firstPhase = List<dynamic>.from(recipe['phases'] ?? []).isNotEmpty
                  ? List<dynamic>.from(recipe['phases'])[0].toString()
                  : (recipe['phase']?.toString() ?? '');

              return GestureDetector(
                onTap: () => _showRecipeDetail(context, recipe),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _getPhaseColor(firstPhase),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(recipe['emoji'] ?? '🍽️', style: const TextStyle(fontSize: 32)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    recipe['tagline'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildInfo(Icons.timer_outlined, prepTime),
                                      const SizedBox(width: 12),
                                      _buildInfo(Icons.local_fire_department_rounded, caloriesText),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ));
    });
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Color _getPhaseColor(String phase) {
    switch (phase.toLowerCase()) {
      case 'menstrual':
        return const Color(0xFFC0392B);
      case 'follicular':
        return const Color(0xFFE67E22);
      case 'ovulatory':
        return const Color(0xFF27AE60);
      case 'luteal':
        return const Color(0xFF8E44AD);
      default:
        return AppColors.primary;
    }
  }
}
