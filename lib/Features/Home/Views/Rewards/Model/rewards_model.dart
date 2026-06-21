class RewardStepModel {
  final String coins;
  final String time;

  RewardStepModel({required this.coins, required this.time});
}

class BenefitTaskModel {
  final String title;
  final String? titleSuffix;
  final String? subtitle;
  final String? coinsLabel;
  String buttonText;
  final bool isHighlight;
  final String layoutType; // 'subtitle_coins' or 'top_coins'
  final bool isClaimed;
  final List<RewardStepModel>? steps;

  BenefitTaskModel({
    required this.title,
    this.titleSuffix,
    this.subtitle,
    this.coinsLabel,
    required this.buttonText,
    this.isHighlight = false,
    this.layoutType = 'top_coins',
    this.isClaimed = false,
    this.steps,
  });
}
