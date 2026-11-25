import 'package:material_ui/material_ui.dart';

import '../models/plant.dart';
import '../state/plant_store.dart';
import '../theme/greenleaf_theme.dart';
import '../widgets/happy_message.dart';
import '../widgets/plant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.store,
    required this.onOpenPlant,
    required this.onSeeAllPlants,
  });

  final PlantStore store;
  final void Function(Plant plant) onOpenPlant;
  final VoidCallback onSeeAllPlants;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final todayPlants = store.todayPlants;
        final upcomingPlants = store.upcomingPlants;
        final dueCount = store.dueTodayCount;
        final wateredCount = store.wateredTodayCount;
        final totalToday = store.totalTodayCount;
        final progress = totalToday == 0 ? 1.0 : wateredCount / totalToday;

        return SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand top row
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: GreenleafColors.primaryGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '🌿',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'greenleaf',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: GreenleafColors.primaryGreen,
                                    letterSpacing: -0.5,
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  'Daily plant care companion',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: GreenleafColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: GreenleafColors.softYellow,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: GreenleafColors.butterYellow,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('☀️', style: TextStyle(fontSize: 13)),
                                SizedBox(width: 4),
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: GreenleafColors.warmGoldText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Daily summary hero card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              GreenleafColors.primaryGreen,
                              GreenleafColors.leafGreen,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x222D6A4F),
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dueCount == 0
                                        ? 'All watered for today!'
                                        : '$dueCount ${dueCount == 1 ? 'plant needs' : 'plants need'} water today',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: GreenleafColors.pureWhite,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: GreenleafColors.softYellow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$wateredCount/$totalToday',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: GreenleafColors.warmGoldText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dueCount == 0
                                  ? 'Your leafy friends are hydrated, happy, and glowing.'
                                  : 'Tap "Watered" after giving each plant a refreshing drink.',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xE6FFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 9,
                                backgroundColor: const Color(0x33FFFFFF),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  GreenleafColors.butterYellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Section heading
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Today's Plants to Water",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: GreenleafColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: GreenleafColors.softYellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$dueCount left',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: GreenleafColors.warmGoldText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (todayPlants.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: GreenleafColors.pureWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: GreenleafColors.mintBorder),
                      ),
                      child: const Column(
                        children: [
                          Text('🌞', style: TextStyle(fontSize: 40)),
                          SizedBox(height: 10),
                          Text(
                            'No plants need watering today!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: GreenleafColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sit back and enjoy your calm green space.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: GreenleafColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.separated(
                    itemCount: todayPlants.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final plant = todayPlants[index];
                      return PlantCard(
                        plant: plant,
                        onTap: () => onOpenPlant(plant),
                        onWatered: () {
                          final msg = store.waterPlant(plant.id);
                          showHappyMessage(context, msg);
                        },
                      );
                    },
                  ),
                ),
              if (upcomingPlants.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Coming Up Later',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: GreenleafColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: onSeeAllPlants,
                          style: TextButton.styleFrom(
                            foregroundColor: GreenleafColors.primaryGreen,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 106,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: upcomingPlants.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final plant = upcomingPlants[index];
                        return _UpcomingPlantMiniCard(
                          plant: plant,
                          onTap: () => onOpenPlant(plant),
                        );
                      },
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}

class _UpcomingPlantMiniCard extends StatelessWidget {
  const _UpcomingPlantMiniCard({
    required this.plant,
    required this.onTap,
  });

  final Plant plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GreenleafColors.pureWhite,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: GreenleafColors.mintBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(plant.emoji, style: const TextStyle(fontSize: 22)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: GreenleafColors.mintWash,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'In ${plant.daysUntilWatering}d',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: GreenleafColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: GreenleafColors.textPrimary,
                    ),
                  ),
                  Text(
                    plant.room,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: GreenleafColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
