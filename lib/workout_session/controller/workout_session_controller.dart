import 'package:get/get.dart';

class ExerciseSetModel {
  RxDouble weight;
  RxInt reps;
  ExerciseSetModel({required double weight, required int reps})
      : weight = weight.obs,
        reps = reps.obs;
}

class ExerciseModel {
  String name;
  RxList<ExerciseSetModel> sets;
  ExerciseModel({required this.name, required List<ExerciseSetModel> sets})
      : sets = sets.obs;
}

class WorkoutSessionController extends GetxController {
  final exercises = <ExerciseModel>[
    ExerciseModel(
      name: 'Walk',
      sets: [ExerciseSetModel(weight: 0.0, reps: 0)],
    ),
    ExerciseModel(
      name: 'Light Jog',
      sets: [ExerciseSetModel(weight: 0.0, reps: 0)],
    ),
  ].obs;

  final totalVolume = '0 kg'.obs;
  final vsLastTime = '0%'.obs;

  void addSet(int exerciseIndex) {
    final sets = exercises[exerciseIndex].sets;
    final lastSet = sets.isNotEmpty 
        ? sets.last 
        : ExerciseSetModel(weight: 0.0, reps: 0);
    sets.add(ExerciseSetModel(
      weight: lastSet.weight.value, 
      reps: lastSet.reps.value
    ));
  }
}
