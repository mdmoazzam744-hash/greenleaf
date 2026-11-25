class Plant {
  const Plant({
    required this.id,
    required this.name,
    required this.emoji,
    required this.room,
    required this.waterEveryDays,
    required this.daysUntilWatering,
    required this.wateredToday,
    required this.lastWatered,
    required this.sunlight,
    required this.careTip,
  });

  final String id;
  final String name;
  final String emoji;
  final String room;
  final int waterEveryDays;
  final int daysUntilWatering;
  final bool wateredToday;
  final DateTime lastWatered;
  final String sunlight;
  final String careTip;

  bool get needsWaterToday => !wateredToday && daysUntilWatering <= 0;

  bool get isOnTodaySchedule => wateredToday || daysUntilWatering <= 0;

  String get scheduleLabel => waterEveryDays == 1
      ? 'Water every 1 day'
      : 'Water every $waterEveryDays days';

  String get statusLabel {
    if (wateredToday) {
      return 'Watered today';
    }
    if (daysUntilWatering <= 0) {
      return 'Needs water today';
    }
    if (daysUntilWatering == 1) {
      return 'Water tomorrow';
    }
    return 'Water in $daysUntilWatering days';
  }

  String get lastWateredLabel {
    if (wateredToday) {
      return 'Today';
    }
    final daysAgo = DateTime.now().difference(lastWatered).inDays;
    if (daysAgo <= 0) {
      return 'Today';
    }
    if (daysAgo == 1) {
      return 'Yesterday';
    }
    return '$daysAgo days ago';
  }

  Plant copyWith({
    String? id,
    String? name,
    String? emoji,
    String? room,
    int? waterEveryDays,
    int? daysUntilWatering,
    bool? wateredToday,
    DateTime? lastWatered,
    String? sunlight,
    String? careTip,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      room: room ?? this.room,
      waterEveryDays: waterEveryDays ?? this.waterEveryDays,
      daysUntilWatering: daysUntilWatering ?? this.daysUntilWatering,
      wateredToday: wateredToday ?? this.wateredToday,
      lastWatered: lastWatered ?? this.lastWatered,
      sunlight: sunlight ?? this.sunlight,
      careTip: careTip ?? this.careTip,
    );
  }
}

List<Plant> buildSamplePlants() {
  final now = DateTime.now();
  return [
    Plant(
      id: 'money-plant',
      name: 'Money Plant',
      emoji: '🍀',
      room: 'Living Room',
      waterEveryDays: 3,
      daysUntilWatering: 0,
      wateredToday: false,
      lastWatered: now.subtract(const Duration(days: 3)),
      sunlight: 'Bright indirect light',
      careTip: 'Let the top inch of soil dry slightly between waterings and wipe the glossy leaves gently.',
    ),
    Plant(
      id: 'aloe-vera',
      name: 'Aloe Vera',
      emoji: '🪴',
      room: 'Bedroom Sill',
      waterEveryDays: 14,
      daysUntilWatering: 5,
      wateredToday: false,
      lastWatered: now.subtract(const Duration(days: 9)),
      sunlight: 'Warm sunny window',
      careTip: 'Water deeply but infrequently, and make sure the pot drains well so roots stay crisp.',
    ),
    Plant(
      id: 'snake-plant',
      name: 'Snake Plant',
      emoji: '🌿',
      room: 'Bedroom',
      waterEveryDays: 10,
      daysUntilWatering: 3,
      wateredToday: false,
      lastWatered: now.subtract(const Duration(days: 7)),
      sunlight: 'Low to bright light',
      careTip: 'Thrives on gentle neglect—avoid pouring water into the centre rosette of leaves.',
    ),
    Plant(
      id: 'tulsi',
      name: 'Tulsi',
      emoji: '🌱',
      room: 'Balcony',
      waterEveryDays: 1,
      daysUntilWatering: 0,
      wateredToday: false,
      lastWatered: now.subtract(const Duration(days: 1)),
      sunlight: 'Direct morning sun',
      careTip: 'Keep the soil evenly moist and pinch off flower spikes to encourage lush fragrant leaves.',
    ),
    Plant(
      id: 'rose',
      name: 'Rose',
      emoji: '🌹',
      room: 'Garden',
      waterEveryDays: 2,
      daysUntilWatering: 0,
      wateredToday: false,
      lastWatered: now.subtract(const Duration(days: 2)),
      sunlight: 'Full sunlight (6+ hrs)',
      careTip: 'Water at the base in the morning rather than on the petals to keep blooms fresh and vibrant.',
    ),
    Plant(
      id: 'mint',
      name: 'Mint',
      emoji: '🍃',
      room: 'Kitchen',
      waterEveryDays: 2,
      daysUntilWatering: 0,
      wateredToday: false,
      lastWatered: now.subtract(const Duration(days: 2)),
      sunlight: 'Partial sun to bright light',
      careTip: 'Loves consistently damp soil and regular snipping from the top for bushy regrowth.',
    ),
    Plant(
      id: 'peace-lily',
      name: 'Peace Lily',
      emoji: '🌸',
      room: 'Living Room',
      waterEveryDays: 4,
      daysUntilWatering: 0,
      wateredToday: false,
      lastWatered: now.subtract(const Duration(days: 4)),
      sunlight: 'Soft filtered shade',
      careTip: 'Droops dramatically when thirsty and perks right back up soon after a refreshing drink.',
    ),
    Plant(
      id: 'cactus',
      name: 'Cactus',
      emoji: '🌵',
      room: 'Study Desk',
      waterEveryDays: 21,
      daysUntilWatering: 12,
      wateredToday: false,
      lastWatered: now.subtract(const Duration(days: 9)),
      sunlight: 'Direct bright sunlight',
      careTip: 'Allow the sandy soil to dry completely before watering lightly around the base.',
    ),
  ];
}
