import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// The brand logotype: a crossed spoon-and-fork glyph standing in for the
/// initial "آ", sitting beside "شپزیار" in Reem Kufi — per the handoff's
/// request to visually tie the brand name to a cooking utensil rather than
/// rendering plain text.
class AshpazyarWordmark extends StatelessWidget {
  const AshpazyarWordmark({super.key, this.fontSize = 40});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final s = fontSize / 40;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 22 * s,
          height: 38 * s,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // fork (now on the left)
              Positioned(
                left: 0,
                top: 0,
                child: Transform.rotate(
                  angle: 22 * 3.1415926535 / 180,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 3 * s, height: 10 * s, decoration: BoxDecoration(color: AppColors.turmeric, borderRadius: BorderRadius.circular(2 * s))),
                          SizedBox(width: 2 * s),
                          Container(width: 3 * s, height: 12 * s, decoration: BoxDecoration(color: AppColors.turmeric, borderRadius: BorderRadius.circular(2 * s))),
                          SizedBox(width: 2 * s),
                          Container(width: 3 * s, height: 10 * s, decoration: BoxDecoration(color: AppColors.turmeric, borderRadius: BorderRadius.circular(2 * s))),
                        ],
                      ),
                      Transform.translate(
                        offset: Offset(0, -1 * s),
                        child: Container(width: 4 * s, height: 20 * s, decoration: BoxDecoration(color: AppColors.turmeric, borderRadius: BorderRadius.circular(2 * s))),
                      ),
                    ],
                  ),
                ),
              ),
              // spoon (now on the right)
              Positioned(
                right: 0,
                top: 0,
                child: Transform.rotate(
                  angle: -22 * 3.1415926535 / 180,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 11 * s, height: 14 * s, decoration: const BoxDecoration(color: AppColors.tomato, shape: BoxShape.circle)),
                      Transform.translate(
                        offset: Offset(0, -2 * s),
                        child: Container(width: 4 * s, height: 20 * s, decoration: BoxDecoration(color: AppColors.tomato, borderRadius: BorderRadius.circular(2 * s))),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8 * s),
        Text('شپزیار', style: AppText.heroTitle()),
      ],
    );
  }
}
