import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class RecipeLibraryWidget extends StatelessWidget {
  const RecipeLibraryWidget({super.key});

  final List<Map<String, dynamic>> _recipes = const [
    {
      'name': 'Iron-Rich Lentil Soup',
      'emoji': '🥣',
      'cals': 320,
      'time': '25 min',
      'phase': 'Menstrual',
      'tagline': 'Perfect for iron replenishment',
    },
    {
      'name': 'Grilled Chicken Salad',
      'emoji': '🥗',
      'cals': 380,
      'time': '15 min',
      'phase': 'Follicular',
      'tagline': 'Light and energy boosting',
    },
    {
      'name': 'Salmon & Asparagus',
      'emoji': '🐟',
      'cals': 420,
      'time': '20 min',
      'phase': 'Ovulatory',
      'tagline': 'Peak nutrition for peak performance',
    },
    {
      'name': 'Sweet Potato Curry',
      'emoji': '🍛',
      'cals': 380,
      'time': '30 min',
      'phase': 'Luteal',
      'tagline': 'Comforting and serotonin boosting',
    },
  ];

  void _showRecipeDetail(BuildContext context, Map<String, dynamic> recipe) {
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
                  Text(recipe['emoji'], style: const TextStyle(fontSize: 48)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recipe['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text(recipe['tagline'], style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailTag(Icons.timer_outlined, recipe['time']),
                  _buildDetailTag(Icons.local_fire_department_rounded, '${recipe['cals']} kcal'),
                  _buildDetailTag(Icons.spa_rounded, recipe['phase']),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              const Text('• 1 cup red lentils\n• 1 large onion, chopped\n• 2 carrots, diced\n• 2 cloves garlic, minced\n• 1 tsp turmeric\n• 1 tsp ginger', style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary)),
              const SizedBox(height: 32),
              const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              const Text('1. Rinse lentils thoroughly.\n2. Sauté onion, carrots, and garlic in a large pot.\n3. Add spices and lentils, then pour in vegetable broth.\n4. Simmer for 20-25 minutes until lentils are tender.\n5. Blend a portion for creamier texture if desired.', style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary)),
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
    return Column(
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
          itemCount: _recipes.length,
          itemBuilder: (context, index) {
            final recipe = _recipes[index];
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
                        color: _getPhaseColor(recipe['phase']),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(recipe['emoji'], style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  recipe['tagline'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildInfo(Icons.timer_outlined, recipe['time']),
                                    const SizedBox(width: 12),
                                    _buildInfo(Icons.local_fire_department_rounded, '${recipe['cals']} kcal'),
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
    );
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
    switch (phase) {
      case 'Menstrual':
        return const Color(0xFFC0392B);
      case 'Follicular':
        return const Color(0xFFE67E22);
      case 'Ovulatory':
        return const Color(0xFF27AE60);
      case 'Luteal':
        return const Color(0xFF8E44AD);
      default:
        return AppColors.primary;
    }
  }
}
