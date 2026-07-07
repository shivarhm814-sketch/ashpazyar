import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Native recreation of the handoff's animated logo mark: a turmeric-to-tomato
/// gradient badge holding a cream pot, two rising steam wisps and three
/// independently flickering flames. Built entirely from Containers + gradients
/// driven by AnimationControllers — no image/Lottie asset, matching the
/// original CSS keyframes (`ghafase-flame-a/b/c`, `ghafase-steam-rise/rise2`).
class AshpazyarLogoMark extends StatefulWidget {
  const AshpazyarLogoMark({super.key, this.size = 104});

  final double size;

  @override
  State<AshpazyarLogoMark> createState() => _AshpazyarLogoMarkState();
}

class _AshpazyarLogoMarkState extends State<AshpazyarLogoMark> with TickerProviderStateMixin {
  late final AnimationController _steam1 =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
  late final AnimationController _steam2 =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
  late final AnimationController _flameA =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final AnimationController _flameB =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 850));
  late final AnimationController _flameC =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

  @override
  void initState() {
    super.initState();
    _steam1.repeat();
    _flameA.repeat();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _steam2.repeat();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _flameB.repeat();
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _flameC.repeat();
    });
  }

  @override
  void dispose() {
    _steam1.dispose();
    _steam2.dispose();
    _flameA.dispose();
    _flameB.dispose();
    _flameC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size / 104;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // gradient badge
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment(-0.42, -0.91),
                end: Alignment(0.42, 0.91),
                colors: [AppColors.turmericLight, AppColors.turmeric, AppColors.tomato],
                stops: [0, 0.42, 1],
              ),
              boxShadow: [
                BoxShadow(color: AppColors.tomato.withValues(alpha: 0.38), blurRadius: 30, offset: const Offset(0, 16)),
              ],
            ),
          ),
          // gloss highlight
          Positioned(
            left: 14 * s,
            top: 10 * s,
            child: Container(
              width: 44 * s,
              height: 26 * s,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.28), borderRadius: BorderRadius.circular(20 * s)),
            ),
          ),
          _buildSteam(left: 42 * s, top: 16 * s, width: 8 * s, height: 19 * s, rotationDeg: 20, controller: _steam1, riseEnd: -10 * s, scaleEnd: 1.3, opacityStart: 0.85),
          _buildSteam(left: 58 * s, top: 20 * s, width: 7 * s, height: 15 * s, rotationDeg: -16, controller: _steam2, riseEnd: -9 * s, scaleEnd: 1.25, opacityStart: 0.6),
          // lid knob
          Positioned(
            left: 48 * s,
            top: 42 * s,
            child: Container(width: 8 * s, height: 8 * s, decoration: const BoxDecoration(color: AppColors.oliveTextOnSoft, shape: BoxShape.circle)),
          ),
          // lid
          Positioned(
            left: 24 * s,
            top: 48 * s,
            child: Container(
              width: 56 * s,
              height: 13 * s,
              decoration: BoxDecoration(
                color: AppColors.olive,
                borderRadius: BorderRadius.circular(20 * s),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 6, offset: Offset(0, 3 * s))],
              ),
            ),
          ),
          // pot body
          Positioned(
            left: 22 * s,
            top: 55 * s,
            child: Container(
              width: 60 * s,
              height: 38 * s,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6 * s),
                  topRight: Radius.circular(6 * s),
                  bottomLeft: Radius.circular(18 * s),
                  bottomRight: Radius.circular(18 * s),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 10, offset: Offset(0, 4 * s))],
              ),
            ),
          ),
          // handles
          Positioned(
            left: 12 * s,
            top: 62 * s,
            child: Container(width: 11 * s, height: 15 * s, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(5 * s))),
          ),
          Positioned(
            left: 81 * s,
            top: 62 * s,
            child: Container(width: 11 * s, height: 15 * s, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(5 * s))),
          ),
          _buildFlame(
            left: 36 * s,
            top: 96 * s,
            width: 11 * s,
            height: 16 * s,
            controller: _flameA,
            scaleY: _keyframeSequence(_flameA, [1, 1.22, 1], [50, 50]),
            scaleX: _keyframeSequence(_flameA, [1, 0.9, 1], [50, 50]),
            rotateDeg: _keyframeSequence(_flameA, [-3, 2, -3], [50, 50]),
            opacity: _keyframeSequence(_flameA, [0.95, 1, 0.95], [50, 50]),
            colors: const [Color(0xFFFFC98A), AppColors.turmeric, AppColors.tomato],
            stops: const [0, 0.55, 1],
          ),
          _buildFlame(
            left: 48 * s,
            top: 92 * s,
            width: 14 * s,
            height: 22 * s,
            controller: _flameB,
            scaleY: _keyframeSequence(_flameB, [1.05, 0.85, 1.05], [45, 55]),
            scaleX: _keyframeSequence(_flameB, [1, 1.1, 1], [45, 55]),
            rotateDeg: _keyframeSequence(_flameB, [4, -3, 4], [45, 55]),
            opacity: _keyframeSequence(_flameB, [0.9, 1, 0.9], [45, 55]),
            colors: const [Color(0xFFFFE0B8), AppColors.turmericLight, AppColors.tomato],
            stops: const [0, 0.4, 1],
          ),
          _buildFlame(
            left: 62 * s,
            top: 97 * s,
            width: 10 * s,
            height: 15 * s,
            controller: _flameC,
            scaleY: _keyframeSequence(_flameC, [1, 1.18, 1], [55, 45]),
            scaleX: const AlwaysStoppedAnimation(1.0),
            rotateDeg: _keyframeSequence(_flameC, [-6, 5, -6], [55, 45]),
            opacity: _keyframeSequence(_flameC, [0.8, 1, 0.8], [55, 45]),
            colors: const [Color(0xFFFFC98A), AppColors.turmeric, AppColors.tomato],
            stops: const [0, 0.55, 1],
          ),
        ],
      ),
    );
  }

  Animation<double> _keyframeSequence(
    AnimationController controller,
    List<double> values,
    List<double> weights,
  ) {
    final items = <TweenSequenceItem<double>>[];
    for (var i = 0; i < weights.length; i++) {
      items.add(TweenSequenceItem(tween: Tween(begin: values[i], end: values[i + 1]), weight: weights[i]));
    }
    return TweenSequence(items).animate(controller);
  }

  Widget _buildSteam({
    required double left,
    required double top,
    required double width,
    required double height,
    required double rotationDeg,
    required AnimationController controller,
    required double riseEnd,
    required double scaleEnd,
    required double opacityStart,
  }) {
    final curved = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: curved,
        builder: (context, child) {
          final t = curved.value;
          final dy = riseEnd * t;
          final scale = 1 + (scaleEnd - 1) * t;
          final opacity = opacityStart * (1 - t);
          return Opacity(
            opacity: opacity.clamp(0.0, 1.0).toDouble(),
            child: Transform.translate(
              offset: Offset(0, dy),
              child: Transform.rotate(
                angle: rotationDeg * math.pi / 180,
                child: Transform.scale(scale: scale, child: child),
              ),
            ),
          );
        },
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(width),
              topRight: Radius.circular(width),
              bottomLeft: Radius.circular(width),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlame({
    required double left,
    required double top,
    required double width,
    required double height,
    required AnimationController controller,
    required Animation<double> scaleY,
    required Animation<double> scaleX,
    required Animation<double> rotateDeg,
    required Animation<double> opacity,
    required List<Color> colors,
    required List<double> stops,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Opacity(
            opacity: opacity.value.clamp(0.0, 1.0).toDouble(),
            child: Transform.rotate(
              angle: rotateDeg.value * math.pi / 180,
              child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..scaleByDouble(scaleX.value, scaleY.value, 1.0, 1.0),
                child: child,
              ),
            ),
          );
        },
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors, stops: stops),
            borderRadius: BorderRadius.vertical(top: Radius.circular(width * 0.6), bottom: Radius.circular(width * 0.4)),
          ),
        ),
      ),
    );
  }
}
