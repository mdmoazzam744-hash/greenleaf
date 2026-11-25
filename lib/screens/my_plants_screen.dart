import 'package:material_ui/material_ui.dart';

import '../models/plant.dart';
import '../state/plant_store.dart';
import '../theme/greenleaf_theme.dart';
import '../widgets/happy_message.dart';
import '../widgets/plant_card.dart';

class MyPlantsScreen extends StatefulWidget {
  const MyPlantsScreen({
    super.key,
    required this.store,
    required this.onOpenPlant,
    required this.onGoToAddPlant,
  });

  final PlantStore store;
  final void Function(Plant plant) onOpenPlant;
  final VoidCallback onGoToAddPlant;

  @override
  State<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {
  String _selectedRoom = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final rooms = widget.store.rooms;
        if (!rooms.contains(_selectedRoom)) {
          _selectedRoom = 'All';
        }

        final filtered = widget.store.plants.where((plant) {
          final matchesRoom =
              _selectedRoom == 'All' || plant.room == _selectedRoom;
          final q = _query.trim().toLowerCase();
          final matchesQuery = q.isEmpty ||
              plant.name.toLowerCase().contains(q) ||
              plant.room.toLowerCase().contains(q);
          return matchesRoom && matchesQuery;
        }).toList();

        return SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'My Plants',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: GreenleafColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: GreenleafColors.softYellow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: GreenleafColors.butterYellow,
                        ),
                      ),
                      child: Text(
                        '${widget.store.plants.length} plants',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: GreenleafColors.warmGoldText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Search box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (val) => setState(() => _query = val),
                  decoration: const InputDecoration(
                    hintText: 'Search by plant or room...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: GreenleafColors.leafGreen,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Room filter chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: rooms.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    final selected = room == _selectedRoom;
                    return ChoiceChip(
                      label: Text(room),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedRoom = room),
                      showCheckmark: false,
                      selectedColor: GreenleafColors.primaryGreen,
                      backgroundColor: GreenleafColors.pureWhite,
                      side: BorderSide(
                        color: selected
                            ? GreenleafColors.primaryGreen
                            : GreenleafColors.mintBorder,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? GreenleafColors.pureWhite
                            : GreenleafColors.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Plant list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🌱', style: TextStyle(fontSize: 42)),
                              const SizedBox(height: 10),
                              const Text(
                                'No matching plants found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: GreenleafColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Try another room or add a new plant to your collection.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: GreenleafColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton.icon(
                                onPressed: widget.onGoToAddPlant,
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: const Text('Add Plant'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        key: const Key('my-plants-list'),
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final plant = filtered[index];
                          return PlantCard(
                            plant: plant,
                            showStatusBadge: true,
                            onTap: () => widget.onOpenPlant(plant),
                            onWatered: () {
                              final msg = widget.store.waterPlant(plant.id);
                              showHappyMessage(context, msg);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
