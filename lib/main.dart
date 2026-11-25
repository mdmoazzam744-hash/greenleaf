import 'package:material_ui/material_ui.dart';

import 'screens/main_shell.dart';
import 'state/plant_store.dart';
import 'theme/greenleaf_theme.dart';
import 'widgets/phone_frame_wrapper.dart';

void main() {
  runApp(const GreenleafApp());
}

class GreenleafApp extends StatefulWidget {
  const GreenleafApp({super.key});

  @override
  State<GreenleafApp> createState() => _GreenleafAppState();
}

class _GreenleafAppState extends State<GreenleafApp> {
  final PlantStore _store = PlantStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'greenleaf',
      debugShowCheckedModeBanner: false,
      theme: GreenleafTheme.theme,
      builder: (context, child) {
        return PhoneFrameWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: MainShell(store: _store),
    );
  }
}
