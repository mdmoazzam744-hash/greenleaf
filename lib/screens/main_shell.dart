import 'package:material_ui/material_ui.dart';

import '../models/plant.dart';
import '../state/plant_store.dart';
import '../theme/greenleaf_theme.dart';
import 'add_plant_screen.dart';
import 'home_screen.dart';
import 'my_plants_screen.dart';
import 'plant_details_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.store,
  });

  final PlantStore store;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _openPlantDetails(Plant plant) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlantDetailsScreen(
          store: widget.store,
          plantId: plant.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final dueCount = widget.store.dueTodayCount;

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              HomeScreen(
                store: widget.store,
                onOpenPlant: _openPlantDetails,
                onSeeAllPlants: () => setState(() => _selectedIndex = 1),
              ),
              MyPlantsScreen(
                store: widget.store,
                onOpenPlant: _openPlantDetails,
                onGoToAddPlant: () => setState(() => _selectedIndex = 2),
              ),
              AddPlantScreen(
                store: widget.store,
                onPlantAdded: () => setState(() => _selectedIndex = 0),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: GreenleafColors.pureWhite,
              border: Border(
                top: BorderSide(color: GreenleafColors.mintBorder),
              ),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              backgroundColor: GreenleafColors.pureWhite,
              indicatorColor: GreenleafColors.softYellow,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              height: 68,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: dueCount > 0,
                    backgroundColor: GreenleafColors.primaryGreen,
                    textColor: GreenleafColors.pureWhite,
                    label: Text('$dueCount'),
                    child: const Icon(
                      Icons.home_outlined,
                      color: GreenleafColors.textSecondary,
                    ),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: dueCount > 0,
                    backgroundColor: GreenleafColors.primaryGreen,
                    textColor: GreenleafColors.pureWhite,
                    label: Text('$dueCount'),
                    child: const Icon(
                      Icons.home_rounded,
                      color: GreenleafColors.primaryGreen,
                    ),
                  ),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(
                    Icons.eco_outlined,
                    color: GreenleafColors.textSecondary,
                  ),
                  selectedIcon: Icon(
                    Icons.eco_rounded,
                    color: GreenleafColors.primaryGreen,
                  ),
                  label: 'My Plants',
                ),
                const NavigationDestination(
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: GreenleafColors.textSecondary,
                  ),
                  selectedIcon: Icon(
                    Icons.add_circle_rounded,
                    color: GreenleafColors.primaryGreen,
                  ),
                  label: 'Add Plant',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
