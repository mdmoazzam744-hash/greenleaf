import 'package:material_ui/material_ui.dart';

import '../state/plant_store.dart';
import '../theme/greenleaf_theme.dart';
import '../widgets/happy_message.dart';

class PlantDetailsScreen extends StatefulWidget {
  const PlantDetailsScreen({
    super.key,
    required this.store,
    required this.plantId,
  });

  final PlantStore store;
  final String plantId;

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  String? _inlineHappyBanner;

  Future<void> _confirmDelete(BuildContext context, String plantName) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: GreenleafColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Remove $plantName?',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: GreenleafColors.textPrimary,
            ),
          ),
          content: const Text(
            'This will remove the plant from your greenleaf collection.',
            style: TextStyle(color: GreenleafColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: GreenleafColors.pureWhite,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      widget.store.deletePlant(widget.plantId);
      Navigator.of(context).pop();
      showHappyMessage(context, 'Removed $plantName from your plants.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final plant = widget.store.getById(widget.plantId);
        if (plant == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Plant Details')),
            body: const Center(child: Text('Plant not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
            title: const Text('Plant Details'),
            actions: [
              IconButton(
                tooltip: 'Remove plant',
                onPressed: () => _confirmDelete(context, plant.name),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: GreenleafColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              // Hero botanical card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      GreenleafColors.softYellow,
                      GreenleafColors.mintWash,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: GreenleafColors.mintBorder),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 108,
                      height: 108,
                      decoration: const BoxDecoration(
                        color: GreenleafColors.pureWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x162D6A4F),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        plant.emoji,
                        style: const TextStyle(fontSize: 56),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      plant.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: GreenleafColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _DetailTag(
                          icon: Icons.room_outlined,
                          label: plant.room,
                          backgroundColor: GreenleafColors.pureWhite,
                          foregroundColor: GreenleafColors.textPrimary,
                        ),
                        _DetailTag(
                          icon: plant.wateredToday
                              ? Icons.check_circle_rounded
                              : Icons.water_drop_rounded,
                          label: plant.statusLabel,
                          backgroundColor: plant.needsWaterToday
                              ? GreenleafColors.butterYellow
                              : GreenleafColors.primaryGreen,
                          foregroundColor: plant.needsWaterToday
                              ? GreenleafColors.warmGoldText
                              : GreenleafColors.pureWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_inlineHappyBanner != null) ...[
                const SizedBox(height: 14),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: GreenleafColors.softYellow,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: GreenleafColors.butterYellow,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _inlineHappyBanner!,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: GreenleafColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              // Care stats grid (2x2)
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.calendar_today_rounded,
                      iconBg: GreenleafColors.mintWash,
                      iconColor: GreenleafColors.primaryGreen,
                      title: 'Schedule',
                      value: plant.scheduleLabel,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.history_rounded,
                      iconBg: GreenleafColors.softYellow,
                      iconColor: GreenleafColors.warmGoldText,
                      title: 'Last Watered',
                      value: plant.lastWateredLabel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.wb_sunny_rounded,
                      iconBg: GreenleafColors.softYellow,
                      iconColor: GreenleafColors.warmGoldText,
                      title: 'Sunlight',
                      value: plant.sunlight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.home_outlined,
                      iconBg: GreenleafColors.mintWash,
                      iconColor: GreenleafColors.primaryGreen,
                      title: 'Room',
                      value: plant.room,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Care Tip Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GreenleafColors.pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GreenleafColors.mintBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: GreenleafColors.softYellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Text('💡', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Care Tip',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: GreenleafColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      plant.careTip,
                      style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: GreenleafColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: GreenleafColors.pureWhite,
                border: Border(
                  top: BorderSide(color: GreenleafColors.mintBorder),
                ),
              ),
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final msg = widget.store.waterPlant(plant.id);
                    setState(() => _inlineHappyBanner = msg);
                    showHappyMessage(context, msg);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plant.wateredToday
                        ? GreenleafColors.leafGreen
                        : GreenleafColors.primaryGreen,
                    foregroundColor: GreenleafColors.pureWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(
                    plant.wateredToday
                        ? Icons.check_circle_rounded
                        : Icons.water_drop_rounded,
                    size: 20,
                  ),
                  label: Text(
                    plant.wateredToday ? 'Watered Today ✓' : 'Watered',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DetailTag extends StatelessWidget {
  const _DetailTag({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GreenleafColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GreenleafColors.mintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: GreenleafColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: GreenleafColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
