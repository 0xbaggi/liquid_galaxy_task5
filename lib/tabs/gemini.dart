import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:liquid_galaxy_ui_components/utils/constant.dart';

class GeminiLogoPage extends StatefulWidget {
  const GeminiLogoPage({Key? key}) : super(key: key);

  @override
  _GeminiLogoPageState createState() => _GeminiLogoPageState();
}

class _GeminiLogoPageState extends State<GeminiLogoPage>
    with TickerProviderStateMixin {
  late AnimationController _tapController;
  late AnimationController _colorController;
  late AnimationController _shapeRotationController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _shapeRotationAnimation;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _color1 = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(_colorController);

    _color2 = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.blueAccent,
    ).animate(_colorController);

    _shapeRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _shapeRotationAnimation =
        Tween<double>(begin: 0.0, end: 2.0 * math.pi).animate(
      CurvedAnimation(parent: _shapeRotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    _colorController.dispose();
    _shapeRotationController.dispose();
    super.dispose();
  }

  void _onPressed() {
    if (_tapController.isCompleted) {
      _tapController.reverse();
      _colorController.stop();
      _shapeRotationController.stop();
    } else {
      _tapController.forward();
      _colorController.repeat(reverse: true);
      _shapeRotationController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: GestureDetector(
              onTap: _onPressed,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _tapController,
                  _colorController,
                  _shapeRotationController,
                ]),
                builder: (context, child) {
                  final ShapeBorder shapeBorder = _colorController.value < 0.5
                      ? const CircleBorder()
                      : const WavyCircle(
                          // Mainly use to define the smoothness of the wave (more points = smoother = less performance)
                          numPoints: 50,
                          waveAmplitude: 7.0,
                          waveCount: 8,
                        );

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: _shapeRotationAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: ShapeDecoration(
                              shape: shapeBorder,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _color1.value ?? Colors.blue,
                                  _color2.value ?? Colors.deepPurple,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Image.asset(
                          'assets/images/gemini.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          const Text("Tap the logo to start the animation",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/*
  This is the custom ShapeBorder class. To implement this class i used the following resources:
    - https://api.flutter.dev/flutter/painting/ShapeBorder-class.html
    - To add the wavy effect to the border i used the Quadratic Bezier formula implemented here:
      https://api.flutter.dev/flutter/dart-ui/Path/quadraticBezierTo.html
*/
class WavyCircle extends ShapeBorder {
  final int numPoints;
  final double waveAmplitude;
  final int waveCount;

  const WavyCircle({
    required this.numPoints,
    required this.waveAmplitude,
    required this.waveCount,
  });

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final double centerX = rect.center.dx;
    final double centerY = rect.center.dy;
    final double radius = rect.width / 2;
    final double angleIncrement = 2 * math.pi / numPoints;

    final List<Offset> points = List.generate(numPoints, (i) {
      final double angle = i * angleIncrement;
      final double currentAmplitude =
          waveAmplitude * math.sin(waveCount * angle);
      final double r = radius + currentAmplitude;

      final double x = centerX + r * math.cos(angle);
      final double y = centerY + r * math.sin(angle);

      return Offset(x, y);
    });

    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < numPoints; i++) {
      final Offset current = points[i];
      final Offset next = points[(i + 1) % numPoints];
      final Offset midPoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );

      path.quadraticBezierTo(current.dx, current.dy, midPoint.dx, midPoint.dy);
    }

    path.close();
    return path;
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => WavyCircle(
        numPoints: (numPoints * t).toInt(),
        waveAmplitude: waveAmplitude * t,
        waveCount: waveCount,
      );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect.deflate(1.0), textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}
