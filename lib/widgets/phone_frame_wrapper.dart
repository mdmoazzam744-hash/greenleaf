import 'package:material_ui/material_ui.dart';

import '../theme/greenleaf_theme.dart';

class PhoneFrameWrapper extends StatelessWidget {
  const PhoneFrameWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  static const double _phoneWidth = 390;
  static const double _phoneHeight = 844;
  static const double _desktopBreakpoint = 520;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktopViewport = constraints.maxWidth > _desktopBreakpoint;

        if (!isDesktopViewport) {
          return ScaffoldMessenger(child: child);
        }

        final outerMediaQuery = MediaQuery.of(context);
        final simulatedMediaQuery = outerMediaQuery.copyWith(
          size: const Size(_phoneWidth, _phoneHeight),
          padding: const EdgeInsets.only(top: 44, bottom: 18),
          viewPadding: const EdgeInsets.only(top: 44, bottom: 18),
          viewInsets: EdgeInsets.zero,
        );

        return ColoredBox(
          color: GreenleafColors.desktopBackdrop,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _PhoneHardwareShell(
                  child: MediaQuery(
                    data: simulatedMediaQuery,
                    child: SizedBox(
                      width: _phoneWidth,
                      height: _phoneHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(42),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ScaffoldMessenger(child: child),
                            ),
                            const Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: _PhoneStatusBarAndNotch(),
                            ),
                            const Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: IgnorePointer(
                                child: Center(
                                  child: _HomeIndicator(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

class _PhoneHardwareShell extends StatelessWidget {
  const _PhoneHardwareShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Subtle left side buttons
        Positioned(
          left: -3,
          top: 130,
          child: _SideButton(height: 28),
        ),
        Positioned(
          left: -3,
          top: 180,
          child: _SideButton(height: 52),
        ),
        Positioned(
          left: -3,
          top: 244,
          child: _SideButton(height: 52),
        ),
        // Subtle right power button
        Positioned(
          right: -3,
          top: 196,
          child: _SideButton(height: 76),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GreenleafColors.phoneBezel,
            borderRadius: BorderRadius.circular(54),
            border: Border.all(
              color: const Color(0xFF3A3A3F),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 40,
                offset: Offset(0, 22),
              ),
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F34),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _PhoneStatusBarAndNotch extends StatelessWidget {
  const _PhoneStatusBarAndNotch();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Status bar items left & right of notch
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: GreenleafColors.textPrimary,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.signal_cellular_alt_rounded,
                        size: 14,
                        color: GreenleafColors.textPrimary,
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.wifi_rounded,
                        size: 14,
                        color: GreenleafColors.textPrimary,
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.battery_full_rounded,
                        size: 16,
                        color: GreenleafColors.textPrimary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Centered top notch
            Container(
              width: 152,
              height: 30,
              decoration: const BoxDecoration(
                color: GreenleafColors.phoneBezel,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D32),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF374151),
                        width: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 5,
      decoration: BoxDecoration(
        color: const Color(0x401B3A2A),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
