import 'package:material_ui/material_ui.dart';

import '../state/plant_store.dart';
import '../theme/greenleaf_theme.dart';
import '../widgets/happy_message.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({
    super.key,
    required this.store,
    required this.onPlantAdded,
  });

  final PlantStore store;
  final VoidCallback onPlantAdded;

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController(text: 'Living Room');
  final _careTipController = TextEditingController();

  static const List<String> _emojiChoices = [
    '🪴',
    '🍀',
    '🌿',
    '🌱',
    '🌹',
    '🍃',
    '🌸',
    '🌵',
    '🌻',
    '🌷',
    '🌺',
    '🌴',
  ];

  static const List<String> _suggestedRooms = [
    'Living Room',
    'Bedroom',
    'Balcony',
    'Kitchen',
    'Garden',
    'Study Desk',
  ];

  String _selectedEmoji = '🪴';
  int _waterEveryDays = 3;
  bool _needsWaterToday = true;

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    _careTipController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final plant = widget.store.addPlant(
      name: _nameController.text,
      emoji: _selectedEmoji,
      room: _roomController.text,
      waterEveryDays: _waterEveryDays,
      needsWaterToday: _needsWaterToday,
      careTip: _careTipController.text,
    );

    showHappyMessage(
      context,
      '${plant.emoji} Welcome, ${plant.name}! Added to your greenleaf garden.',
    );

    _nameController.clear();
    _careTipController.clear();
    setState(() {
      _selectedEmoji = '🪴';
      _roomController.text = 'Living Room';
      _waterEveryDays = 3;
      _needsWaterToday = true;
    });

    widget.onPlantAdded();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleText = _waterEveryDays == 1
        ? 'Water every 1 day'
        : 'Water every $_waterEveryDays days';

    return SafeArea(
      bottom: false,
      child: Form(
        key: _formKey,
        child: ListView(
          key: const Key('add-plant-list'),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          children: [
            const Text(
              'Add Plant',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: GreenleafColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Add a new leafy friend to track its watering routine.',
              style: TextStyle(
                fontSize: 13,
                color: GreenleafColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            // Emoji picker
            const Text(
              'Pick a Plant Emoji',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: GreenleafColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GreenleafColors.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: GreenleafColors.mintBorder),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _emojiChoices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final emoji = _emojiChoices[index];
                  final selected = emoji == _selectedEmoji;
                  return InkWell(
                    onTap: () => setState(() => _selectedEmoji = emoji),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      decoration: BoxDecoration(
                        color: selected
                            ? GreenleafColors.softYellow
                            : GreenleafColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? GreenleafColors.primaryGreen
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Plant Name
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Plant Name',
                hintText: 'e.g. Monstera, Lavender, Basil',
                prefixIcon: Icon(
                  Icons.eco_outlined,
                  color: GreenleafColors.leafGreen,
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a plant name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Room
            TextFormField(
              controller: _roomController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Room',
                hintText: 'e.g. Living Room, Balcony',
                prefixIcon: Icon(
                  Icons.room_outlined,
                  color: GreenleafColors.leafGreen,
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a room';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _suggestedRooms.map((room) {
                final isSelected = _roomController.text.trim() == room;
                return ActionChip(
                  label: Text(room),
                  onPressed: () {
                    setState(() => _roomController.text = room);
                  },
                  backgroundColor: isSelected
                      ? GreenleafColors.softYellow
                      : GreenleafColors.pureWhite,
                  side: BorderSide(
                    color: isSelected
                        ? GreenleafColors.butterYellow
                        : GreenleafColors.mintBorder,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? GreenleafColors.warmGoldText
                        : GreenleafColors.textSecondary,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Watering frequency card
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
                      const Expanded(
                        child: Text(
                          'Watering Schedule',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: GreenleafColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: GreenleafColors.softYellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          scheduleText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: GreenleafColors.warmGoldText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StepperButton(
                        icon: Icons.remove_rounded,
                        onPressed: _waterEveryDays > 1
                            ? () => setState(() => _waterEveryDays--)
                            : null,
                      ),
                      Expanded(
                        child: Slider(
                          value: _waterEveryDays.toDouble(),
                          min: 1,
                          max: 30,
                          divisions: 29,
                          activeColor: GreenleafColors.primaryGreen,
                          inactiveColor: GreenleafColors.mintWash,
                          onChanged: (val) =>
                              setState(() => _waterEveryDays = val.round()),
                        ),
                      ),
                      _StepperButton(
                        icon: Icons.add_rounded,
                        onPressed: _waterEveryDays < 30
                            ? () => setState(() => _waterEveryDays++)
                            : null,
                      ),
                    ],
                  ),
                  const Divider(height: 18, color: GreenleafColors.mintWash),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Include in today\'s watering list',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: GreenleafColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch.adaptive(
                        value: _needsWaterToday,
                        activeTrackColor: GreenleafColors.primaryGreen,
                        onChanged: (val) =>
                            setState(() => _needsWaterToday = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Optional Care Note
            TextFormField(
              controller: _careTipController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Care Note (optional)',
                hintText: 'e.g. Likes morning misting on leaves',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                label: const Text(
                  'Save Plant',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: onPressed == null
              ? GreenleafColors.scaffoldBg
              : GreenleafColors.mintWash,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onPressed == null
              ? GreenleafColors.textSecondary
              : GreenleafColors.primaryGreen,
        ),
      ),
    );
  }
}
