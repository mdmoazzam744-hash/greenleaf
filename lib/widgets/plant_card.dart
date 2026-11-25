import 'package:material_ui/material_ui.dart';

import '../models/plant.dart';
import '../theme/greenleaf_theme.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.onWatered,
    this.showStatusBadge = false,
  });

  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback onWatered;
  final bool showStatusBadge;

  @override
  Widget build(BuildContext context) {
    final needsWater = plant.needsWaterToday;
    final wateredToday = plant.wateredToday;

    return Material(
      color: GreenleafColors.pureWhite,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: needsWater
                  ? GreenleafColors.butterYellow
                  : GreenleafColors.mintBorder,
              width: needsWater ? 1.5 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A1B3A2A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Plant emoji tile
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: needsWater
                      ? GreenleafColors.softYellow
                      : GreenleafColors.mintWash,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  plant.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 12),
              // Plant info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            plant.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: GreenleafColors.textPrimary,
                            ),
                          ),
                        ),
                        if (showStatusBadge) ...[
                          const SizedBox(width: 6),
                          _StatusPill(plant: plant),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.room_outlined,
                          size: 14,
                          color: GreenleafColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            plant.room,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: GreenleafColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop_outlined,
                          size: 13.5,
                          color: GreenleafColors.leafGreen,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            plant.scheduleLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: GreenleafColors.leafGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Watered action button
              _WateredChipButton(
                wateredToday: wateredToday,
                needsWater: needsWater,
                onPressed: onWatered,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    final bgColor = plant.needsWaterToday
        ? GreenleafColors.softYellow
        : GreenleafColors.mintWash;
    final textColor = plant.needsWaterToday
        ? GreenleafColors.warmGoldText
        : GreenleafColors.primaryGreen;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        plant.needsWaterToday
            ? 'Today'
            : (plant.wateredToday ? 'Done' : '${plant.daysUntilWatering}d'),
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _WateredChipButton extends StatelessWidget {
  const _WateredChipButton({
    required this.wateredToday,
    required this.needsWater,
    required this.onPressed,
  });

  final bool wateredToday;
  final bool needsWater;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (wateredToday) {
      return TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: GreenleafColors.softYellow,
          foregroundColor: GreenleafColors.warmGoldText,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.check_circle_rounded, size: 15),
        label: const Text(
          'Watered',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: needsWater
            ? GreenleafColors.primaryGreen
            : GreenleafColors.mintWash,
        foregroundColor: needsWater
            ? GreenleafColors.pureWhite
            : GreenleafColors.primaryGreen,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.water_drop_rounded, size: 14),
      label: const Text(
        'Watered',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
