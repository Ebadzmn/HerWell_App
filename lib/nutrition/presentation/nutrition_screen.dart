import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../widgets/macro_calculator_widget.dart';
import '../widgets/food_library_widget.dart';
import '../widgets/recipe_library_widget.dart';
import '../../home/controller/home_controller.dart';
import '../controller/nutrition_controller.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NutritionController());
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top Section with Gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.homeGradientStart,
                    AppColors.homeGradientMid,
                    AppColors.homeGradientEnd,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF3A2E28), size: 20),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Nutrition',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3A2E28),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Phase Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phase ${homeController.getPhaseNumber()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF3A2E28).withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              homeController.currentPhase.value,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3A2E28),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getPhaseDescription(homeController.getPhaseNumber()),
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF3A2E28).withOpacity(0.7),
                              ),
                            ),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content Section
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      // Tabs
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: const Color(0xFF2D2420),
                          unselectedLabelColor: Colors.grey[600],
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          tabs: const [
                            Tab(text: '🥦 Foods'),
                            Tab(text: '🍽️ Recipes'),
                            Tab(text: '📊 Macros'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        height: 1200,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            const FoodLibraryWidget(),
                            const RecipeLibraryWidget(),
                            _buildCalculatorTab(homeController),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPhaseDescription(int phase) {
    switch (phase) {
      case 1: return "Focus on iron-rich foods and anti-inflammatory ingredients";
      case 2: return "Light, fresh foods to support rising energy levels";
      case 3: return "Fuel your body during your most energetic phase";
      case 4: return "Complex carbs and mood-boosting nutrients";
      default: return "";
    }
  }

  Widget _buildTab(String label) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCalculatorTab(HomeController homeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recommended Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFC8DCC8),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Energy Boosting',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A7A5A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Light, fresh foods to support rising energy levels',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xB24A7A5A), // 0.7 opacity
                ),
              ),
              const SizedBox(height: 20),
              const MacroCalculatorWidget(),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
