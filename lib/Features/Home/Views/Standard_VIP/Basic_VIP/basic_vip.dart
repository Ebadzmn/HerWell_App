import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widget/subscribe_widgets.dart';
import 'Controller/basic_vip_controller.dart';

class BasicVip extends StatelessWidget {
  const BasicVip({super.key});

  @override
  Widget build(BuildContext context) {
    final BasicVipController controller = Get.put(BasicVipController());

    return Column(
      children: [
        ...controller.basicPlans.map((plan) => SubscribeCard(plan: plan)),
        MovieGrid(movies: controller.bestMovies, title: "Best Movies"),
        MovieGrid(movies: controller.comingSoonMovies, title: "Coming Soon"),
      ],
    );
  }
}
