import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class FoodLibraryWidget extends StatefulWidget {
  const FoodLibraryWidget({super.key});

  @override
  State<FoodLibraryWidget> createState() => _FoodLibraryWidgetState();
}

class _FoodLibraryWidgetState extends State<FoodLibraryWidget> {
  String _selectedPhase = 'all';
  String _selectedCategory = 'all';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _foods = [
    {"id":1,"emoji":"🥩","name":"Beef (lean)","cat":"protein","phases":["menstrual","follicular","ovulatory","luteal"],"why":"Rich in haem iron — the most absorbable form. Critical during menstruation to replace blood iron losses.","macros":{"cal":"215","pro":"26g","carb":"0g","fat":"12g"}},
    {"id":2,"emoji":"🐟","name":"Salmon","cat":"protein","phases":["menstrual","luteal","follicular"],"why":"Exceptional source of omega-3 fatty acids (EPA/DHA) which directly reduce prostaglandin-driven inflammation.","macros":{"cal":"208","pro":"20g","carb":"0g","fat":"13g"}},
    {"id":3,"emoji":"🐓","name":"Chicken Breast","cat":"protein","phases":["follicular","ovulatory","luteal"],"why":"Lean, complete protein supporting muscle protein synthesis. High in B6 which supports serotonin production.","macros":{"cal":"165","pro":"31g","carb":"0g","fat":"3.6g"}},
    {"id":4,"emoji":"🥚","name":"Eggs","cat":"protein","phases":["follicular","ovulatory","menstrual","luteal"],"why":"Complete protein with all essential amino acids. Rich in choline, B12, and vitamin D.","macros":{"cal":"155","pro":"13g","carb":"1g","fat":"11g"}},
    {"id":5,"emoji":"🫘","name":"Lentils","cat":"protein","phases":["menstrual","luteal","follicular"],"why":"Non-haem iron paired with folate — critical for blood replenishment during menstruation.","macros":{"cal":"116","pro":"9g","carb":"20g","fat":"0.4g"}},
    {"id":11,"emoji":"🍠","name":"Sweet Potato","cat":"carbs","phases":["luteal","menstrual","follicular"],"why":"Complex carbohydrate that raises serotonin — directly addressing luteal-phase mood dips.","macros":{"cal":"86","pro":"1.6g","carb":"20g","fat":"0.1g"}},
    {"id":16,"emoji":"🥑","name":"Avocado","cat":"fats","phases":["luteal","menstrual","follicular","ovulatory"],"why":"Monounsaturated fats are building blocks for steroid hormones. Rich in B5, vitamin E, and potassium.","macros":{"cal":"160","pro":"2g","carb":"9g","fat":"15g"}},
    {"id":23,"emoji":"🥦","name":"Broccoli","cat":"veg","phases":["ovulatory","follicular","luteal"],"why":"Contains DIM which supports healthy oestrogen metabolism. Sulforaphane activates anti-inflammatory pathways.","macros":{"cal":"34","pro":"2.8g","carb":"7g","fat":"0.4g"}},
    {"id":31,"emoji":"🫐","name":"Blueberries","cat":"fruit","phases":["menstrual","ovulatory","luteal"],"why":"Anthocyanins are among the most potent antioxidants — protect eggs from oxidative damage.","macros":{"cal":"57","pro":"0.7g","carb":"14g","fat":"0.3g"}},
    {"id":40,"emoji":"🍫","name":"Dark Chocolate","cat":"supplements","phases":["luteal","menstrual"],"why":"Magnesium content rivals supplements — directly reduces cramping and mood symptoms.","macros":{"cal":"598","pro":"8g","carb":"46g","fat":"43g"}},
  ];

  final Map<String, String> _phaseLabels = {
    'all': 'All Phases',
    'menstrual': '🩸 Menstrual',
    'follicular': '🌱 Follicular',
    'ovulatory': '✨ Ovulatory',
    'luteal': '🌕 Luteal'
  };

  final Map<String, Color> _phaseColors = {
    'menstrual': const Color(0xFFe67c65),
    'follicular': const Color(0xFFe8b056),
    'ovulatory': const Color(0xFF5BA89D),
    'luteal': const Color(0xFF9b6fd4),
  };

  final Map<String, String> _categoryLabels = {
    'all': 'All Categories',
    'protein': 'Protein',
    'carbs': 'Carbs',
    'fats': 'Fats',
    'veg': 'Veg',
    'fruit': 'Fruit',
    'dairy': 'Dairy',
    'supplements': 'Supplements'
  };

  void _showFilterModal({required bool isPhase}) {
    final title = isPhase ? 'Filter by phase' : 'Filter by category';
    final options = isPhase ? _phaseLabels : _categoryLabels;
    final currentValue = isPhase ? _selectedPhase : _selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2420),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.grey, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Options list
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, index) {
                    final key = options.keys.elementAt(index);
                    final value = options.values.elementAt(index);
                    final isSelected = key == currentValue;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isPhase) {
                            _selectedPhase = key;
                          } else {
                            _selectedCategory = key;
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        color: isSelected ? const Color(0xFFFDF8F5) : Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? const Color(0xFF5C4A3A) : const Color(0xFF2D2420),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check, color: Color(0xFF5C4A3A), size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _foods.where((food) {
      final matchPhase = _selectedPhase == 'all' || food['phases'].contains(_selectedPhase);
      final matchCat = _selectedCategory == 'all' || food['cat'] == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty || 
          food['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchPhase && matchCat && matchSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdowns Row
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showFilterModal(isPhase: true),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EFEA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _phaseLabels[_selectedPhase]!,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF3A2E28)),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF3A2E28)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _showFilterModal(isPhase: false),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EFEA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _categoryLabels[_selectedCategory]!,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF3A2E28)),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF3A2E28)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Search bar
        TextField(
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search foods...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B7355)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B7355)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B7355), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Count text
        Text(
          '${filteredFoods.length} foods',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5C4A3A)),
        ),
        const SizedBox(height: 12),

        // Food List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: filteredFoods.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final food = filteredFoods[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(food['emoji'], style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              food['name'],
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D2420)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EFEA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                food['cat'],
                                style: const TextStyle(fontSize: 11, color: Color(0xFF5C4A3A)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: (food['phases'] as List<dynamic>).map((p) {
                            final phase = p.toString();
                            final pColor = _phaseColors[phase] ?? Colors.grey;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: pColor.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                phase,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: pColor),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
