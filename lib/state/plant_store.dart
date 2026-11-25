import 'package:material_ui/material_ui.dart';

import '../models/plant.dart';

class PlantStore extends ChangeNotifier {
  PlantStore() : _plants = buildSamplePlants();

  final List<Plant> _plants;
  int _happyIndex = 0;

  List<Plant> get plants => List.unmodifiable(_plants);

  List<Plant> get todayPlants {
    final list = _plants.where((p) => p.isOnTodaySchedule).toList();
    list.sort((a, b) {
      if (a.needsWaterToday != b.needsWaterToday) {
        return a.needsWaterToday ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return list;
  }

  List<Plant> get upcomingPlants {
    final list = _plants.where((p) => !p.isOnTodaySchedule).toList();
    list.sort((a, b) => a.daysUntilWatering.compareTo(b.daysUntilWatering));
    return list;
  }

  int get dueTodayCount => _plants.where((p) => p.needsWaterToday).length;

  int get wateredTodayCount => _plants.where((p) => p.wateredToday).length;

  int get totalTodayCount => todayPlants.length;

  List<String> get rooms {
    final unique = <String>{};
    for (final plant in _plants) {
      unique.add(plant.room);
    }
    final sorted = unique.toList()..sort();
    return ['All', ...sorted];
  }

  Plant? getById(String id) {
    for (final plant in _plants) {
      if (plant.id == id) return plant;
    }
    return null;
  }

  String waterPlant(String id) {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index == -1) return 'Happy watering!';

    final plant = _plants[index];
    _plants[index] = plant.copyWith(
      wateredToday: true,
      daysUntilWatering: plant.waterEveryDays,
      lastWatered: DateTime.now(),
    );
    notifyListeners();

    final messages = [
      'Yay! ${plant.name} is happy and hydrated! 💧✨',
      'Fresh & thriving! ${plant.name} loved that drink! 🌿💛',
      'Splish splash! ${plant.name} says thank you! 🌱😊',
      'Sunshine & sips! ${plant.name} is glowing today! ☀️💧',
    ];
    final message = messages[_happyIndex % messages.length];
    _happyIndex++;
    return message;
  }

  Plant addPlant({
    required String name,
    required String emoji,
    required String room,
    required int waterEveryDays,
    required bool needsWaterToday,
    String? careTip,
    String? sunlight,
  }) {
    final now = DateTime.now();
    final plant = Plant(
      id: 'plant-${now.microsecondsSinceEpoch}',
      name: name.trim(),
      emoji: emoji,
      room: room.trim(),
      waterEveryDays: waterEveryDays,
      daysUntilWatering: needsWaterToday ? 0 : waterEveryDays,
      wateredToday: false,
      lastWatered: needsWaterToday
          ? now.subtract(Duration(days: waterEveryDays))
          : now,
      sunlight: (sunlight == null || sunlight.trim().isEmpty)
          ? 'Bright indirect light'
          : sunlight.trim(),
      careTip: (careTip == null || careTip.trim().isEmpty)
          ? 'Check the top of the soil before watering and enjoy watching it grow.'
          : careTip.trim(),
    );
    _plants.insert(0, plant);
    notifyListeners();
    return plant;
  }

  void deletePlant(String id) {
    _plants.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
